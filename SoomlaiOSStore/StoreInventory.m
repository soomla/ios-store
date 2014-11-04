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

@end
