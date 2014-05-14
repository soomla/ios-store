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

#import <Foundation/Foundation.h>

@interface StoreInventory : NSObject

/**
 * Buys the item with the given `itemId`.
 *
 * @param itemId id of the item to be purchased.
 * @exception InsufficientFundsException, VirtualItemNotFoundException
 */
+ (void)buyItemWithItemId:(NSString*)itemId;


/** VIRTUAL ITEMS **/

/**
 * Retrieves the balance of the virtual item with the given `itemId`.
 *
 * @param itemId id of the virtual item to be fetched - must be of `VirtualCurrency` or `SingleUseVG` or `LifetimeVG` or `EquippableVG`.
 * @return balance of the virtual item with the given `itemId`.
 * @exception VirtualItemNotFoundException
 */
+ (int)getItemBalance:(NSString*)itemId;

/**
 * Gives your user the given amount of the virtual item with the given `itemId`.
 * For example, when your user plays your game for the first time you GIVE him 1000 gems.
 *
 * NOTE: This action is different than buy -
 * You use give(int amount) to give your user something for free.
 * You use buy() to give your user something and you get something in return.
 *
 * @param amount amount of the item to be given
 * @param itemId id of the virtual item to be given
 * @exception VirtualItemNotFoundException
 */
+ (void)giveAmount:(int)amount ofItem:(NSString*)itemId;

/**
 * Takes from your user the given amount of the virtual item with the given `itemId`.
 * For example, when you want to downgrade a virtual good, you take the upgrade.
 * 
 * @param amount amount of the item to be given
 * @param itemId id of the virtual item to be taken
 * @exception VirtualItemNotFoundException
 */
+ (void)takeAmount:(int)amount ofItem:(NSString*)itemId;


/** VIRTUAL GOODS **/

/**
 * Equips the virtual good with the given `goodItemId`.
 * Equipping means that the user decides to currently use a specific virtual good.
 * For more details and examples see EquippableVG.
 *
 * @param goodItemId id of the virtual good to be equipped. Id MUST be of an `EquippableVG`.
 * @exception VirtualItemNotFoundException
 */
+ (void)equipVirtualGoodWithItemId:(NSString*)goodItemId;

/**
 * Unequips the virtual good with the given goodItemId. Unequipping means that the user decides to stop using the virtual good he is currently using.
 * For more details and examples see `EquippableVG`.
 *
 * @param goodItemId id of the virtual good to be unequipped. Id MUST be of an `EquippableVG`.
 * @exception VirtualItemNotFoundException
 */
+ (void)unEquipVirtualGoodWithItemId:(NSString*)goodItemId;

/**
 * Checks if the virtual good with the given `goodItemId` is equipped (currently being used).
 *
 * @param goodItemId id of the virtual good to check on. Id MUST be of an `EquippableVG`.
 * @exception VirtualItemNotFoundException
 */
+ (BOOL)isVirtualGoodWithItemIdEquipped:(NSString*)goodItemId;

/**
 * Retrieves the upgrade level of the virtual good with the given `goodItemId`.
 *
 * For Example:
 * Let's say there's a strength attribute to one of the characters in your game 
 *   and you provide your users with the ability to upgrade that strength on a
 *   scale of 1-3.
 * This is what you've created:
 *  1. SingleUseVG for "strength"
 *  2. UpgradeVG for strength 'level 1'
 *  3. UpgradeVG for strength 'level 2'
 *  4. UpgradeVG for strength 'level 3'
 * In the example, this function will retrieve the upgrade level for "strength" 
 *   (1, 2, or 3).
 *
 * @param goodItemId id of the virtual good whose upgrade level we want to know. 
 *   The `goodItemId` can be of any `VirtualGood`.
 * @return upgrade level
 * @exception VirtualItemNotFoundException if the item is not found.
 */
+ (int)goodUpgradeLevel:(NSString*)goodItemId;

/**
 * Retrieves the itemId of the current upgrade of the virtual good with the given `goodItemId`.
 *
 * @param goodItemId id of the virtual good whose upgrade id we want to know. The `goodItemId` can be of any VirtualGood.
 * @return upgrade id if exists, or empty string otherwise
 * @exception VirtualItemNotFoundException
 */
+ (NSString*)goodCurrentUpgrade:(NSString*)goodItemId;

/**
 * Upgrades the virtual good with the given `goodItemId` by doing the following:
 * 1. Checks if the good is currently upgraded or if this is the first time being upgraded.
 * 2. If the good is currently upgraded, upgrades to the next upgrade in the series, or in other words, buy()s the next upgrade. In case there are no more upgrades available (meaning the current upgrade is the last available) the function returns.
 * 3. If the good has never been upgraded before, the function upgrades it to the first available upgrade, or in other words, buy()s the first upgrade in the series.
 *
 * @param goodItemId the id of the virtual good to be upgraded. The upgradeItemId can be of an UpgradeVG
 * @exception VirtualItemNotFoundException
 */
+ (void)upgradeVirtualGood:(NSString*)goodItemId;

/**
 * Upgrades the good with the given `upgradeItemId` for FREE (you are GIVING the upgrade).
 * In case that the good is not an upgradeable item, an error message will be produced. `forceUpgrade()` is different than `upgradeVirtualGood()` because `forceUpgrade()` is a FREE upgrade.
 *
 * @param upgradeItemId id of the virtual good who we want to force an upgrade upon. The `upgradeItemId` can be of an `UpgradeVG`.
 * @exception VirtualItemNotFoundException
 */
+ (void)forceUpgrade:(NSString*)upgradeItemId;

/**
 * Removes all upgrades from the virtual good with the given `goodItemId`.
 *
 * @param goodItemId id of the virtual good we want to remove all upgrades from.
 * @exception VirtualItemNotFoundException
 */
+ (void)removeUpgrades:(NSString*)goodItemId;


/** NON-CONSUMABLES **/

/**
 * Checks if item with given itemId exists in `nonConsumableStorage`.
 *
 * @exception VirtualItemNotFoundException
 */
+ (BOOL) nonConsumableItemExists:(NSString*)itemId;

/**
 * Adds non-consumable item with the given itemId to `nonConsumableStorage`.
 *
 * @exception VirtualItemNotFoundException
 */
+ (void) addNonConsumableItem:(NSString*)itemId;

/**
 * Removes non-consumable item with the given itemId from `nonConsumableStorage`.
 *
 * @exception VirtualItemNotFoundException
 */
+ (void) removeNonConsumableItem:(NSString*)itemId;

@end
