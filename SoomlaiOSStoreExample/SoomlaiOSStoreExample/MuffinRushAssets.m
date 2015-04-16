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

#import "MuffinRushAssets.h"
#import "VirtualCategory.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"
#import "VirtualCurrencyPack.h"
#import "SingleUseVG.h"
#import "PurchaseWithMarket.h"
#import "PurchaseWithVirtualItem.h"
#import "MarketItem.h"
#import "LifetimeVG.h"
#import "EquippableVG.h"
#import "SingleUsePackVG.h"
#import "UpgradeVG.h"

// Currencies
NSString* const MUFFINS_CURRENCY_ITEM_ID = @"currency_muffin";

// Goods
NSString* const LEVEL_1_GOOD_ITEM_ID = @"mc1";
NSString* const LEVEL_2_GOOD_ITEM_ID = @"mc2";
NSString* const LEVEL_3_GOOD_ITEM_ID = @"mc3";
NSString* const LEVEL_4_GOOD_ITEM_ID = @"mc4";
NSString* const LEVEL_5_GOOD_ITEM_ID = @"mc5";
NSString* const LEVEL_6_GOOD_ITEM_ID = @"mc6";
NSString* const _LEVEL_1_GOOD_ITEM_ID = @"pav1";
NSString* const _LEVEL_2_GOOD_ITEM_ID = @"pav2";
NSString* const _LEVEL_3_GOOD_ITEM_ID = @"pav3";
NSString* const _LEVEL_4_GOOD_ITEM_ID = @"pav4";
NSString* const _LEVEL_5_GOOD_ITEM_ID = @"pav5";
NSString* const _LEVEL_6_GOOD_ITEM_ID = @"pav6";
NSString* const MARRIAGE_GOOD_ITEM_ID = @"marriage_lt";
NSString* const MARRIAGE_PRODUCT_ID = @"noncons.ltvg.marriage";
NSString* const JERRY_GOOD_ITEM_ID = @"jerry_character";
NSString* const GEORGE_GOOD_ITEM_ID = @"george_character";
NSString* const KRAMER_GOOD_ITEM_ID = @"kramer_character";
NSString* const ELAINE_GOOD_ITEM_ID = @"elaine_character";
NSString* const _20_CHOCOLATE_CAKES_GOOD_ITEM_ID = @"sup_20_cc";
NSString* const _50_CHOCOLATE_CAKES_GOOD_ITEM_ID = @"sup_50_cc";
NSString* const _100_CHOCOLATE_CAKES_GOOD_ITEM_ID = @"sup_100_cc";
NSString* const _200_CHOCOLATE_CAKES_GOOD_ITEM_ID = @"sup_200_cc";
NSString* const CHOCOLATE_CAKE_GOOD_ITEM_ID = @"chocolate_cake";
NSString* const CREAM_CUP_GOOD_ITEM_ID = @"cream_cup";
NSString* const MUFFIN_CAKE_GOOD_ITEM_ID = @"muffin_cake";
NSString* const PAVLOVA_GOOD_ITEM_ID = @"pavlova";

// Currency Packs
NSString* const _10_MUFFINS_PACK_ITEM_ID = @"muffins_10";
NSString* const _10_MUFFINS_PRODUCT_ID = @"android.test.refunded";
NSString* const _50_MUFFINS_PACK_ITEM_ID = @"muffins_50";
NSString* const _50_MUFFINS_PRODUCT_ID = @"android.test.canceled";
NSString* const _400_MUFFINS_PACK_ITEM_ID = @"muffins_400";
NSString* const _400_MUFFINS_PRODUCT_ID = @"android.test.purchased";
NSString* const _1000_MUFFINS_PACK_ITEM_ID = @"muffins_1000";
NSString* const _1000_MUFFINS_PRODUCT_ID = @"2500_pack";

@implementation MuffinRushAssets

