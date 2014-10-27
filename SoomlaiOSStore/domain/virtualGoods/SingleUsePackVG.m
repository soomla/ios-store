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

#import "SingleUsePackVG.h"
#import "StoreJSONConsts.h"
#import "StorageManager.h"
#import "VirtualGoodStorage.h"
#import "SingleUseVG.h"
#import "StoreInfo.h"
#import "SoomlaUtils.h"
#import "VirtualItemNotFoundException.h"

@implementation SingleUsePackVG

@synthesize amount, goodItemId;

static NSString* TAG = @"SOOMLA SingleUsePackVG";

- (id)initWithName:(NSString *)oName andDescription:(NSString *)oDescription andItemId:(NSString *)oItemId andPurchaseType:(PurchaseType *)oPurchaseType andSingleUseGood:(NSString*)oGoodItemId andAmount:(int)oAmount {
    if (self = [super initWithName:oName andDescription:oDescription andItemId:oItemId andPurchaseType:oPurchaseType]) {
        self.goodItemId = oGoodItemId;
        self.amount = oAmount;
    }
    
    return self;
}

/*
 see parent
 
 @param dict see parent.
 */
- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.goodItemId = [dict objectForKey:JSON_VGP_GOOD_ITEMID];
        self.amount = [[dict objectForKey:JSON_VGP_GOOD_AMOUNT] intValue];
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
    [toReturn setValue:[NSNumber numberWithInt:self.amount] forKey:JSON_VGP_GOOD_AMOUNT];
    [toReturn setValue:self.goodItemId forKey:JSON_VGP_GOOD_ITEMID];
    
    return toReturn;
}

/*
 see parent
 
 @param oAmount see parent.
 @return see parent.
 */
- (int)giveAmount:(int)oAmount withEvent:(BOOL)notify {
    SingleUseVG* good = NULL;
    @try {
        good = (SingleUseVG*)[[StoreInfo getInstance] virtualItemWithId:self.goodItemId];
    } @catch (VirtualItemNotFoundException* ex) {
        LogError(TAG, ([NSString stringWithFormat:@"SingleUseVG with itemId: %@ doesn't exist! Can't give this pack.", self.goodItemId]));
        return 0;
    }
    return [[[StorageManager getInstance] virtualGoodStorage] addAmount:self.amount*oAmount toItem:good.itemId withEvent:notify];
}

/*
 see parent
 
 @param oAmount see parent.
 @return see parent.
 */
- (int)takeAmount:(int)oAmount withEvent:(BOOL)notify {
    SingleUseVG* good = NULL;
    @try {
        good = (SingleUseVG*)[[StoreInfo getInstance] virtualItemWithId:self.goodItemId];
    } @catch (VirtualItemNotFoundException* ex) {
        LogError(TAG, ([NSString stringWithFormat:@"SingleUseVG with itemId: %@ doesn't exist! Can't take this pack.", self.goodItemId]));
        return 0;
    }
    return [[[StorageManager getInstance] virtualGoodStorage] removeAmount:self.amount*oAmount fromItem:good.itemId withEvent:notify];
}

/*
 see parent

 @return see parent.
 */
- (BOOL)canBuy {
    return YES;
}

@end
