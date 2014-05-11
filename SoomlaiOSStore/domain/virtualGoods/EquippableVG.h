/*
 * Copyright (C) 2012 Soomla Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "LifetimeVG.h"

/**
 * EquippingModel is the way EquippableVG is equipped.
 * LOCAL    - The current EquippableVG's equipping status doesn't affect any other EquippableVG.
 * CATEGORY - In the containing category, if this EquippableVG is equipped, all other EquippableVGs are unequipped.
 * GLOBAL   - In the whole game, if this EquippableVG is equipped, all other EquippableVGs are unequipped.
 */
typedef enum {
    kLocal = 0,
    kCategory = 1,
    kGlobal = 2
} EquippingModel;
#define EquippingModelArray @"local", @"category", @"global", nil

/**
 * An Equippable virtual good is a special type of Lifetime virtual good that can be equipped
 * by your users. Equipping means that the user decides to currently use a specific virtual good.
 *
 * The `EquippableVG`'s characteristics are:
 *  1. Can be purchased only once.
 *  2. Can be equipped by the user.
 *  3. Inherits the definition of LifetimeVG.
 *
 * There are 3 ways to equip an EquippableVG:
 *  1. LOCAL    - The current `EquippableVG`'s equipping status doesn't affect any other `EquippableVG`.
 *  2. CATEGORY - In the containing category, if this EquippableVG is equipped, all other
 *                `EquippableVG`s must stay unequipped.
 *  3. GLOBAL   - In the whole game, if this `EquippableVG` is equipped, all other `EquippableVG`'s
 *                must stay unequipped.
 *
 * Real Game Examples:
 *  1. LOCAL: Say your game offers 3 weapons: a sword, a gun, and an axe (`LifetimeVG`s). Let’s
 *  suppose your user has already bought all 3. These are euippables that do not affect one another
 *  - your user can “carry” the sword, gun, and axe at the same time if he chooses to!
 *
 *  2. CATEGORY: Suppose your game offers “shirts” and “hats”. Let’s say there are 4 available
 *  shirts and 2 available hats, and your user has already purchased all of the clothing items
 *  available. He can equip a shirt and a hat at the same time, but cannot equip more than 1 shirt
 *  or more than 1 hat at the same time. In other words, he can equip at most one of each clothing
 *  category (shirts, hats)!
 *
 *  3. GLOBAL: Suppose your game offers multiple characters (LifetimeVGs): RobotX and RobotY.
 *  Let’s say your user has bought both. In other words he owns both characters and will own them
 *  forever (because they are `LifetimeVG`s) . Your user can only play as (i.e. Equip) one character
 *  at a time, either RobotX or RobotY, but never both at the same time!
 *
 * NOTE: In case you want this item to be available for purchase in the App Store (PurchaseWithMarket), 
 * you will need to define the app store item in iTunes Connect. ( https://itunesconnect.apple.com )
 *
 * Inheritance: EquippableVG > LifeTimeVG > VirtualGood > PurchasableVirtualItem > VirtualItem
 */
@interface EquippableVG : LifetimeVG {
    EquippingModel equippingModel;
}

@property EquippingModel equippingModel;

/** Constructor
 *
 * @param oEquippingModel is the way this `EquippableVG` is equipped.
 * @param oName see parent
 * @param oDescription see parent
 * @param oItemId see parent
 * @param oPurchaseType see parent
 */
- (id)initWithName:(NSString *)oName andDescription:(NSString *)oDescription
         andItemId:(NSString *)oItemId andPurchaseType:(PurchaseType *)oPurchaseType andEquippingModel:(EquippingModel)oEquippingModel;

/**
 * Equips the current `EquippableVG`.
 * The equipping is done according to the equipping model ('GLOBAL', 'CATEGORY', or 'LOCAL').
 *
 * @exception NotEnoughGoodsException
 */
- (void)equip;

/**
 * Equips the current `EquippableVG`.
 * The equipping is done according to the equipping model ('GLOBAL', 'CATEGORY', or 'LOCAL').
 *
 * @exception NotEnoughGoodsException
 */
- (void)equipWithEvent:(BOOL)notify;

/**
 * Unequips the current `EquippableVG`
 */
- (void)unequip;

/**
 * Unequips the current `EquippableVG`
 */
- (void)unequipWithEvent:(BOOL)notify;

/**
 * Transforms the given equipping model to a string.
 */
+(NSString*) equippingModelEnumToString:(EquippingModel)emVal;

+(EquippingModel) equippingModelStringToEnum:(NSString*)emStr;

@end