VirtualCategory* _MUFFINS_CATEGORY;
VirtualCategory* MUFFIN_CAKE_UPGRADES_CATEGORY;
VirtualCategory* PAVLOVA_UPGRADES_CATEGORY;
VirtualCategory* CHARACTERS_CATEGORY;
VirtualCategory* LIFETIME_THINGS_CATEGORY;
VirtualCategory* PACKS_OF_CHOCOLATE_CAKES_CATEGORY;
VirtualCurrency* MUFFINS_CURRENCY;
VirtualGood* LEVEL_1_GOOD;
VirtualGood* LEVEL_2_GOOD;
VirtualGood* LEVEL_3_GOOD;
VirtualGood* LEVEL_4_GOOD;
VirtualGood* LEVEL_5_GOOD;
VirtualGood* LEVEL_6_GOOD;
VirtualGood* _LEVEL_1_GOOD;
VirtualGood* _LEVEL_2_GOOD;
VirtualGood* _LEVEL_3_GOOD;
VirtualGood* _LEVEL_4_GOOD;
VirtualGood* _LEVEL_5_GOOD;
VirtualGood* _LEVEL_6_GOOD;
VirtualGood* MARRIAGE_GOOD;
VirtualGood* JERRY_GOOD;
VirtualGood* GEORGE_GOOD;
VirtualGood* KRAMER_GOOD;
VirtualGood* ELAINE_GOOD;
VirtualGood* _20_CHOCOLATE_CAKES_GOOD;
VirtualGood* _50_CHOCOLATE_CAKES_GOOD;
VirtualGood* _100_CHOCOLATE_CAKES_GOOD;
VirtualGood* _200_CHOCOLATE_CAKES_GOOD;
VirtualGood* CHOCOLATE_CAKE_GOOD;
VirtualGood* CREAM_CUP_GOOD;
VirtualGood* MUFFIN_CAKE_GOOD;
VirtualGood* PAVLOVA_GOOD;
VirtualCurrencyPack* _10_MUFFINS_PACK;
VirtualCurrencyPack* _50_MUFFINS_PACK;
VirtualCurrencyPack* _400_MUFFINS_PACK;
VirtualCurrencyPack* _1000_MUFFINS_PACK;

