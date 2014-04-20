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
 * throws InsufficientFundsException, VirtualItemNotFoundException
 */
+ (void)buyItemWithItemId:(NSString*)itemId;

/** Virtual Items **/

/**
 * The itemId must be of a VirtualCurrency or SingleUseVG or LifetimeVG or EquippableVG
 *
 * throws VirtualItemNotFoundException
 */
+ (int)getItemBalance:(NSString*)itemId;
/**
 *
 * throws VirtualItemNotFoundException
 */
+ (BOOL)giveAmount:(int)amount ofItem:(NSString*)itemId;
/**
 *
 * throws VirtualItemNotFoundException
 */
+ (BOOL)takeAmount:(int)amount ofItem:(NSString*)itemId;

/** Virtual Goods **/
/**
 * The goodItemId must be of a EquippableVG
 *
 * throws VirtualItemNotFoundException
 */
+ (void)equipVirtualGoodWithItemId:(NSString*)goodItemId;
/**
 * The goodItemId must be of a EquippableVG
 *
 * throws VirtualItemNotFoundException
 */
+ (void)unEquipVirtualGoodWithItemId:(NSString*)goodItemId;
/**
 * The goodItemId must be of a EquippableVG
 *
 * throws VirtualItemNotFoundException
 */
+ (BOOL)isVirtualGoodWithItemIdEquipped:(NSString*)goodItemId;
/**
 * The goodItemId can be of any VirtualGood
 *
 * throws VirtualItemNotFoundException
 */
+ (int)goodUpgradeLevel:(NSString*)goodItemId;
/**
 * The goodItemId can be of any VirtualGood
 *
 * throws VirtualItemNotFoundException
 */
+ (NSString*)goodCurrentUpgrade:(NSString*)goodItemId;
/**
 * The goodItemId can be of any VirtualGood
 *
 * throws VirtualItemNotFoundException
 */
+ (void)upgradeVirtualGood:(NSString*)goodItemId;

/**
 * The upgradeItemId can be of an UpgradeVG
 *
 * throws VirtualItemNotFoundException
 */
+ (void)forceUpgrade:(NSString*)upgradeItemId;

/**
 * The goodItemId can be of any VirtualGood
 *
 * throws VirtualItemNotFoundException
 */
+ (void)removeUpgrades:(NSString*)goodItemId;

/** NonConsumables **/
/**
 *
 * throws VirtualItemNotFoundException
 */
+ (BOOL) nonConsumableItemExists:(NSString*)itemId;
/**
 *
 * throws VirtualItemNotFoundException
 */
+ (void) addNonConsumableItem:(NSString*)itemId;
/**
 *
 * throws VirtualItemNotFoundException
 */
+ (void) removeNonConsumableItem:(NSString*)itemId;

@end
