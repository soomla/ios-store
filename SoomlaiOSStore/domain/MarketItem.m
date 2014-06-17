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

#import "MarketItem.h"
#import "JSONConsts.h"

@implementation MarketItem

@synthesize price, productId, consumable, marketPrice, marketLocale, marketTitle, marketDescription;

- (id)initWithProductId:(NSString*)oProductId andConsumable:(Consumable)oConsumable andPrice:(double)oPrice{
    self = [super init];
    if (self){
        self.productId = oProductId;
        self.consumable = oConsumable;
        self.price = oPrice;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.consumable = [[dict valueForKey:JSON_MARKETITEM_CONSUMABLE] intValue];
        if ([[dict allKeys] containsObject:JSON_MARKETITEM_IOS_ID]) {
            self.productId = [dict objectForKey:JSON_MARKETITEM_IOS_ID];
        } else {
            self.productId = [dict objectForKey:JSON_MARKETITEM_PRODUCT_ID];
        }
        self.price = [[dict valueForKey:JSON_MARKETITEM_PRICE] doubleValue];
    }
    
    return self;
}

- (NSDictionary*)toDictionary{
    return [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithInt:self.consumable], JSON_MARKETITEM_CONSUMABLE,
            self.productId, JSON_MARKETITEM_IOS_ID,
            self.productId, JSON_MARKETITEM_PRODUCT_ID,
            [NSNumber numberWithDouble:self.price], JSON_MARKETITEM_PRICE,
            nil];
}

- (NSString*)priceWithCurrencySymbol {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    
    if (self.marketLocale) {
        [numberFormatter setLocale:self.marketLocale];
    } else {
        [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    }
    
    if (self.marketLocale) {
        return [numberFormatter stringFromNumber:self.marketPrice];
    } else {
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:price]];
    }
}


@end