+ (void)initialize{
    
    /** Virtual Currencies **/
    MUFFINS_CURRENCY = [[VirtualCurrency alloc] initWithName:@"Muffins" andDescription:@"" andItemId:MUFFINS_CURRENCY_ITEM_ID];
    
    
    /** Virtual Currency Packs **/
    
    _10_MUFFINS_PACK = [[VirtualCurrencyPack alloc] initWithName:@"10 Muffins" andDescription:@"Test refund of an item" andItemId:_10_MUFFINS_PACK_ITEM_ID andCurrencyAmount:10 andCurrency:MUFFINS_CURRENCY_ITEM_ID andPurchaseType:[[PurchaseWithMarket alloc] initWithMarketItem:[[MarketItem alloc] initWithProductId:_10_MUFFINS_PRODUCT_ID andPrice:0.99]]];
    
    _50_MUFFINS_PACK = [[VirtualCurrencyPack alloc] initWithName:@"50 Muffins" andDescription:@"Test cancellation of an item" andItemId:_50_MUFFINS_PACK_ITEM_ID andCurrencyAmount:50 andCurrency:MUFFINS_CURRENCY_ITEM_ID andPurchaseType:[[PurchaseWithMarket alloc] initWithMarketItem:[[MarketItem alloc] initWithProductId:_50_MUFFINS_PRODUCT_ID andPrice:1.99]]];
    
    _400_MUFFINS_PACK = [[VirtualCurrencyPack alloc] initWithName:@"400 Muffins" andDescription:@"Test purchase of an item" andItemId:_400_MUFFINS_PACK_ITEM_ID andCurrencyAmount:400 andCurrency:MUFFINS_CURRENCY_ITEM_ID andPurchaseType:[[PurchaseWithMarket alloc] initWithMarketItem:[[MarketItem alloc] initWithProductId:_400_MUFFINS_PRODUCT_ID andPrice:4.99]]];
    
    _1000_MUFFINS_PACK = [[VirtualCurrencyPack alloc] initWithName:@"1000 Muffins" andDescription:@"Test item unavailable" andItemId:_1000_MUFFINS_PACK_ITEM_ID andCurrencyAmount:1000 andCurrency:MUFFINS_CURRENCY_ITEM_ID andPurchaseType:[[PurchaseWithMarket alloc] initWithMarketItem:[[MarketItem alloc] initWithProductId:_1000_MUFFINS_PRODUCT_ID andPrice:8.99]]];
    
    
    /** Virtual Goods **/
    
    /* SingleUseVGs */
    
    CHOCOLATE_CAKE_GOOD = [[SingleUseVG alloc] initWithName:@"Chocolate Cake" andDescription:@"A classic cake to maximize customer satisfaction" andItemId:CHOCOLATE_CAKE_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:250]];
    
    CREAM_CUP_GOOD = [[SingleUseVG alloc] initWithName:@"Cream Cup" andDescription:@"Increase bakery reputation with this original pastry" andItemId:CREAM_CUP_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:50]];
    
    MUFFIN_CAKE_GOOD = [[SingleUseVG alloc] initWithName:@"Muffin Cake" andDescription:@"Customers buy a double portion on each purchase of this cake" andItemId:MUFFIN_CAKE_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:225]];
    
    PAVLOVA_GOOD = [[SingleUseVG alloc] initWithName:@"Pavlova" andDescription:@"Gives customers a sugar rush and they call their friends" andItemId:PAVLOVA_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:175]];
    
    /* LifetimeVGs */
    
    MARRIAGE_GOOD = [[LifetimeVG alloc] initWithName:@"Marriage" andDescription:@"This is a LIFETIME thing." andItemId:MARRIAGE_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithMarket alloc] initWithMarketItem:[[MarketItem alloc] initWithProductId:MARRIAGE_PRODUCT_ID andPrice:9.99]]];
    
    /* EquippableVGs */
    
    JERRY_GOOD = [[EquippableVG alloc] initWithName:@"Jerry" andDescription:@"Your friend Jerry" andItemId:JERRY_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:250] andEquippingModel:kCategory];
    
    GEORGE_GOOD = [[EquippableVG alloc] initWithName:@"George" andDescription:@"The best muffin eater in the north" andItemId:GEORGE_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:350] andEquippingModel:kCategory];
    
    KRAMER_GOOD = [[EquippableVG alloc] initWithName:@"Kramer" andDescription:@"Knows how to get muffins" andItemId:KRAMER_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:450] andEquippingModel:kCategory];
    
    ELAINE_GOOD = [[EquippableVG alloc] initWithName:@"Elaine" andDescription:@"Kicks muffins like superman" andItemId:ELAINE_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:1000] andEquippingModel:kCategory];
    
    /* SingleUsePackVGs */
    
    _20_CHOCOLATE_CAKES_GOOD = [[SingleUsePackVG alloc] initWithName:@"20 chocolate cakes" andDescription:@"A pack of 20 chocolate cakes" andItemId:_20_CHOCOLATE_CAKES_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:34] andSingleUseGood:CHOCOLATE_CAKE_GOOD_ITEM_ID andAmount:20];
    
    _50_CHOCOLATE_CAKES_GOOD = [[SingleUsePackVG alloc] initWithName:@"50 chocolate cakes" andDescription:@"A pack of 50 chocolate cakes" andItemId:_50_CHOCOLATE_CAKES_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:340] andSingleUseGood:CHOCOLATE_CAKE_GOOD_ITEM_ID andAmount:50];
    
    _100_CHOCOLATE_CAKES_GOOD = [[SingleUsePackVG alloc] initWithName:@"100 chocolate cakes" andDescription:@"A pack of 100 chocolate cakes" andItemId:_100_CHOCOLATE_CAKES_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:3410] andSingleUseGood:CHOCOLATE_CAKE_GOOD_ITEM_ID andAmount:100];
    
    _200_CHOCOLATE_CAKES_GOOD = [[SingleUsePackVG alloc] initWithName:@"200 chocolate cakes" andDescription:@"A pack of 200 chocolate cakes" andItemId:_200_CHOCOLATE_CAKES_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:4000] andSingleUseGood:CHOCOLATE_CAKE_GOOD_ITEM_ID andAmount:200];
    
    /* UpgradeVGs */
    
    LEVEL_1_GOOD = [[UpgradeVG alloc] initWithName:@"Level 1" andDescription:@"Muffin Cake Level 1" andItemId:LEVEL_1_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:50] andLinkedGood:MUFFIN_CAKE_GOOD_ITEM_ID andPreviousUpgrade:@"" andNextUpgrade:LEVEL_2_GOOD_ITEM_ID];
    
    LEVEL_2_GOOD = [[UpgradeVG alloc] initWithName:@"Level 2" andDescription:@"Muffin Cake Level 2" andItemId:LEVEL_2_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:250] andLinkedGood:MUFFIN_CAKE_GOOD_ITEM_ID andPreviousUpgrade:LEVEL_1_GOOD_ITEM_ID andNextUpgrade:LEVEL_3_GOOD_ITEM_ID];
    
    LEVEL_3_GOOD = [[UpgradeVG alloc] initWithName:@"Level 3" andDescription:@"Muffin Cake Level 3" andItemId:LEVEL_3_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:500] andLinkedGood:MUFFIN_CAKE_GOOD_ITEM_ID andPreviousUpgrade:LEVEL_2_GOOD_ITEM_ID andNextUpgrade:LEVEL_4_GOOD_ITEM_ID];
    
    LEVEL_4_GOOD = [[UpgradeVG alloc] initWithName:@"Level 4" andDescription:@"Muffin Cake Level 4" andItemId:LEVEL_4_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:1000] andLinkedGood:MUFFIN_CAKE_GOOD_ITEM_ID andPreviousUpgrade:LEVEL_3_GOOD_ITEM_ID andNextUpgrade:LEVEL_5_GOOD_ITEM_ID];
    
    LEVEL_5_GOOD = [[UpgradeVG alloc] initWithName:@"Level 5" andDescription:@"Muffin Cake Level 5" andItemId:LEVEL_5_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:1250] andLinkedGood:MUFFIN_CAKE_GOOD_ITEM_ID andPreviousUpgrade:LEVEL_4_GOOD_ITEM_ID andNextUpgrade:LEVEL_6_GOOD_ITEM_ID];
    
    LEVEL_6_GOOD = [[UpgradeVG alloc] initWithName:@"Level 6" andDescription:@"Muffin Cake Level 6" andItemId:LEVEL_6_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:1500] andLinkedGood:MUFFIN_CAKE_GOOD_ITEM_ID andPreviousUpgrade:LEVEL_5_GOOD_ITEM_ID andNextUpgrade:@""];
    
    _LEVEL_1_GOOD = [[UpgradeVG alloc] initWithName:@"Level 1" andDescription:@"Pavlova Level 1" andItemId:_LEVEL_1_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:150] andLinkedGood:PAVLOVA_GOOD_ITEM_ID andPreviousUpgrade:@"" andNextUpgrade:_LEVEL_2_GOOD_ITEM_ID];
    
    _LEVEL_2_GOOD = [[UpgradeVG alloc] initWithName:@"Level 2" andDescription:@"Pavlova Level 2" andItemId:_LEVEL_2_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:350] andLinkedGood:PAVLOVA_GOOD_ITEM_ID andPreviousUpgrade:_LEVEL_1_GOOD_ITEM_ID andNextUpgrade:_LEVEL_3_GOOD_ITEM_ID];
    
    _LEVEL_3_GOOD = [[UpgradeVG alloc] initWithName:@"Level 3" andDescription:@"Pavlova Level 3" andItemId:_LEVEL_3_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:700] andLinkedGood:PAVLOVA_GOOD_ITEM_ID andPreviousUpgrade:_LEVEL_2_GOOD_ITEM_ID andNextUpgrade:_LEVEL_4_GOOD_ITEM_ID];
    
    _LEVEL_4_GOOD = [[UpgradeVG alloc] initWithName:@"Level 4" andDescription:@"Pavlova Level 4" andItemId:_LEVEL_4_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:1200] andLinkedGood:PAVLOVA_GOOD_ITEM_ID andPreviousUpgrade:_LEVEL_3_GOOD_ITEM_ID andNextUpgrade:_LEVEL_5_GOOD_ITEM_ID];
    
    _LEVEL_5_GOOD = [[UpgradeVG alloc] initWithName:@"Level 5" andDescription:@"Pavlova Level 5" andItemId:_LEVEL_5_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:1850] andLinkedGood:PAVLOVA_GOOD_ITEM_ID andPreviousUpgrade:_LEVEL_4_GOOD_ITEM_ID andNextUpgrade:_LEVEL_6_GOOD_ITEM_ID];
    
    _LEVEL_6_GOOD = [[UpgradeVG alloc] initWithName:@"Level 6" andDescription:@"Pavlova Level 6" andItemId:_LEVEL_6_GOOD_ITEM_ID andPurchaseType:[[PurchaseWithVirtualItem alloc] initWithVirtualItem:MUFFINS_CURRENCY_ITEM_ID andAmount:2500] andLinkedGood:PAVLOVA_GOOD_ITEM_ID andPreviousUpgrade:_LEVEL_5_GOOD_ITEM_ID andNextUpgrade:@""];
    
    
    /** Virtual Categories **/
    
    _MUFFINS_CATEGORY  = [[VirtualCategory alloc] initWithName:@"Muffins" andGoodsItemIds:@[MUFFIN_CAKE_GOOD_ITEM_ID, CHOCOLATE_CAKE_GOOD_ITEM_ID, PAVLOVA_GOOD_ITEM_ID, MUFFIN_CAKE_GOOD_ITEM_ID]];
    
    MUFFIN_CAKE_UPGRADES_CATEGORY  = [[VirtualCategory alloc] initWithName:@"Muffin Cake Upgrades" andGoodsItemIds:@[LEVEL_1_GOOD_ITEM_ID, LEVEL_2_GOOD_ITEM_ID, LEVEL_3_GOOD_ITEM_ID, LEVEL_4_GOOD_ITEM_ID, LEVEL_5_GOOD_ITEM_ID, LEVEL_6_GOOD_ITEM_ID]];
    
    PAVLOVA_UPGRADES_CATEGORY  = [[VirtualCategory alloc] initWithName:@"Pavlova Upgrades" andGoodsItemIds:@[_LEVEL_1_GOOD_ITEM_ID, _LEVEL_2_GOOD_ITEM_ID, _LEVEL_3_GOOD_ITEM_ID, _LEVEL_4_GOOD_ITEM_ID, _LEVEL_5_GOOD_ITEM_ID, _LEVEL_6_GOOD_ITEM_ID]];
    
    CHARACTERS_CATEGORY  = [[VirtualCategory alloc] initWithName:@"Characters" andGoodsItemIds:@[JERRY_GOOD_ITEM_ID, GEORGE_GOOD_ITEM_ID, KRAMER_GOOD_ITEM_ID, ELAINE_GOOD_ITEM_ID]];
    
    LIFETIME_THINGS_CATEGORY  = [[VirtualCategory alloc] initWithName:@"Lifetime things" andGoodsItemIds:@[MARRIAGE_GOOD_ITEM_ID]];
    
    PACKS_OF_CHOCOLATE_CAKES_CATEGORY  = [[VirtualCategory alloc] initWithName:@"Packs of Chocolate Cakes" andGoodsItemIds:@[_20_CHOCOLATE_CAKES_GOOD_ITEM_ID, _50_CHOCOLATE_CAKES_GOOD_ITEM_ID, _100_CHOCOLATE_CAKES_GOOD_ITEM_ID, _200_CHOCOLATE_CAKES_GOOD_ITEM_ID]];
    
    
    
}

