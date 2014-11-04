/*
 Copyright (C) 2012-2014 Soomla Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "UpgradeVG.h"
#import "StoreJSONConsts.h"
#import "StorageManager.h"
#import "VirtualGoodStorage.h"
#import "SoomlaUtils.h"
#import "StoreInfo.h"
#import "VirtualItemNotFoundException.h"

@implementation UpgradeVG

@synthesize prevGoodItemId, goodItemId, nextGoodItemId;

static NSString* TAG = @"SOOMLA UpgradeVG";

- (id)initWithName:(NSString *)oName andDescription:(NSString *)oDescription andItemId:(NSString *)oItemId andPurchaseType:(PurchaseType *)oPurchaseType andLinkedGood:(NSString*)oGoodItemId andPreviousUpgrade:(NSString*)oPrevItemId andNextUpgrade:(NSString*)oNextItemId {
    if (self = [super initWithName:oName andDescription:oDescription andItemId:oItemId andPurchaseType:oPurchaseType]) {
        self.prevGoodItemId = oPrevItemId;
        self.goodItemId = oGoodItemId;
        self.nextGoodItemId = oNextItemId;
    }
    
    return self;
}

/*
 see parent
 
 @param dict see parent.
 */
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.goodItemId = [dict objectForKey:JSON_VGU_GOOD_ITEMID];
        self.prevGoodItemId = [dict objectForKey:JSON_VGU_PREV_ITEMID];
        self.nextGoodItemId = [dict objectForKey:JSON_VGU_NEXT_ITEMID];
    }
    
    return self;
}

/*
 see parent

 @return see parent.
 */
- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:self.goodItemId forKey:JSON_VGU_GOOD_ITEMID];
    [toReturn setValue:(self.prevGoodItemId ? self.prevGoodItemId : @"") forKey:JSON_VGU_PREV_ITEMID];
    [toReturn setValue:(self.nextGoodItemId ? self.nextGoodItemId : @"") forKey:JSON_VGU_NEXT_ITEMID];
    
    return toReturn;
}

/**
 Assigns the current upgrade to the associated VirtualGood.
 
 NOTE: This action doesn't check anything! It just assigns the current UpgradeVG 
 to the associated good.
 
 @param amount Not used here.
 @param notify see parent.
 @return 1 if the user was given the good, 0 otherwise.
 */
- (int)giveAmount:(int)amount withEvent:(BOOL)notify {
    LogDebug(TAG, ([NSString stringWithFormat:@"Assigning %@ to: %@", self.name, self.goodItemId]));
    
    VirtualGood* good = NULL;
    @try {
        good = (VirtualGood*)[[StoreInfo getInstance] virtualItemWithId:self.goodItemId];
    } @catch (VirtualItemNotFoundException* ex) {
        LogError(TAG, ([NSString stringWithFormat:@"VirtualGood with itemId: %@ doesn't exist! Can't upgrade.", self.goodItemId]));
        return 0;
    }
    [[[StorageManager getInstance] virtualGoodStorage] assignCurrentUpgrade:self.itemId toGood:good.itemId withEvent:notify];
    
    return [super giveAmount:amount withEvent:notify];
}

/**
 Takes the Upgrade from the user, or in other words DOWNGRADES the associated 
 `VirtualGood`. Checks if the current Upgrade is really associated with the 
 `VirtualGood` and:
   if YES - downgrades to the previous upgrade (or remove upgrades in case of 
            null).
   if NO  - returns 0 (does nothing).
 
 @param amount Not used here.
 @param notify see parent.
 @return see parent.
 */
- (int)takeAmount:(int)amount withEvent:(BOOL)notify {
    VirtualGood* good = NULL;
    @try {
        good = (VirtualGood*)[[StoreInfo getInstance] virtualItemWithId:self.goodItemId];
    } @catch (VirtualItemNotFoundException* ex) {
        LogError(TAG, ([NSString stringWithFormat:@"VirtualGood with itemId: %@ doesn't exist! Can't downgrade.", self.goodItemId]));
        return 0;
    }
    NSString* upgradeVGItemId = [[[StorageManager getInstance] virtualGoodStorage] currentUpgradeOf:good.itemId];
    UpgradeVG* upgradeVG = NULL;
    @try {
        upgradeVG = (UpgradeVG*)[[StoreInfo getInstance] virtualItemWithId:upgradeVGItemId];
    } @catch (VirtualItemNotFoundException* e) {
        LogDebug(TAG, ([NSString stringWithFormat:@"This is BAD! Can't find the current upgrade (%@) of: %@", upgradeVGItemId, good.itemId]));
    }
    if (upgradeVG != self) {
        LogError(TAG, ([NSString stringWithFormat:@"You can't take what's not yours. The UpgradeVG %@ is not assigned to the VirtualGood: %@. (or maybe it's NULL?)", self.name, good.name]));
        return 0;
    }
    
    if (self.prevGoodItemId && self.prevGoodItemId.length>0) {
        UpgradeVG* prevUpgradeVG = NULL;
        @try {
            prevUpgradeVG = (UpgradeVG*)[[StoreInfo getInstance]virtualItemWithId:self.prevGoodItemId];
        } @catch (VirtualItemNotFoundException* ex) {
            LogError(TAG, ([NSString stringWithFormat:@"Previous UpgradeVG with itemId: %@ doesn't exist! Can't downgrade.", self.prevGoodItemId]));
            return 0;
        }
        
        LogDebug(TAG, ([NSString stringWithFormat:@"Downgrading %@ to %@", good.name, prevUpgradeVG.name]));
        [[[StorageManager getInstance] virtualGoodStorage] assignCurrentUpgrade:prevUpgradeVG.itemId toGood:good.itemId withEvent:notify];
    } else {
        LogDebug(TAG, ([NSString stringWithFormat:@"Downgrading %@ to NO-UPGRADE", good.name]));
        [[[StorageManager getInstance] virtualGoodStorage] removeUpgradesFrom:good.itemId withEvent:notify];
    }
    
    return [super takeAmount:amount withEvent:notify];
}

/**
 Determines if the user is in a state that allows him/her to buy an UpgradeVG.
 This method enforces allowing/rejecting of upgrades here so users won't buy 
 them when they are not supposed to.
 NOTE: If you want to give your users free upgrades, use the "give" function.
 
 @return see parent.
 */
- (BOOL)canBuy {
    VirtualGood* good = NULL;
    @try {
        good = (VirtualGood*)[[StoreInfo getInstance] virtualItemWithId:self.goodItemId];
    } @catch (VirtualItemNotFoundException* ex) {
        LogError(TAG, ([NSString stringWithFormat:@"VirtualGood with itemId: %@ doesn't exist! Returning NO (can't buy).", self.goodItemId]));
        return NO;
    }
    NSString* upgradeVGItemId = [[[StorageManager getInstance] virtualGoodStorage] currentUpgradeOf:good.itemId];
    UpgradeVG* upgradeVG = NULL;
    @try {
        upgradeVG = (UpgradeVG*)[[StoreInfo getInstance] virtualItemWithId:upgradeVGItemId];
    } @catch (VirtualItemNotFoundException* e) {
        LogDebug(TAG, ([NSString stringWithFormat:@"This is BAD! Can't find the current upgrade (%@) of: %@", upgradeVGItemId, good.itemId]));
    }
    return (((!upgradeVG && (!self.prevGoodItemId || (self.prevGoodItemId.length == 0))) ||
            (upgradeVG && (([upgradeVG.nextGoodItemId isEqualToString:self.itemId]) || ([upgradeVG.prevGoodItemId isEqualToString:self.itemId]))))
            && [super canBuy]);
}

@end
