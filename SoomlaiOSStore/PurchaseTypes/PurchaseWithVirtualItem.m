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

#import "PurchaseWithVirtualItem.h"
#import "SoomlaUtils.h"
#import "VirtualItem.h"
#import "StoreEventHandling.h"
#import "PurchasableVirtualItem.h"
#import "VirtualItemStorage.h"
#import "StorageManager.h"
#import "InsufficientFundsException.h"
#import "StoreInfo.h"
#import "VirtualItemNotFoundException.h"

@implementation PurchaseWithVirtualItem

@synthesize targetItemId, amount;

static NSString* TAG = @"SOOMLA PurchaseWithVirtualItem";

- (id) initWithVirtualItem:(NSString*)oTargetItemId andAmount:(int)oAmount {
    if (self = [super init]) {
        self.targetItemId = oTargetItemId;
        self.amount = oAmount;
    }
    
    return self;
}

/*
 see parent
 */
- (void)buyWithPayload:(NSString*)payload {
    LogDebug(TAG, ([NSString stringWithFormat:@"Trying to buy a %@ with %d pieces of %@.",
                    self.associatedItem.name, self.amount, self.targetItemId]));
    
    [StoreEventHandling postItemPurchaseStarted:self.associatedItem.itemId];
    
    VirtualItem* item = NULL;
    @try {
        item = [[StoreInfo getInstance] virtualItemWithId:targetItemId];
    } @catch (VirtualItemNotFoundException* ex) {
        LogError(TAG, @"Target virtual item doesn't exist !");
        return;
    }
    VirtualItemStorage* storage = [[StorageManager getInstance] virtualItemStorage:item];
    
    assert(storage);
    
    int balance = [storage balanceForItem:item.itemId];
    if (balance < amount) {
        @throw [[InsufficientFundsException alloc] initWithItemId:self.targetItemId];
    }
    
    [storage removeAmount:amount fromItem:item.itemId];
    
    [self.associatedItem giveAmount:1];
    [StoreEventHandling postItemPurchased:self.associatedItem.itemId isRestored:NO withPayload:payload];
}


@end