- (int)getVersion {
    return 0;
}

- (NSArray*)virtualCurrencies{
    return @[MUFFINS_CURRENCY];
}

- (NSArray*)virtualGoods{
    return @[
    /* SingleUseVGs     --> */ CHOCOLATE_CAKE_GOOD, CREAM_CUP_GOOD, MUFFIN_CAKE_GOOD, PAVLOVA_GOOD,
    /* LifetimeVGs      --> */ MARRIAGE_GOOD,
    /* EquippableVGs    --> */ JERRY_GOOD, GEORGE_GOOD, KRAMER_GOOD, ELAINE_GOOD,
    /* SingleUsePackVGs --> */ _20_CHOCOLATE_CAKES_GOOD, _50_CHOCOLATE_CAKES_GOOD, _100_CHOCOLATE_CAKES_GOOD, _200_CHOCOLATE_CAKES_GOOD,
    /* UpgradeVGs       --> */ LEVEL_1_GOOD, LEVEL_2_GOOD, LEVEL_3_GOOD, LEVEL_4_GOOD, LEVEL_5_GOOD, LEVEL_6_GOOD, _LEVEL_1_GOOD, _LEVEL_2_GOOD, _LEVEL_3_GOOD, _LEVEL_4_GOOD, _LEVEL_5_GOOD, _LEVEL_6_GOOD,
                               ];
}

- (NSArray*)virtualCurrencyPacks{
    return @[_10_MUFFINS_PACK, _50_MUFFINS_PACK, _400_MUFFINS_PACK, _1000_MUFFINS_PACK];
}

- (NSArray*)virtualCategories{
    return @[_MUFFINS_CATEGORY, MUFFIN_CAKE_UPGRADES_CATEGORY, PAVLOVA_UPGRADES_CATEGORY, CHARACTERS_CATEGORY, LIFETIME_THINGS_CATEGORY, PACKS_OF_CHOCOLATE_CAKES_CATEGORY];
}


@end