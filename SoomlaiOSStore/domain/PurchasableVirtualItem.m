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

#import "PurchasableVirtualItem.h"
#import "PurchaseType.h"
#import "StoreJSONConsts.h"
#import "PurchaseWithMarket.h"
#import "PurchaseWithVirtualItem.h"
#import "MarketItem.h"
#import "VirtualItem.h"
#import "SoomlaUtils.h"
#import "VirtualItemNotFoundException.h"

@implementation PurchasableVirtualItem

@synthesize purchaseType;

static NSString* TAG = @"SOOMLA PurchasableVirtualItem";

- (id)initWithName:(NSString *)oName andDescription:(NSString *)oDescription
         andItemId:(NSString *)oItemId andPurchaseType:(PurchaseType*)oPurchaseType {
    if (self = [super initWithName:oName andDescription:oDescription andItemId:oItemId]) {
        if ([self class] == [PurchasableVirtualItem class]) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
        }
        
        self.purchaseType = oPurchaseType;
        self.purchaseType.associatedItem = self;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict {
    if (self = [super initWithDictionary:dict]) {
        if ([self class] == [PurchasableVirtualItem class]) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
        }
        
        NSDictionary* purchasableDict = [dict objectForKey:JSON_PURCHASABLE_ITEM];
        NSString* purchaseTypeStr = [purchasableDict objectForKey:JSON_PURCHASE_TYPE];
        
        if([purchaseTypeStr isEqualToString:JSON_PURCHASE_TYPE_MARKET]) {
            NSDictionary* marketItemDict = [purchasableDict objectForKey:JSON_PURCHASE_MARKET_ITEM];
            self.purchaseType = [[PurchaseWithMarket alloc] initWithMarketItem:[[MarketItem alloc] initWithDictionary:marketItemDict]];
        } else if ([purchaseTypeStr isEqualToString:JSON_PURCHASE_TYPE_VI]) {
            NSString* pItemId = [purchasableDict objectForKey:JSON_PURCHASE_VI_ITEMID];
            int amount = [[purchasableDict objectForKey:JSON_PURCHASE_VI_AMOUNT] intValue];
            
            self.purchaseType = [[PurchaseWithVirtualItem alloc] initWithVirtualItem:pItemId andAmount:amount];
        } else {
            LogError(TAG, @"Purchase type not recognized !");
        }
        
        if (self.purchaseType) {
            self.purchaseType.associatedItem = self;
        }
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* purchasableDict = [NSMutableDictionary dictionary];
    
    if ([self.purchaseType class] == [PurchaseWithMarket class]) {
        [purchasableDict setObject:JSON_PURCHASE_TYPE_MARKET forKey:JSON_PURCHASE_TYPE];
        
        MarketItem* ai = ((PurchaseWithMarket*)self.purchaseType).marketItem;
        [purchasableDict setObject:[ai toDictionary] forKey:JSON_PURCHASE_MARKET_ITEM];
    } else if ([self.purchaseType class] == [PurchaseWithVirtualItem class]) {
        [purchasableDict setObject:JSON_PURCHASE_TYPE_VI forKey:JSON_PURCHASE_TYPE];
        
        [purchasableDict setObject:((PurchaseWithVirtualItem*)self.purchaseType).targetItemId forKey:JSON_PURCHASE_VI_ITEMID];
        [purchasableDict setObject:[NSNumber numberWithInt:((PurchaseWithVirtualItem*)self.purchaseType).amount] forKey:JSON_PURCHASE_VI_AMOUNT];
    }
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setValue:purchasableDict forKey:JSON_PURCHASABLE_ITEM];
    
    return toReturn;
}

- (void)buyWithPayload:(NSString*)payload {
    if (![self canBuy]) {
        return;
    }
    
    [purchaseType buyWithPayload:payload];
}

- (BOOL)canBuy {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}


@end
