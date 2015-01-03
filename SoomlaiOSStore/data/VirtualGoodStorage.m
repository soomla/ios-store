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

#import "VirtualGoodStorage.h"
#import "VirtualGood.h"
#import "StorageManager.h"
#import "StoreEventHandling.h"
#import "SoomlaUtils.h"
#import "StoreInfo.h"
#import "VirtualItemNotFoundException.h"
#import "UpgradeVG.h"
#import "EquippableVG.h"
#import "KeyValueStorage.h"

@implementation VirtualGoodStorage

- (id)init {
    if (self = [super init]) {
        tag = @"SOOMLA VirtualGoodStorage";
    }
    return self;
}

- (void)removeUpgradesFrom:(NSString*)goodItemId {
    [self removeUpgradesFrom:goodItemId withEvent:YES];
}

- (void)removeUpgradesFrom:(NSString*)goodItemId withEvent:(BOOL)notify {
    LogDebug(tag, ([NSString stringWithFormat:@"Removing upgrade information from virtual good: %@", goodItemId]));
    
    NSString* key = [VirtualGoodStorage keyGoodUpgrade:goodItemId];
    
    [KeyValueStorage deleteValueForKey:key];
    
    [StoreEventHandling postGoodUpgrade:goodItemId withGoodUpgrade:nil];
}

- (void)assignCurrentUpgrade:(NSString*)upgradeVGItemId toGood:(NSString*)goodItemId {
    [self assignCurrentUpgrade:upgradeVGItemId toGood:goodItemId withEvent:YES];
}

- (void)assignCurrentUpgrade:(NSString*)upgradeVGItemId toGood:(NSString*)goodItemId withEvent:(BOOL)notify {
    if ([[self currentUpgradeOf:goodItemId] isEqualToString:upgradeVGItemId]) {
        return;
    }
    
    LogDebug(tag, ([NSString stringWithFormat:@"Assigning upgrade %@ to virtual good: %@", upgradeVGItemId, goodItemId]));
    
    NSString* key = [VirtualGoodStorage keyGoodUpgrade:goodItemId];
    
    [KeyValueStorage setValue:upgradeVGItemId forKey:key];
    
    if (notify) {
        [StoreEventHandling postGoodUpgrade:goodItemId withGoodUpgrade:upgradeVGItemId];
    }
}

- (NSString*)currentUpgradeOf:(NSString*)goodItemId {
    LogDebug(tag, ([NSString stringWithFormat:@"Fetching upgrade to virtual good: %@", goodItemId]));
    
    NSString* key = [VirtualGoodStorage keyGoodUpgrade:goodItemId];
    
    NSString* upItemId = [KeyValueStorage getValueForKey:key];
    
    if(!upItemId) {
        LogDebug(tag, ([NSString stringWithFormat:@"You tried to fetch the current upgrade of %@ but there's no upgrade in the DB for it.", goodItemId]));
        return nil;
    }
    
    @try {
        return upItemId;
    } @catch (VirtualItemNotFoundException* ex){
        LogError(tag, @"The current upgrade's itemId from the DB is not found in StoreInfo.");
    } @catch (NSException* e) {
        LogError(tag, @"Something bad happend while trying to decrypt or fetch current upgrade.");
    }
    
    return nil;
}

- (BOOL)isGoodEquipped:(NSString*)goodItemId {
    LogDebug(tag, ([NSString stringWithFormat:@"checking if virtual good with itemId: %@ is equipped", goodItemId]));
    
    NSString* key = [VirtualGoodStorage keyGoodEquipped:goodItemId];
    NSString* val = [KeyValueStorage getValueForKey:key];
    
    if (!val || [val length]==0){
        return NO;
    }
    
    // we're returning YES as long as there's a value for the required key.
    return YES;
}

- (void)equipGood:(NSString*)goodItemId {
    [self equipGood:goodItemId withEvent:YES];
}
- (void)equipGood:(NSString*)goodItemId withEvent:(BOOL)notify {
    if ([self isGoodEquipped:goodItemId]) {
        return;
    }
    
    [self privEquipGood:goodItemId withEquipValue:YES withEvent:notify];
}

- (void)unequipGood:(NSString*)goodItemId {
    [self unequipGood:goodItemId withEvent:YES];
}
- (void)unequipGood:(NSString*)goodItemId withEvent:(BOOL)notify {
    if (![self isGoodEquipped:goodItemId]) {
        return;
    }
    
    [self privEquipGood:goodItemId withEquipValue:NO withEvent:notify];
}

- (void)privEquipGood:(NSString*)goodItemId withEquipValue:(BOOL)equip withEvent:(BOOL)notify{
    LogDebug(tag, ([NSString stringWithFormat:@"%@ %@.", (equip ? @"equipping" : @"unequipping"), goodItemId]));
    
    NSString* key = [VirtualGoodStorage keyGoodEquipped:goodItemId];
    
    if (equip) {
        [KeyValueStorage setValue:@"equipped" forKey:key];
        if (notify) {
            [StoreEventHandling postGoodEquipped:goodItemId];
        }
    } else {
        [KeyValueStorage deleteValueForKey:key];
        if (notify) {
            [StoreEventHandling postGoodUnEquipped:goodItemId];
        }
    }
}

/**
 * see parent
 */
- (NSString*)keyBalance:(NSString*)itemId {
    return [VirtualGoodStorage keyGoodBalance:itemId];
}

/**
 * see parent
 */
- (void)postBalanceChangeToItem:(NSString*)itemItemId withBalance:(int)balance andAmountAdded:(int)amountAdded {
    [StoreEventHandling postChangedBalance:balance forGood:itemItemId withAmount:amountAdded];
}

+ (NSString*) keyGoodBalance:(NSString*)itemId {
    return [NSString stringWithFormat:@"%@%@.balance", DB_KEY_GOOD_PREFIX, itemId];
}

+ (NSString*) keyGoodEquipped:(NSString*)itemId {
    return [NSString stringWithFormat:@"%@%@.equipped", DB_KEY_GOOD_PREFIX, itemId];
}

+ (NSString*) keyGoodUpgrade:(NSString*)itemId {
    return [NSString stringWithFormat:@"%@%@.currentUpgrade", DB_KEY_GOOD_PREFIX, itemId];
}

@end
