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

#import "StoreInventory.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"
#import "StorageManager.h"
#import "StoreInfo.h"
#import "VirtualCurrencyStorage.h"
#import "VirtualGoodStorage.h"
#import "PurchasableVirtualItem.h"
#import "UpgradeVG.h"
#import "EquippableVG.h"
#import "VirtualItemNotFoundException.h"
#import "SoomlaUtils.h"
#import "KeyValueStorage.h"


@implementation StoreInventory

static NSString* TAG = @"SOOMLA StoreInventory";

+ (void)buyItemWithItemId:(NSString*)itemId andPayload:(NSString*)payload{
    PurchasableVirtualItem* pvi = (PurchasableVirtualItem*) [[StoreInfo getInstance] virtualItemWithId:itemId];
    [pvi buyWithPayload:payload];
}

+ (int)getItemBalance:(NSString*)itemId {
    VirtualItem* item = [[StoreInfo getInstance] virtualItemWithId:itemId];
    return [[[StorageManager getInstance] virtualItemStorage:item] balanceForItem:item.itemId];
}

+ (void)giveAmount:(int)amount ofItem:(NSString*)itemId {
    VirtualItem* item = [[StoreInfo getInstance] virtualItemWithId:itemId];
    [item giveAmount:amount];
}

+ (void)takeAmount:(int)amount ofItem:(NSString*)itemId {
    VirtualItem* item = [[StoreInfo getInstance] virtualItemWithId:itemId];
    [item takeAmount:amount];
}

