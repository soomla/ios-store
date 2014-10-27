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

#import "EquippableVG.h"
#import "StoreJSONConsts.h"
#import "StorageManager.h"
#import "VirtualGoodStorage.h"
#import "NotEnoughGoodsException.h"
#import "VirtualItemNotFoundException.h"
#import "SoomlaUtils.h"
#import "VirtualCategory.h"
#import "StoreInfo.h"

@implementation EquippableVG

@synthesize equippingModel;

static NSString* TAG = @"SOOMLA equippingModel";

- (id)initWithName:(NSString *)oName andDescription:(NSString *)oDescription
         andItemId:(NSString *)oItemId andPurchaseType:(PurchaseType *)oPurchaseType andEquippingModel:(EquippingModel)oEquippingModel {
    if (self = [super initWithName:oName andDescription:oDescription andItemId:oItemId andPurchaseType:oPurchaseType]) {
        self.equippingModel = oEquippingModel;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        NSString* equipping = [dict objectForKey:JSON_EQUIPPABLE_EQUIPPING];
        if ([equipping isEqualToString:[EquippableVG equippingModelEnumToString:kLocal]]) {
            self.equippingModel = kLocal;
        } else if ([equipping isEqualToString:[EquippableVG equippingModelEnumToString:kCategory]]) {
            self.equippingModel = kCategory;
        } else if ([equipping isEqualToString:[EquippableVG equippingModelEnumToString:kGlobal]]) {
            self.equippingModel = kGlobal;
        }
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSString* equipping = [EquippableVG equippingModelEnumToString:kLocal];
    if (self.equippingModel == kCategory) {
        equipping = [EquippableVG equippingModelEnumToString:kCategory];
    } else if (self.equippingModel == kGlobal) {
        equipping = [EquippableVG equippingModelEnumToString:kGlobal];
    }
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:equipping forKey:JSON_EQUIPPABLE_EQUIPPING];
    
    return toReturn;
}

- (void)equip {
    [self equipWithEvent:YES];
}

- (void)equipWithEvent:(BOOL)notify {
    // only if the user has bought this EquippableVG, the EquippableVG is equipped.
    if ([[[StorageManager getInstance] virtualGoodStorage] balanceForItem:self.itemId] > 0) {
        
        if (self.equippingModel == kCategory) {
            @try {
                VirtualCategory* category = [[StoreInfo getInstance] categoryForGoodWithItemId:self.itemId];
                
                for(NSString* goodItemId in category.goodsItemIds) {
                    EquippableVG* equippableVG = nil;
                    @try {
                        equippableVG = (EquippableVG*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
						if (![goodItemId isEqualToString:self.itemId]) {
                            [equippableVG unequip];
                        }
                    } @catch (VirtualItemNotFoundException* ex) {
                        LogError(TAG, ([NSString stringWithFormat:@"On equip, couldn't find one of the itemIds in the category. Continuing to the next one. itemId: %@", goodItemId]));
                        continue;
                    } @catch (NSException* e) {
                        LogDebug(TAG, ([NSString stringWithFormat:@"On equip, an error occured. It's a debug message b/c the VirtualGood may just not be an EquippableVG. itemId: %@", goodItemId]));
                        continue;
                    }
                }
            } @catch (VirtualItemNotFoundException* ex) {
                LogError(TAG, ([NSString stringWithFormat:@"Tried to unequip all other category VirtualGoods but there was no associated category. virtual good itemId: %@", self.itemId]));
            }
        } else if (self.equippingModel == kGlobal) {
            NSArray* goods = [[StoreInfo getInstance] virtualGoods];
            for(VirtualGood* good in goods) {
                if ((![good.itemId isEqualToString:self.itemId]) &&
                    [good isKindOfClass:[EquippableVG class]]) {
                    [((EquippableVG*)good) unequipWithEvent:notify];
                }
            }
        }
        
        // equipping the current good
        [[[StorageManager getInstance] virtualGoodStorage] equipGood:self.itemId withEvent:notify];
        
    } else {
        @throw [[NotEnoughGoodsException alloc] initWithItemId:self.itemId];
    }
}

- (void)unequip {
    [self unequipWithEvent:YES];
}

- (void)unequipWithEvent:(BOOL)notify {
    [[[StorageManager getInstance] virtualGoodStorage] unequipGood:self.itemId withEvent:notify];
}

+(NSString*) equippingModelEnumToString:(EquippingModel)emVal
{
    NSArray *emArray = [[NSArray alloc] initWithObjects:EquippingModelArray];
    return [emArray objectAtIndex:emVal];
}

+(EquippingModel) equippingModelStringToEnum:(NSString*)emStr
{
    NSArray *emArray = [[NSArray alloc] initWithObjects:EquippingModelArray];
    NSUInteger n = [emArray indexOfObject:emStr];
    if(n < 1) n = kLocal;
    return (EquippingModel) n;
}

@end
