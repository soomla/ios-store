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
#import "SoomlaUtils.h"
#import "StoreJSONConsts.h"

@implementation MarketItem

@synthesize price, productId, marketPriceAndCurrency, marketTitle, marketDescription, marketCurrencyCode, marketPriceMicros;

- (id)initWithProductId:(NSString*)oProductId andPrice:(double)oPrice{
    self = [super init];
    if (self){
        self.productId = oProductId;
        self.price = oPrice;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        if ([[dict allKeys] containsObject:JSON_MARKETITEM_IOS_ID]) {
            self.productId = [dict objectForKey:JSON_MARKETITEM_IOS_ID];
        } else {
            self.productId = [dict objectForKey:JSON_MARKETITEM_PRODUCT_ID];
        }
        self.price = [[dict valueForKey:JSON_MARKETITEM_PRICE] doubleValue];
        
        self.marketPriceAndCurrency = [dict objectForKey:JSON_MARKETITEM_MARKETPRICE];
        self.marketTitle = [dict objectForKey:JSON_MARKETITEM_MARKETTITLE];
        self.marketDescription = [dict objectForKey:JSON_MARKETITEM_MARKETDESC];
        self.marketCurrencyCode = [dict objectForKey:JSON_MARKETITEM_MARKETCURRENCYCODE];
        self.marketPriceMicros = [[dict objectForKey:JSON_MARKETITEM_MARKETPRICEMICROS] longValue];
    }
    
    return self;
}

- (NSDictionary*)toDictionary{
    return @{
             SOOM_CLASSNAME : [SoomlaUtils getClassName:self],
             JSON_MARKETITEM_IOS_ID: self.productId,
             JSON_MARKETITEM_PRICE: [NSNumber numberWithDouble:self.price],
             JSON_MARKETITEM_MARKETPRICE: (self.marketPriceAndCurrency ? self.marketPriceAndCurrency : @""),
             JSON_MARKETITEM_MARKETTITLE: (self.marketTitle ? self.marketTitle : @""),
             JSON_MARKETITEM_MARKETDESC: (self.marketDescription ? self.marketDescription : @""),
             JSON_MARKETITEM_MARKETCURRENCYCODE: (self.marketCurrencyCode ? self.marketCurrencyCode : @""),
             JSON_MARKETITEM_MARKETPRICEMICROS: [NSNumber numberWithLong:marketPriceMicros]
             };
}

- (void)setMarketInformation:(NSString *)priceAndCurrency andTitle:(NSString *)title andDescription:(NSString *)description
             andCurrencyCode:(NSString *)currencyCode andPriceMicros:(long)priceMicros {
    self.marketPriceAndCurrency = priceAndCurrency;
    self.marketTitle = title;
    self.marketDescription = description;
    self.marketCurrencyCode = currencyCode;
    self.marketPriceMicros = priceMicros;
}

+ (NSString*)priceWithCurrencySymbol:(NSLocale *)locale andPrice:(NSDecimalNumber *)price andBackupPrice:(double)backupPrice{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    
    if (locale) {
        [numberFormatter setLocale:locale];
    } else {
        [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    }
    
    if (locale) {
        return [numberFormatter stringFromNumber:price];
    } else {
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:backupPrice]];
    }
}


@end
