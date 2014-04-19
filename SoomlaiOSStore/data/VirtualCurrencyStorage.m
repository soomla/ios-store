/*
 * Copyright (C) 2012 Soomla Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "VirtualCurrencyStorage.h"
#import "VirtualCurrency.h"
#import "StorageManager.h"
#import "EventHandling.h"
#import "KeyValDatabase.h"

@implementation VirtualCurrencyStorage

- (id)init {
    if (self = [super init]) {
        tag = @"SOOMLA VirtualCurrencyStorage";
    }
    return self;
}

- (NSString*)keyBalance:(NSString*)itemId {
    return [KeyValDatabase keyCurrencyBalance:itemId];
}

- (void)postBalanceChangeToItem:(VirtualItem*)item withBalance:(int)balance andAmountAdded:(int)amountAdded {
    [EventHandling postChangedBalance:balance forCurrency:(VirtualCurrency*)item withAmount:amountAdded];
}

- (void)postBalanceUnchangeToItem:(VirtualItem*)item withBalance:(int)balance andAmountAdded:(int)amountAdded {
    [EventHandling postUnchangedBalance:balance forCurrency:(VirtualCurrency*)item withAmount:amountAdded];
}

@end
