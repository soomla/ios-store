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

/**
 This class will help you do your day to day virtual economy operations easily.
 You can give or take items from your users. You can buy items or upgrade them.
 You can also check their equipping status and change it.
 */
@interface StoreInventory : NSObject

/**
 Buys the item with the given `itemId`.

 @param itemId The id of the item to be purchased.
 @param payload A string you want to be assigned to the purchase. This string
    is saved in a static variable and will be given bacl to you when the
    purchase is completed.
 @exception InsufficientFundsException Thrown if the user tries to make a
    purchase for which he/she does not have enough funds for.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (void)buyItemWithItemId:(NSString*)itemId andPayload:(NSString*)payload;


/*VIRTUAL ITEMS **/

/**
 Retrieves the balance of the virtual item with the given `itemId`.

 @param itemId The id of the virtual item to be fetched - must be of
    `VirtualCurrency`, `SingleUseVG`, `LifetimeVG`, `EquippableVG`.
 @return The balance of the virtual item with the given `itemId`.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (int)getItemBalance:(NSString*)itemId;

/**
 Gives your user the given amount of the virtual item with the given `itemId`.
 For example, when your user plays your game for the first time you GIVE
 him/her 1000 gems.

 NOTE: This action is different than `buy` -
 You use `give` to give your user something for free.
 You use `buy` to give your user something and get something in return.

 @param amount The amount of the item to be given.
 @param itemId The id of the virtual item to be given.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (void)giveAmount:(int)amount ofItem:(NSString*)itemId;

/**
 Takes from your user the given amount of the virtual item with the given
 `itemId`.
 For example, when you want to downgrade a virtual good, you take the upgrade.

 @param amount The amount of the item to be given.
 @param itemId The id of the virtual item to be taken.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (void)takeAmount:(int)amount ofItem:(NSString*)itemId;


/** VIRTUAL GOODS **/

/**
 Equips the virtual good with the given `goodItemId`.
 Equipping means that the user decides to currently use a specific virtual good.
 For more details and examples see `EquippableVG`.

 @param goodItemId The id of the virtual good to be equipped. Id MUST be of an
    `EquippableVG`.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (void)equipVirtualGoodWithItemId:(NSString*)goodItemId;

/**
 Unequips the virtual good with the given goodItemId. Unequipping means that the
 user decides to stop using the virtual good he/she is currently using.
 For more details and examples see `EquippableVG`.

 @param goodItemId The id of the virtual good to be unequipped. Id MUST be of an
    `EquippableVG`.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (void)unEquipVirtualGoodWithItemId:(NSString*)goodItemId;

/**
 Checks if the virtual good with the given `goodItemId` is equipped (currently
 being used).

 @param goodItemId The id of the virtual good to check on. Id MUST be of an
    `EquippableVG`.
 @return YES if the virtual good with the given id is equipped, NO otherwise.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (BOOL)isVirtualGoodWithItemIdEquipped:(NSString*)goodItemId;

/**
 Retrieves the upgrade level of the virtual good with the given `goodItemId`.

 For Example:
 Let's say there's a strength attribute to one of the characters in your game
   and you provide your users with the ability to upgrade that strength on a
   scale of 1-3.
 This is what you've created:
  1. SingleUseVG for "strength"
  2. UpgradeVG for strength 'level 1'
  3. UpgradeVG for strength 'level 2'
  4. UpgradeVG for strength 'level 3'
 In the example, this function will retrieve the upgrade level for "strength"
   (1, 2, or 3).

 @param goodItemId The id of the virtual good whose upgrade level we want to
    know. The `goodItemId` can be of any `VirtualGood`.
 @return The upgrade level.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (int)goodUpgradeLevel:(NSString*)goodItemId;

/**
 Retrieves the itemId of the current upgrade of the virtual good with the given
 `goodItemId`.

 @param goodItemId id of the virtual good whose upgrade id we want to know. The
    `goodItemId` can be of any `VirtualGood`.
 @return The upgrade id if exists, or empty string otherwise.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (NSString*)goodCurrentUpgrade:(NSString*)goodItemId;

/**
 Upgrades the virtual good with the given `goodItemId` by doing the following:
 1. Checks if the good is currently upgraded or if this is the first time being
 upgraded.
 2. If the good is currently upgraded, upgrades to the next upgrade in the
 series, or in other words, buys the next upgrade. In case there are no more
 upgrades available (meaning the current upgrade is the last available) the
 function returns.
 3. If the good has never been upgraded before, the function upgrades it to the
 first available upgrade, or in other words, buy()s the first upgrade in the
 series.

 @param goodItemId The id of the virtual good to be upgraded. The
    `upgradeItemId` can be of any `UpgradeVG`.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (void)upgradeVirtualGood:(NSString*)goodItemId;

/**
 Upgrades the good with the given `upgradeItemId` for FREE (you are GIVING the
 upgrade). In case that the good is not an upgradeable item, an error message
 will be produced. `forceUpgrade` is different than `upgradeVirtualGood`
 because `forceUpgrade` is a FREE upgrade.

 @param upgradeItemId The id of the virtual good who we want to force an upgrade
    upon. The `upgradeItemId` can be of any `UpgradeVG`.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (void)forceUpgrade:(NSString*)upgradeItemId;

/**
 Removes all upgrades from the virtual good with the given `goodItemId`.

 @param goodItemId The id of the virtual good we want to remove all upgrades
    from. The `upgradeItemId` can be of any `UpgradeVG`.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (void)removeUpgrades:(NSString*)goodItemId;


/** NON-CONSUMABLES **/

/**
 Checks if the item with the given `itemId` exists in `nonConsumableStorage`.

 @param itemId The id of the item to check if exists.
 @return YES if the item with the given id exists in `nonConsumableStorage`, NO
    otherwise.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (BOOL) nonConsumableItemExists:(NSString*)itemId;

/**
 Adds the non-consumable item with the given itemId to `nonConsumableStorage`.

 @param itemId The id of the item to add to the storage.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (void) addNonConsumableItem:(NSString*)itemId;

/**
 Removes the non-consumable item with the given `itemId` from
 `nonConsumableStorage`.

 @param itemId The id of the item to remove from the storage.
 @exception VirtualItemNotFoundException Thrown if the virtual item is not
    found.
 */
+ (void) removeNonConsumableItem:(NSString*)itemId;

@end
