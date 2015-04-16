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

#import "PurchaseWithMarket.h"
#import "MarketItem.h"
#import "SoomlaUtils.h"
#import "SoomlaStore.h"
#import "StoreEventHandling.h"
#import "PurchasableVirtualItem.h"

@implementation PurchaseWithMarket

@synthesize marketItem;

static NSString* TAG = @"SOOMLA PurchaseWithMarket";

- (id)initWithProductId:(NSString*)oProductId andPrice:(double)oPrice {
    if (self = [super init]) {
        self.marketItem = [[MarketItem alloc] initWithProductId:oProductId andPrice:oPrice];
    }
    return self;
}

- (id)initWithMarketItem:(MarketItem*)oMarketItem {
    if (self = [super init]) {
        self.marketItem = oMarketItem;
    }
    return self;
}

/*
 see parent
 */
- (void)buyWithPayload:(NSString*)payload {
    LogDebug(TAG, ([NSString stringWithFormat:@"Starting in-app purchase for productId: %@", self.marketItem.productId]));
    
    if (![[SoomlaStore getInstance] buyInMarketWithMarketItem:self.marketItem andPayload:payload]) {
        [StoreEventHandling postUnexpectedError:ERR_PURCHASE_FAIL forObject:self];
        return;
    }
    
    [StoreEventHandling postItemPurchaseStarted:self.associatedItem.itemId];
}

@end
