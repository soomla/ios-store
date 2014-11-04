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

@class VirtualCategory;
@class VirtualCurrency;
@class VirtualGood;
@class VirtualCurrencyPack;
@class VirtualItem;
@class PurchasableVirtualItem;
@class UpgradeVG;

/**
 This class holds the store's metadata including:
 virtual currencies,
 virtual currency packs,
 all virtual goods,
 virtual categories, and
 non-consumables
 */
@interface StoreInfo : NSObject{
    @private
    NSMutableDictionary* virtualItems;
    NSMutableDictionary* purchasableItems;
    NSMutableDictionary* goodsCategories;
    NSMutableDictionary* goodsUpgrades;
    @public
    NSMutableArray* virtualCurrencies;
    NSMutableArray* virtualGoods;
    NSMutableArray* virtualCurrencyPacks;
    NSMutableArray* virtualCategories;
}

@property (nonatomic, retain) NSMutableArray* virtualCurrencies;
@property (nonatomic, retain) NSMutableArray* virtualGoods;
@property (nonatomic, retain) NSMutableArray* virtualCurrencyPacks;
@property (nonatomic, retain) NSMutableArray* virtualCategories;
@property (nonatomic, retain) NSMutableDictionary* virtualItems;
@property (nonatomic, retain) NSMutableDictionary* purchasableItems;
@property (nonatomic, retain) NSMutableDictionary* goodsCategories;
@property (nonatomic, retain) NSMutableDictionary* goodsUpgrades;

+ (StoreInfo*)getInstance;

/**
 Checks if a given PurchasableVirtualItem is a non-consumable item
 @param pvi - the PurchasableVirtualItem to check
 @return YES if if pvi is non-consumable, NO otherwise
 */
+ (BOOL)isItemNonConsumable:(PurchasableVirtualItem*) pvi;

/**
 Initializes `StoreInfo`, either from `IStoreAssets` or from database.
 On first initialization, when the database doesn't have any previous version 
 of the store metadata, `StoreInfo` gets loaded from the given `IStoreAssets`.
 After the first initialization, `StoreInfo` will be initialized from the 
 database.
 
 IMPORTANT: If you want to override the current `StoreInfo`, you'll have to 
 bump the version of your implementation of `IStoreAssets` in order to remove 
 the metadata when the application loads. Bumping the version is done by 
 returning a higher number in `IStoreAssets`'s function `getVersion`.
 
 @param storeAssets Your game economy.
 */
- (void)setStoreAssets:(id <IStoreAssets>)storeAssets;

- (void)setStoreAssetsJSON:(NSString*)storeMetaJSON withVersion:(int)version;

/**
 Initializes `StoreInfo` from the database.
 This action should be performed only once during the lifetime of a session of 
 the game. `SoomlaStore` automatically initializes `StoreInfo`.
 Don't do it if you don't know what you're doing.
 
 @return YES if successful, NO otherwise.
 */
- (BOOL)loadFromDB;

/**
 Converts this to an `NSDictionary`.
 
 @return `StoreInfo` as an `NSDictionary`.
 */
- (NSDictionary*)toDictionary;

/**
 Retrieves a single `VirtualItem` that resides in the metadata.
 
 @param itemId The item id of the required `VirtualItem`.
 @return The virtual item with the given `itemId`.
 @exception VirtualItemNotFoundException Thrown when a virtual item with the 
    given `itemId` is not found.
 */
- (VirtualItem*)virtualItemWithId:(NSString*)itemId;

/**
 Retrieves a single `PurchasableVirtualItem` that resides in the metadata.
 
 IMPORTANT: The retrieved `PurchasableVirtualItem` has a purchaseType of 
 `PurchaseWithMarket`. This is why we fetch here with `productId` and not with 
 `itemId` (`productId` is the id of the product in the App Store).
 
 @param productId The product id of the required `PurchasableVirtualItem`.
 @return The purchasable virtual item with the given `productId`.
 @exception VirtualItemNotFoundException when the given productId was not found.
 */
- (PurchasableVirtualItem*)purchasableItemWithProductId:(NSString*)productId;

/**
 Retrieves the `VirtualCategory` that the `VirtualGood` with the given 
 `goodItemId` belongs to.
 
 @param goodItemId The item id of the virtual good whose category is being 
    retrieved.
 @return The `VirtualCategory` for the `VirtualGood` with the given 
    `goodItemId`.
 @exception VirtualItemNotFoundException Thrown when the given `goodItemId` is 
    not found.
 */
- (VirtualCategory*)categoryForGoodWithItemId:(NSString*)goodItemId;

/**
 Retrieves the first `UpgradeVG` for the `VirtualGood` with the given `itemId`.
 
 @param goodItemId The `VirtualGood` whose upgrade is being retrieved.
 @return The first `UpgradeVG` for the virtual good with the given `itemId`.
 */
- (UpgradeVG*)firstUpgradeForGoodWithItemId:(NSString*)goodItemId;

/**
 Retrieves the last `UpgradeVG` for the `VirtualGood` with the given `itemId`.
 
 @param goodItemId the `VirtualGood` we're searching the upgrade for.
 @return The last `UpgradeVG` for the virtual good with the given `ItemId`.
 */
- (UpgradeVG*)lastUpgradeForGoodWithItemId:(NSString*)goodItemId;

/**
 Retrieves all `UpgradeVG`s for the `VirtualGood` with the given`itemId`.
 
 @param goodItemId the `VirtualGood` we're searching the upgrades for.
 @return Array of all upgrades for the good with the given item id.
 */
- (NSArray*)upgradesForGoodWithItemId:(NSString*)goodItemId;

/**
 Retrieves all `productId`s.
 
 @return All product ids.
 */
- (NSArray*)allProductIds;

/**
 Checks if the virtual good with the given `goodItemId` has upgrades.
 
 @return YES if the good has upgrades, NO otherwise.
 */
- (BOOL)goodHasUpgrades:(NSString*)goodItemId;

/**
 Saves the store's metadata in the database as JSON.
 */
- (void)save;

/**
 Replaces the given virtual item, and then saves the store's metadata.
 
 @param virtualItem The virtual item to save.
 */
- (void)save:(VirtualItem*)virtualItem;

/**
 Replaces an old virtual item with a new one by doing the following:
 1. Determines the type of the given virtual item.
 2. Looks for the given virtual item in the relevant list, according to its type.
 3. If found, removes it.
 4. Adds the given virtual item.
 
 @param virtualItem The virtual item that replaces the old one if exists.
 */
- (void)replaceVirtualItem:(VirtualItem*)virtualItem;
@end
