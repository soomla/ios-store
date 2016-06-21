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

#import "PurchaseType.h"

@class MarketItem;

/**
 This type of Purchase is used to let users purchase `PurchasableVirtualItems` 
 via the App Store (with real money $$$).
 */
@interface PurchaseWithMarket : PurchaseType {
    MarketItem* marketItem;
}

@property (retain, nonatomic) MarketItem* marketItem;



/** 
 Constructor
 
 @param oProductId The productId to purchase in the App Store.
 @param oPrice The price of the product in the App Store.
 */
- (id)initWithProductId:(NSString*)oProductId andPrice:(double)oPrice isSubscription:(BOOL)subscription;


/** 
 Constructor
 
 @param oMarketItem The representation of the item in the App Store.
 */
- (id)initWithMarketItem:(MarketItem*)oMarketItem;

- (BOOL)subscription;

@end
