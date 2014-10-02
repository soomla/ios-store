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
#import "IStoreAssets.h"


/**
 This class defines our game's economy model, which includes virtual goods, 
 virtual currencies and currency packs, virtual categories, and non-consumable
 items.
 */


// Currencies
extern NSString* const MUFFINS_CURRENCY_ITEM_ID;

// Goods
extern NSString* const LEVEL_1_GOOD_ITEM_ID;
extern NSString* const LEVEL_2_GOOD_ITEM_ID;
extern NSString* const LEVEL_3_GOOD_ITEM_ID;
extern NSString* const LEVEL_4_GOOD_ITEM_ID;
extern NSString* const LEVEL_5_GOOD_ITEM_ID;
extern NSString* const LEVEL_6_GOOD_ITEM_ID;
extern NSString* const _LEVEL_1_GOOD_ITEM_ID;
extern NSString* const _LEVEL_2_GOOD_ITEM_ID;
extern NSString* const _LEVEL_3_GOOD_ITEM_ID;
extern NSString* const _LEVEL_4_GOOD_ITEM_ID;
extern NSString* const _LEVEL_5_GOOD_ITEM_ID;
extern NSString* const _LEVEL_6_GOOD_ITEM_ID;
extern NSString* const MARRIAGE_GOOD_ITEM_ID;
extern NSString* const MARRIAGE_PRODUCT_ID;
extern NSString* const JERRY_GOOD_ITEM_ID;
extern NSString* const GEORGE_GOOD_ITEM_ID;
extern NSString* const KRAMER_GOOD_ITEM_ID;
extern NSString* const ELAINE_GOOD_ITEM_ID;
extern NSString* const _20_CHOCOLATE_CAKES_GOOD_ITEM_ID;
extern NSString* const _50_CHOCOLATE_CAKES_GOOD_ITEM_ID;
extern NSString* const _100_CHOCOLATE_CAKES_GOOD_ITEM_ID;
extern NSString* const _200_CHOCOLATE_CAKES_GOOD_ITEM_ID;
extern NSString* const CHOCOLATE_CAKE_GOOD_ITEM_ID;
extern NSString* const CREAM_CUP_GOOD_ITEM_ID;
extern NSString* const MUFFIN_CAKE_GOOD_ITEM_ID;
extern NSString* const PAVLOVA_GOOD_ITEM_ID;

// Currency Packs
extern NSString* const _10_MUFFINS_PACK_ITEM_ID;
extern NSString* const _10_MUFFINS_PRODUCT_ID;
extern NSString* const _50_MUFFINS_PACK_ITEM_ID;
extern NSString* const _50_MUFFINS_PRODUCT_ID;
extern NSString* const _400_MUFFINS_PACK_ITEM_ID;
extern NSString* const _400_MUFFINS_PRODUCT_ID;
extern NSString* const _1000_MUFFINS_PACK_ITEM_ID;
extern NSString* const _1000_MUFFINS_PRODUCT_ID;

@interface MuffinRushAssets : NSObject <IStoreAssets>{
    
}

@end