+ (void)equipVirtualGoodWithItemId:(NSString*)goodItemId {
    EquippableVG* good = (EquippableVG*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
    
    [good equip];
}

+ (void)unEquipVirtualGoodWithItemId:(NSString*)goodItemId {
    EquippableVG* good = (EquippableVG*)[[StoreInfo getInstance] virtualItemWithId:goodItemId];
    
    [good unequip];
}

+ (BOOL)isVirtualGoodWithItemIdEquipped:(NSString*)goodItemId {
    return [[[StorageManager getInstance] virtualGoodStorage] isGoodEquipped:goodItemId];
}

+ (int)goodUpgradeLevel:(NSString*)goodItemId {
    NSString* upgradeVGItemId = [[[StorageManager getInstance] virtualGoodStorage] currentUpgradeOf:goodItemId];
    if (!upgradeVGItemId || [upgradeVGItemId isEqualToString:@""]) {
        return 0;
    }
    
    UpgradeVG* first = [[StoreInfo getInstance] firstUpgradeForGoodWithItemId:goodItemId];
    int level = 1;
    while (![first.itemId isEqualToString:upgradeVGItemId]) {
        first = (UpgradeVG*)[[StoreInfo getInstance] virtualItemWithId:first.nextGoodItemId];
        level++;
    }
    
    return level;
}

+ (NSString*)goodCurrentUpgrade:(NSString*)goodItemId {
    NSString* upgradeVGItemId = [[[StorageManager getInstance] virtualGoodStorage] currentUpgradeOf:goodItemId];
    if (!upgradeVGItemId || [upgradeVGItemId isEqualToString:@""]) {
        return @"";
    }
    
    return upgradeVGItemId;
}

+ (void)upgradeVirtualGood:(NSString*)goodItemId {
    NSString* upgradeVGItemId = [[[StorageManager getInstance] virtualGoodStorage] currentUpgradeOf:goodItemId];
    UpgradeVG* upgradeVG = NULL;
    @try {
        upgradeVG = (UpgradeVG*)[[StoreInfo getInstance] virtualItemWithId:upgradeVGItemId];
    } @catch (VirtualItemNotFoundException* e) {
        LogDebug(TAG, ([NSString stringWithFormat:@"This is BAD! Can't find the current upgrade (%@) of: %@", upgradeVGItemId, goodItemId]));
    }
    if (upgradeVG) {
        NSString* nextItemId = upgradeVG.nextGoodItemId;
        if ((!nextItemId) ||
            (nextItemId.length == 0)) {
            return;
        }
        UpgradeVG* vgu = (UpgradeVG*)[[StoreInfo getInstance] virtualItemWithId:nextItemId];
        [vgu buyWithPayload:@""];
    } else {
        UpgradeVG* first = [[StoreInfo getInstance] firstUpgradeForGoodWithItemId:goodItemId];
        if (first) {
            [first buyWithPayload:@""];
        }
    }
}

+ (void)forceUpgrade:(NSString*)upgradeItemId {
    @try {
        UpgradeVG* upgradeVG = (UpgradeVG*) [[StoreInfo getInstance] virtualItemWithId:upgradeItemId];
        [upgradeVG giveAmount:1];
    } @catch (NSException* ex) {
        if ([ex isKindOfClass:[VirtualItemNotFoundException class]]) {
            @throw ex;
        } else {
            LogError(@"SOOMLA StoreInventory", @"The given itemId was of a non UpgradeVG VirtualItem. Can't force it.");
        }
    }
}

+ (void)removeUpgrades:(NSString*)goodItemId {
    NSArray* upgrades = [[StoreInfo getInstance] upgradesForGoodWithItemId:goodItemId];
    for(UpgradeVG* upgrade in upgrades) {
        [[[StorageManager getInstance] virtualGoodStorage] removeAmount:1 fromItem:upgrade.itemId withEvent:YES];
    }
    
    [[[StorageManager getInstance] virtualGoodStorage] removeUpgradesFrom:goodItemId];
}

+ (NSDictionary*)allItemsBalances {
    NSMutableDictionary *itemsDict = [[NSMutableDictionary alloc] init];
    
    for (VirtualCurrency* currency in [[StoreInfo getInstance] virtualCurrencies]) {
        NSMutableDictionary *updatedValues = [NSMutableDictionary dictionary];
        updatedValues[@"balance"] = @((int)[[[StorageManager getInstance] virtualCurrencyStorage] balanceForItem:currency.itemId]);
        
        itemsDict[currency.itemId] = updatedValues;
    }
    
    for (VirtualGood* good in [[StoreInfo getInstance] virtualGoods]) {
        
        NSMutableDictionary *updatedValues = [NSMutableDictionary dictionary];
        VirtualGoodStorage* virtualGoodStorage = [[StorageManager getInstance] virtualGoodStorage];
        updatedValues[@"balance"] = @([virtualGoodStorage balanceForItem:good.itemId]);
        
        if ([good isKindOfClass:NSClassFromString(@"EquippableVG")]) {
            updatedValues[@"equipped"] = @([virtualGoodStorage isGoodEquipped:good.itemId]);
        }
        
        if ([[StoreInfo getInstance] goodHasUpgrades:good.itemId]) {
            NSString* vguId = [virtualGoodStorage currentUpgradeOf:good.itemId];
            updatedValues[@"currentUpgrade"] = (vguId ? vguId : @"none");
        }
        
        itemsDict[good.itemId] = updatedValues;
    }
    
    return itemsDict;
}

+ (BOOL)resetAllItemsBalances:(NSDictionary *)replaceBalances {
    if (!replaceBalances) {
        return NO;
    }
    
    LogDebug(TAG, @"Resetting balances");
    
    [self clearCurrentState];
    
    LogDebug(TAG, @"Current state was cleared");
    
    @try {
        for (NSString *itemId in replaceBalances) {
            NSDictionary *updatedValues = replaceBalances[itemId];
            
            VirtualItem *item = nil;
            @try {
                item = [[StoreInfo getInstance] virtualItemWithId:itemId];
            }
            @catch (NSException *exception) {
                LogError(TAG, ([NSString stringWithFormat:@"The given itemId %@ was not found. Can't force it.", itemId]));
                continue;
            }
            
            NSNumber *updatedBalance = updatedValues[@"balance"];
            if (updatedBalance) {
                [item resetBalance:[updatedBalance intValue] withEvent:NO];
                LogDebug(TAG, ([NSString stringWithFormat:@"finished balance sync for itemId: %@", itemId]));
            }
            
            NSNumber *rawEquippedState = updatedValues[@"equipped"];
            if (rawEquippedState) {
                @try {
                    EquippableVG* equippableItem = (EquippableVG*)item;
                    if (equippableItem) {
                        BOOL equipState = [rawEquippedState boolValue];
                        if (equipState) {
                            [equippableItem equipWithEvent:NO];
                        }
                        else {
                            [equippableItem unequipWithEvent:NO];
                        }
                    }
                    LogDebug(TAG, ([NSString stringWithFormat:@"finished equip balance sync for itemId: %@", itemId]));
                }
                @catch (NSException *exception) {
                    LogError(TAG, ([NSString stringWithFormat:@"tried to equip a non-equippable item: %@", itemId]));
                }
            }
            
            NSString *currentUpgradeId = updatedValues[@"currentUpgrade"];
            if (currentUpgradeId && (currentUpgradeId.length != 0)) {
                @try {
                    UpgradeVG *upgradeVG = (UpgradeVG*)[[StoreInfo getInstance] virtualItemWithId:currentUpgradeId];
                    [upgradeVG giveAmount:1 withEvent:NO];
                    LogDebug(TAG, ([NSString stringWithFormat:@"finished upgrade balance sync for itemId: %@", currentUpgradeId]));
                }
                @catch (NSException *exception) {
                    LogDebug(TAG, ([NSString stringWithFormat:@"The given upgradeId was of a non UpgradeVG VirtualItem. Can't force it. itemId: %@", currentUpgradeId]));
                }
            }
        }
        
        return YES;
    }
    @catch (NSException *exception) {
        LogDebug(TAG, ([NSString stringWithFormat:@"Unknown error has occurred while resetting item balances %@", exception.description]));
    }
    
    return NO;
}

+ (void)clearCurrentState {
    NSArray *allKeys = [KeyValueStorage getEncryptedKeys];
    for (NSString *key in allKeys) {
        if (([key rangeOfString:DB_NONCONSUMABLE_KEY_PREFIX].length > 0) ||
            ([key rangeOfString:DB_CURRENCY_KEY_PREFIX].length > 0) ||
            ([key rangeOfString:DB_KEY_GOOD_PREFIX].length > 0)) {
            [KeyValueStorage deleteValueForKey:key];
        }
    }
}

@end
