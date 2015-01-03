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

#import "VirtualCurrencyStorage.h"
#import "VirtualCurrency.h"
#import "StorageManager.h"
#import "StoreEventHandling.h"
#import "KeyValDatabase.h"

@implementation VirtualCurrencyStorage

- (id)init {
    if (self = [super init]) {
        tag = @"SOOMLA VirtualCurrencyStorage";
    }
    return self;
}

/**
 Retrieves the balance of the virtual item with the given `itemId` (from the `KeyValDatabase`).
 
 @param itemId Id of the virtual item whose balance is to be retrieved.
 @return A string that contains the name of the storage base, the itemId, and balance.
 */
- (NSString*)keyBalance:(NSString*)itemId {
    return [VirtualCurrencyStorage keyCurrencyBalance:itemId];
}

/**
 Posts an event with the given amount changed in the given balance of the given virtual item.
 
 @param item The virtual item whose balance has changed.
 @param balance The balance that has changed.
 @param amountAdded The amount added to the item's balance.
 */
- (void)postBalanceChangeToItem:(NSString*)itemItemId withBalance:(int)balance andAmountAdded:(int)amountAdded {
    [StoreEventHandling postChangedBalance:balance forCurrency:itemItemId withAmount:amountAdded];
}

+ (NSString*) keyCurrencyBalance:(NSString*)itemId {
    return [NSString stringWithFormat:@"%@%@.balance", DB_CURRENCY_KEY_PREFIX, itemId];
}

@end
