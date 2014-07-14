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


#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@class MarketItem;
@class VirtualGood;
@class VirtualCurrency;
@class PurchasableVirtualItem;
@class UpgradeVG;
@class EquippableVG;

// Events
#define EVENT_BILLING_NOT_SUPPORTED         @"BillingNotSupported"
#define EVENT_BILLING_SUPPORTED             @"BillingSupported"
#define EVENT_CURRENCY_BALANCE_CHANGED      @"ChangedCurrencyBalance"
#define EVENT_GOOD_BALANCE_CHANGED          @"ChangedGoodBalance"
#define EVENT_GOOD_EQUIPPED                 @"VirtualGoodEquipped"
#define EVENT_GOOD_UNEQUIPPED               @"VirtualGoodUNEQUIPPED"
#define EVENT_GOOD_UPGRADE                  @"VirtualGoodUpgrade"
#define EVENT_ITEM_PURCHASED                @"ItemPurchased"
#define EVENT_ITEM_PURCHASE_STARTED         @"ItemPurchaseProcessStarted"
#define EVENT_MARKET_PURCHASE_CANCELLED     @"MarketPurchaseCancelled"
#define EVENT_MARKET_PURCHASED              @"MarketPurchased"
#define EVENT_MARKET_PURCHASE_VERIF         @"MarketPurchaseVerification"
#define EVENT_MARKET_PURCHASE_STARTED       @"MarketPurchaseProcessStarted"
#define EVENT_RESTORE_TRANSACTIONS_FINISHED @"RestoreTransactionsFinished"
#define EVENT_RESTORE_TRANSACTIONS_STARTED  @"RestoreTransactionsStarted"
#define EVENT_SOOMLASTORE_INIT              @"SoomlaStoreInitialized"
#define EVENT_MARKET_ITEMS_REFRESH_STARTED  @"MarketItemsRefreshStarted"
#define EVENT_MARKET_ITEMS_REFRESH_FINISHED @"MarketItemsRefreshFinished"
#define EVENT_UNEXPECTED_ERROR_IN_STORE     @"UnexpectedErrorInStore"


// UserInfo Elements
#define DICT_ELEMENT_BALANCE           @"balance"
#define DICT_ELEMENT_CURRENCY          @"VirtualCurrency"
#define DICT_ELEMENT_AMOUNT_ADDED      @"amountAdded"
#define DICT_ELEMENT_GOOD              @"VirtualGood"
#define DICT_ELEMENT_EquippableVG      @"EquippableVG"
#define DICT_ELEMENT_UpgradeVG         @"UpgradeVG"
#define DICT_ELEMENT_PURCHASABLE       @"PurchasableVirtualItem"
#define DICT_ELEMENT_DEVELOPERPAYLOAD  @"DeveloperPayload"
#define DICT_ELEMENT_RECEIPT           @"receipt"
#define DICT_ELEMENT_TOKEN             @"token"
#define DICT_ELEMENT_SUCCESS           @"success"
#define DICT_ELEMENT_VERIFIED          @"verified"
#define DICT_ELEMENT_TRANSACTION       @"transaction"
#define DICT_ELEMENT_ERROR_CODE        @"error_code"
#define DICT_ELEMENT_PRODUCTID         @"productId"
#define DICT_ELEMENT_PRICE             @"price"
#define DICT_ELEMENT_TITLE             @"title"
#define DICT_ELEMENT_DESCRIPTION       @"description"
#define DICT_ELEMENT_LOCALE            @"locale"
#define DICT_ELEMENT_MARKET_ITEMS      @"marketItems"


// Error Codes
#define ERR_GENERAL                 0
#define ERR_VERIFICATION_TIMEOUT    1
#define ERR_VERIFICATION_FAIL       2
#define ERR_PURCHASE_FAIL           3


/**
 * This class is used to register and post all the supported events.
 * Use this class to invoke events on handlers when they occur.
 *
 * SOOMLA uses iOS's `NSNotificationCenter` to handle events across the SDK.
 */
@interface StoreEventHandling : NSObject

+ (void)observeAllEventsWithObserver:(id)observer withSelector:(SEL)selector;

+ (void)postBillingSupported;

+ (void)postBillingNotSupported;

+ (void)postChangedBalance:(int)balance forCurrency:(VirtualCurrency*)currency withAmount:(int)amountAdded;

+ (void)postChangedBalance:(int)balance forGood:(VirtualGood*)good withAmount:(int)amountAdded;

+ (void)postGoodEquipped:(EquippableVG*)good;

+ (void)postGoodUnEquipped:(EquippableVG*)good;

+ (void)postGoodUpgrade:(VirtualGood*)good withGoodUpgrade:(UpgradeVG*)goodUpgrade;

+ (void)postItemPurchaseStarted:(PurchasableVirtualItem*)item;

+ (void)postItemPurchased:(PurchasableVirtualItem*)item withPayload:(NSString*)payload;

+ (void)postMarketPurchaseCancelled:(PurchasableVirtualItem*)purchasableVirtualItem;

+ (void)postMarketPurchase:(PurchasableVirtualItem*)purchasableVirtualItem withReceiptUrl:(NSURL*)receiptUrl andPurchaseToken:(NSString*)token andPayload:(NSString*)payload;

+ (void)postMarketPurchaseVerification:(BOOL)verified forItem:(PurchasableVirtualItem*)purchasableVirtualItem andTransaction:(SKPaymentTransaction*)transaction forObject:(id)object;

+ (void)postMarketPurchaseStarted:(PurchasableVirtualItem*)purchasableVirtualItem;

+ (void)postMarketItemsRefreshStarted;

+ (void)postMarketItemsRefreshFinished:(NSArray*)marketItems;

+ (void)postRestoreTransactionsFinished:(BOOL)success;

+ (void)postRestoreTransactionsStarted;

+ (void)postUnexpectedError:(int)code forObject:(id)object;

+ (void)postSoomlaStoreInitialized;

@end
