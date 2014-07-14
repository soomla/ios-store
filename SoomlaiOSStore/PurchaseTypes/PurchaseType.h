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

@class PurchasableVirtualItem;

/**
 ABSTRACT.
 A `PurchaseType` is a way to purchase a `PurchasableVirtualItem`. This abstract
 class describes basic features of the actual implementations of `PurchaseType`.
*/
@interface PurchaseType : NSObject {
    PurchasableVirtualItem* associatedItem;
}

@property (retain, nonatomic) PurchasableVirtualItem* associatedItem;

- (id)init;

/*
 Buys the purchasable virtual item.
 Implementation in subclasses will be according to the specific type of
 purchase.
 
 @param payload A string you want to be assigned to the purchase. This string
    is saved in a static variable and will be given bacl to you when the
    purchase is completed.
 @exception InsufficientFundsException Thrown if the user does not have enough
 funds to buy.
 */
- (void)buyWithPayload:(NSString*)payload;

@end
