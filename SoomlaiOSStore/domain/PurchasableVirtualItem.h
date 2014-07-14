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

#import "VirtualItem.h"

@class PurchaseType;

/**
 ABSTRACT.
 A representation of a `VirtualItem` that you can actually purchase (either with
 real money or with other virtual items).
 */
@interface PurchasableVirtualItem : VirtualItem {
    PurchaseType* purchaseType;
}

@property (retain, nonatomic) PurchaseType* purchaseType;

/** Constructor

 @param oName see parent
 @param oDescription see parent
 @param oItemId see parent
 @param oPurchaseType The way this item is purchased.
 */
- (id)initWithName:(NSString *)oName andDescription:(NSString *)oDescription
         andItemId:(NSString *)oItemId andPurchaseType:(PurchaseType*)oPurchaseType;

/**
 see parent

 @param dict see parent.
 */
- (id)initWithDictionary:(NSDictionary*)dict;

/**
 see parent
 @return see parent.
 */
- (NSDictionary*)toDictionary;

/**
 Buys a `VirtualItem`. This action uses the associated `PurchaseType` to perform
 the purchase.

 @param payload A string you want to be assigned to the purchase. This string
    is saved in a static variable and will be given bacl to you when the
    purchase is completed.
 @exception InsufficientFundsException if user does not have enough funds to buy
 the desired item.
 */
- (void)buyWithPayload:(NSString*)payload;

/**
 Determines if the user is in a state that allows him/her to buy a specific
 `VirtualItem`.

 @return YES if the user can buy, NO otherwise.
 */
- (BOOL)canBuy;

@end
