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


#import "EventHandling.h"
#import "AppStoreItem.h"
#import "VirtualGood.h"

@implementation EventHandling

+ (void)observeAllEventsWithObserver:(id)observer withSelector:(SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_BILLING_NOT_SUPPORTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_BILLING_SUPPORTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_CLOSING_STORE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_CURRENCY_BALANCE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_GOOD_BALANCE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_GOOD_EQUIPPED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_GOOD_UNEQUIPPED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_GOOD_UPGRADE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_ITEM_PURCHASED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_ITEM_PURCHASE_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_OPENING_STORE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_APPSTORE_PURCHASE_CANCELLED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_APPSTORE_PURCHASED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_APPSTORE_PURCHASE_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_TRANSACTION_RESTORED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_TRANSACTION_RESTORE_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_UNEXPECTED_ERROR_IN_STORE object:nil];

}

+ (void)postBillingSupported{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BILLING_SUPPORTED object:self];
}

+ (void)postBillingNotSupported{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BILLING_NOT_SUPPORTED object:self];
}

+ (void)postClosingStore{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CLOSING_STORE object:self];
}

+ (void)postChangedBalance:(int)balance forCurrency:(VirtualCurrency*)currency withAmount:(int)amountAdded {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:balance], DICT_ELEMENT_BALANCE,
                              currency, DICT_ELEMENT_CURRENCY,
                              [NSNumber numberWithInt:amountAdded], DICT_ELEMENT_AMOUNT_ADDED,
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CURRENCY_BALANCE_CHANGED object:self userInfo:userInfo];
}

+ (void)postChangedBalance:(int)balance forGood:(VirtualGood*)good withAmount:(int)amountAdded {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:balance], DICT_ELEMENT_BALANCE,
                              good, DICT_ELEMENT_GOOD,
                              [NSNumber numberWithInt:amountAdded], DICT_ELEMENT_AMOUNT_ADDED,
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOOD_BALANCE_CHANGED object:self userInfo:userInfo];
}

+ (void)postGoodEquipped:(EquippableVG*)good{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:good forKey:DICT_ELEMENT_EquippableVG];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOOD_EQUIPPED object:self userInfo:userInfo];
}

+ (void)postGoodUnEquipped:(EquippableVG*)good{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:good forKey:DICT_ELEMENT_EquippableVG];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOOD_UNEQUIPPED object:self userInfo:userInfo];
}

+ (void)postGoodUpgrade:(VirtualGood*)good withGoodUpgrade:(UpgradeVG*)goodUpgrade{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              good, DICT_ELEMENT_GOOD,
                              goodUpgrade, DICT_ELEMENT_UpgradeVG,
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOOD_UPGRADE object:self userInfo:userInfo];
}

+ (void)postItemPurchaseStarted:(PurchasableVirtualItem*)item{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:item forKey:DICT_ELEMENT_PURCHASABLE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_ITEM_PURCHASE_STARTED object:self userInfo:userInfo];
}

+ (void)postItemPurchased:(PurchasableVirtualItem*)item{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:item forKey:DICT_ELEMENT_PURCHASABLE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_ITEM_PURCHASED object:self userInfo:userInfo];
}

+ (void)postOpeningStore{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_OPENING_STORE object:self];
}

+ (void)postAppStorePurchaseCancelled:(PurchasableVirtualItem*)purchasableVirtualItem {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:purchasableVirtualItem forKey:DICT_ELEMENT_PURCHASABLE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_APPSTORE_PURCHASE_CANCELLED object:self userInfo:userInfo];
}

+ (void)postAppStorePurchase:(PurchasableVirtualItem*)purchasableVirtualItem withReceipt:(NSString *)transactionReceipt{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              purchasableVirtualItem, DICT_ELEMENT_PURCHASABLE,
                              transactionReceipt, DICT_ELEMENT_RECEIPT,
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_APPSTORE_PURCHASED object:self userInfo:userInfo];
}

+ (void)postAppStorePurchaseStarted:(PurchasableVirtualItem*)purchasableVirtualItem{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:purchasableVirtualItem forKey:DICT_ELEMENT_PURCHASABLE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_APPSTORE_PURCHASE_STARTED object:self userInfo:userInfo];
}

+ (void)postTransactionRestored:(BOOL)success {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:success] forKey:DICT_ELEMENT_SUCCESS];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_TRANSACTION_RESTORED object:self userInfo:userInfo];
}

+ (void)postTransactionRestoreStarted {
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_TRANSACTION_RESTORE_STARTED object:self userInfo:nil];
}

+ (void)postUnexpectedError{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UNEXPECTED_ERROR_IN_STORE object:self];
}


@end
