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


#import "StoreEventHandling.h"
#import "MarketItem.h"
#import "VirtualGood.h"

@implementation StoreEventHandling

+ (void)observeAllEventsWithObserver:(id)observer withSelector:(SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_BILLING_NOT_SUPPORTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_BILLING_SUPPORTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_CURRENCY_BALANCE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_GOOD_BALANCE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_GOOD_EQUIPPED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_GOOD_UNEQUIPPED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_GOOD_UPGRADE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_ITEM_PURCHASED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_ITEM_PURCHASE_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_MARKET_PURCHASE_CANCELLED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_MARKET_PURCHASED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_MARKET_PURCHASE_VERIF object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_MARKET_PURCHASE_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_RESTORE_TRANSACTIONS_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_RESTORE_TRANSACTIONS_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_UNEXPECTED_ERROR_IN_STORE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_SOOMLASTORE_INIT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_MARKET_ITEMS_REFRESH_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_MARKET_ITEMS_REFRESH_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_MARKET_ITEMS_REFRESH_FAILED object:nil];
}

+ (void)postBillingSupported{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BILLING_SUPPORTED object:self];
}

+ (void)postBillingNotSupported{
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BILLING_NOT_SUPPORTED object:self];
}

+ (void)postChangedBalance:(int)balance forCurrency:(NSString*)currencyItemId withAmount:(int)amountAdded {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:balance], DICT_ELEMENT_BALANCE,
                              currencyItemId, DICT_ELEMENT_CURRENCY,
                              [NSNumber numberWithInt:amountAdded], DICT_ELEMENT_AMOUNT_ADDED,
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CURRENCY_BALANCE_CHANGED object:self userInfo:userInfo];
}

+ (void)postChangedBalance:(int)balance forGood:(NSString*)goodItemId withAmount:(int)amountAdded {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:balance], DICT_ELEMENT_BALANCE,
                              goodItemId, DICT_ELEMENT_GOOD,
                              [NSNumber numberWithInt:amountAdded], DICT_ELEMENT_AMOUNT_ADDED,
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOOD_BALANCE_CHANGED object:self userInfo:userInfo];
}

+ (void)postGoodEquipped:(NSString*)goodItemId{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:goodItemId forKey:DICT_ELEMENT_EquippableVG];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOOD_EQUIPPED object:self userInfo:userInfo];
}

+ (void)postGoodUnEquipped:(NSString*)goodItemId{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:goodItemId forKey:DICT_ELEMENT_EquippableVG];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOOD_UNEQUIPPED object:self userInfo:userInfo];
}

+ (void)postGoodUpgrade:(NSString*)goodItemId withGoodUpgrade:(NSString*)goodUpgradeItemId{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              goodItemId, DICT_ELEMENT_GOOD,
                              goodUpgradeItemId, DICT_ELEMENT_UpgradeVG,
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOOD_UPGRADE object:self userInfo:userInfo];
}

+ (void)postItemPurchaseStarted:(NSString*)itemId{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:itemId forKey:DICT_ELEMENT_PURCHASABLE_ID];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_ITEM_PURCHASE_STARTED object:self userInfo:userInfo];
}

+ (void)postItemPurchased:(NSString*)itemId withPayload:(NSString*)payload{
    if (!payload) {
        payload = @"";
    }
    NSDictionary *userInfo = @{ DICT_ELEMENT_PURCHASABLE_ID: itemId, DICT_ELEMENT_DEVELOPERPAYLOAD: payload };
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_ITEM_PURCHASED object:self userInfo:userInfo];
}

+ (void)postMarketPurchaseCancelled:(PurchasableVirtualItem*)purchasableVirtualItem {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:purchasableVirtualItem forKey:DICT_ELEMENT_PURCHASABLE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MARKET_PURCHASE_CANCELLED object:self userInfo:userInfo];
}

+ (void)postMarketPurchase:(PurchasableVirtualItem*)purchasableVirtualItem withReceiptUrl:(NSURL*)receiptUrl andPurchaseToken:(NSString*)token andPayload:(NSString*)payload{
    if (!payload) {
        payload = @"";
    }
    NSString* urlStr = @"";
    if (receiptUrl) {
        urlStr = [receiptUrl absoluteString];
    }
    NSDictionary *userInfo = @{DICT_ELEMENT_PURCHASABLE: purchasableVirtualItem, DICT_ELEMENT_RECEIPT: urlStr, DICT_ELEMENT_TOKEN: token, DICT_ELEMENT_DEVELOPERPAYLOAD: payload};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MARKET_PURCHASED object:self userInfo:userInfo];
}

+ (void)postMarketPurchaseVerification:(BOOL)verified forItem:(PurchasableVirtualItem*)purchasableVirtualItem andTransaction:(SKPaymentTransaction*)transaction forObject:(id)object {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              purchasableVirtualItem, DICT_ELEMENT_PURCHASABLE,
                              [NSNumber numberWithBool:verified], DICT_ELEMENT_VERIFIED,
                              transaction, DICT_ELEMENT_TRANSACTION,
                              object, DICT_ELEMENT_VERIFICATION_INSTANCE,
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MARKET_PURCHASE_VERIF object:object userInfo:userInfo];
}

+ (void)postMarketPurchaseStarted:(PurchasableVirtualItem*)purchasableVirtualItem{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:purchasableVirtualItem forKey:DICT_ELEMENT_PURCHASABLE];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MARKET_PURCHASE_STARTED object:self userInfo:userInfo];
}

+ (void)postMarketItemsRefreshStarted {
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MARKET_ITEMS_REFRESH_STARTED object:self];
}
+ (void)postMarketItemsRefreshFinished:(NSArray*)marketItems {
    NSDictionary *userInfo = @{DICT_ELEMENT_MARKET_ITEMS: marketItems};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MARKET_ITEMS_REFRESH_FINISHED object:self userInfo:userInfo];
}

+ (void)postMarketItemsRefreshFailed:(NSString*)errorMessage {
    NSDictionary *userInfo = @{DICT_ELEMENT_ERROR_MESSAGE: errorMessage};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MARKET_ITEMS_REFRESH_FAILED object:self userInfo:userInfo];
}

+ (void)postRestoreTransactionsFinished:(BOOL)success {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:success] forKey:DICT_ELEMENT_SUCCESS];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_RESTORE_TRANSACTIONS_FINISHED object:self userInfo:userInfo];
}

+ (void)postRestoreTransactionsStarted {
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_RESTORE_TRANSACTIONS_STARTED object:self userInfo:nil];
}

+ (void)postUnexpectedError:(int)code forObject:(id)object{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:code], DICT_ELEMENT_ERROR_CODE,
                              object, DICT_ELEMENT_VERIFICATION_INSTANCE,
                              nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UNEXPECTED_ERROR_IN_STORE object:object userInfo:userInfo];
}

+ (void) postSoomlaStoreInitialized {
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_SOOMLASTORE_INIT object:self];
}

@end
