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

#import "StoreJSONConsts.h"

NSString *const JSON_STORE_CURRENCIES         = @"currencies";
NSString *const JSON_STORE_CURRENCYPACKS      = @"currencyPacks";
NSString *const JSON_STORE_GOODS              = @"goods";
NSString *const JSON_STORE_CATEGORIES         = @"categories";
NSString *const JSON_STORE_GOODS_SU           = @"singleUse";
NSString *const JSON_STORE_GOODS_PA           = @"goodPacks";
NSString *const JSON_STORE_GOODS_UP           = @"goodUpgrades";
NSString *const JSON_STORE_GOODS_LT           = @"lifetime";
NSString *const JSON_STORE_GOODS_EQ           = @"equippable";

NSString *const JSON_CATEGORY_NAME            = @"name";
NSString *const JSON_CATEGORY_GOODSITEMIDS    = @"goods_itemIds";

NSString *const JSON_MARKETITEM_PRODUCT_ID    = @"productId";
NSString *const JSON_MARKETITEM_IOS_ID        = @"iosId";
NSString *const JSON_MARKETITEM_PRICE         = @"price";
NSString *const JSON_MARKETITEM_MARKETPRICE   = @"marketPrice";
NSString *const JSON_MARKETITEM_MARKETTITLE   = @"marketTitle";
NSString *const JSON_MARKETITEM_MARKETDESC    = @"marketDesc";
NSString *const JSON_MARKETITEM_MARKETCURRENCYCODE = @"marketCurrencyCode";
NSString *const JSON_MARKETITEM_MARKETPRICEMICROS  = @"marketPriceMicros";

NSString *const JSON_EQUIPPABLE_EQUIPPING     = @"equipping";

// VGP = SingleUsePackVG
NSString *const JSON_VGP_GOOD_ITEMID          = @"good_itemId";
NSString *const JSON_VGP_GOOD_AMOUNT          = @"good_amount";

// VGU = UpgradeVG
NSString *const JSON_VGU_GOOD_ITEMID          = @"good_itemId";
NSString *const JSON_VGU_PREV_ITEMID          = @"prev_itemId";
NSString *const JSON_VGU_NEXT_ITEMID          = @"next_itemId";

NSString *const JSON_CURRENCYPACK_CURRENCYAMOUNT = @"currency_amount";
NSString *const JSON_CURRENCYPACK_CURRENCYITEMID = @"currency_itemId";

/** IabPurchase Type **/
NSString *const JSON_PURCHASABLE_ITEM         = @"purchasableItem";

NSString *const JSON_PURCHASE_TYPE            = @"purchaseType";
NSString *const JSON_PURCHASE_TYPE_MARKET     = @"market";
NSString *const JSON_PURCHASE_TYPE_VI         = @"virtualItem";

NSString *const JSON_PURCHASE_MARKET_ITEM     = @"marketItem";

NSString *const JSON_PURCHASE_VI_ITEMID       = @"pvi_itemId";
NSString *const JSON_PURCHASE_VI_AMOUNT       = @"pvi_amount";

// VIR = VirtualItemReward
NSString *const VIR_ASSOCITEMID               = @"associatedItemId";
NSString *const VIR_AMOUNT                    = @"amount";
