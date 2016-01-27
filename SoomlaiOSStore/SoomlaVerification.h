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

@class PurchasableVirtualItem;

@interface SoomlaVerification : NSObject <NSURLConnectionDelegate, SKRequestDelegate>{
    NSMutableData *responseData;
    int responseCode;
    PurchasableVirtualItem *purchasable;
    SKPaymentTransaction* transaction;
}

- (id)initWithTransaction:(SKPaymentTransaction*)t andPurchasable:(PurchasableVirtualItem*)pvi isRestored:(BOOL)isRestored;

- (void)verifyData;

@end
