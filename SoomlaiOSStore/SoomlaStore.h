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

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "IStoreAssets.h"

@class MarketItem;
@class PurchasableVirtualItem;
@class SoomlaVerification;

/**
 This class holds the most basic assets needed to operate the Store.
 You can use it to purchase products from the App Store.

 This is the only class you need to initialize in order to use the SOOMLA SDK.
 */
@interface SoomlaStore : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    @private
    BOOL initialized;
    SoomlaVerification* sv;
}

@property BOOL initialized;


+ (SoomlaStore*)getInstance;

/**
 Initializes `SoomlaStore` from your implementation of `IStoreAssets`.
 This initializer also initializes `StoreInfo`.

 @param storeAssets The definition of your application specific assets.
 @return YES if successful, NO otherwise.
 */
- (BOOL)initializeWithStoreAssets:(id<IStoreAssets>)storeAssets;

/**
 Starts an in app purchase process in the App Store.

 @param marketItem The item to purchase. This item has to be defined EXACTLY
    the same in iTunes Connect.
 @param payload A string you want to be assigned to the purchase. This string
    is saved in a static variable and will be given bacl to you when the
    purchase is completed.
 @return YES if successful, NO otherwise.
 */
- (BOOL)buyInMarketWithMarketItem:(MarketItem*)marketItem andPayload:(NSString*)payload;

/**
 Initiates the `restoreTransactions` process and the `refreshMarketItemDetails`
 process that will refresh all purchasable items' details from the App Store.
 */
- (void)refreshInventory;

/**
 Initiates the `restoreTransactions` process.
 */
- (void)restoreTransactions;

/**
 Checks if transactions were already restored.

 @return YES if transactions were restored, NO otherwise.
 */
- (BOOL)transactionsAlreadyRestored;

/**
 Refreshes the details of all market-purchasable items that were defined in
 App Store. This function will invoke the event `EVENT_ITEMS_MARKET_REFRESHED`
 when finished.
 */
- (void)refreshMarketItemsDetails;

/**
 Checks if `SoomlaStore` has already been initialized.

 @return YES if initialized, NO otherwise.
 */
- (BOOL)isInitialized;

@end
