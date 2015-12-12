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

#import "StoreInfo.h"
#import "StorageManager.h"
#import "KeyValDatabase.h"
#import "StoreJSONConsts.h"
#import "VirtualCategory.h"
#import "VirtualGood.h"
#import "VirtualCurrency.h"
#import "VirtualCurrencyPack.h"
#import "VirtualItemNotFoundException.h"
#import "MarketItem.h"
#import "SoomlaUtils.h"
#import "PurchaseType.h"
#import "PurchaseWithMarket.h"
#import "PurchaseWithVirtualItem.h"
#import "SingleUseVG.h"
#import "LifetimeVG.h"
#import "EquippableVG.h"
#import "SingleUsePackVG.h"
#import "UpgradeVG.h"
#import "KeyValueStorage.h"
#import "StoreConfig.h"

@implementation StoreInfo

@synthesize virtualCategories, virtualCurrencies, virtualCurrencyPacks, virtualGoods, virtualItems, purchasableItems, goodsCategories, goodsUpgrades;

static NSString* TAG = @"SOOMLA StoreInfo";
static int currentAssetsVersion = 0;
static BOOL nonConsumableMigrationNeeded = NO;

+ (StoreInfo*)getInstance{
    static StoreInfo* _instance = nil;
    
    @synchronized( self ) {
        if( _instance == nil ) {
            _instance = [[StoreInfo alloc ] init];
        }
    }
    
    return _instance;
}

+ (BOOL)isItemNonConsumable:(PurchasableVirtualItem*) pvi {
    return ([pvi isKindOfClass:[LifetimeVG class]] && [[pvi purchaseType] isKindOfClass:[PurchaseWithMarket class]]);
}

- (void)checkAndAddPurchasable:(PurchasableVirtualItem*)pvi {
    PurchaseType* purchaseType = pvi.purchaseType;
    if ([purchaseType isKindOfClass:[PurchaseWithMarket class]]) {
        [self.purchasableItems setObject:pvi forKey:((PurchaseWithMarket*) purchaseType).marketItem.productId];
    }
}

- (void)addVirtualGood:(VirtualGood*)good {
    [self.virtualGoods addObject:good];
    
    [self.virtualItems setObject:good forKey:good.itemId];
    
    [self checkAndAddPurchasable:good];
}

- (void) save {
    // put StoreInfo in the database as JSON
    NSString* storeInfoJSON = [SoomlaUtils dictToJsonString:[self toDictionary]];
    NSString* ec = [[NSString alloc] initWithData:[storeInfoJSON dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
    [KeyValueStorage setValue:ec forKey:[StoreInfo keyMetaStoreInfo]];
}

- (void)save:(VirtualItem*)virtualItem {
    [self save:virtualItem andSaveToDB:YES];
}

- (void)save:(VirtualItem*)virtualItem andSaveToDB:(BOOL)saveToDB {
    [self replaceVirtualItem:virtualItem];
    
    if (saveToDB) {
        [self save];
    }
}

- (void)saveWithVirtualItems:(NSArray*)virtualItemsToSave {
    [self saveWithVirtualItems:virtualItemsToSave andSaveToDB:YES];
}

- (void)saveWithVirtualItems:(NSArray*)virtualItemsToSave andSaveToDB:(BOOL)saveToDB {
    if (!virtualItemsToSave || (virtualItemsToSave.count == 0)) {
        return;
    }
    
    for (VirtualItem *virtualItem in virtualItemsToSave) {
        [self replaceVirtualItem:virtualItem];
    }
    
    if (saveToDB) {
        [self save];
    }
}

- (void)replaceVirtualItem:(VirtualItem*)virtualItem {
    [self.virtualItems setObject:virtualItem forKey:virtualItem.itemId];
    
    if ([virtualItem isKindOfClass:[VirtualCurrency class]]) {
        for(int i=0; i<[self.virtualCurrencies count]; i++) {
            if ([((VirtualCurrency*)[self.virtualCurrencies objectAtIndex:i]).itemId isEqualToString:virtualItem.itemId]) {
                [self.virtualCurrencies removeObjectAtIndex:i];
                break;
            }
        }
        [self.virtualCurrencies addObject:virtualItem];
    }
    
    if ([virtualItem isKindOfClass:[VirtualCurrencyPack class]]) {

        [self checkAndAddPurchasable:(VirtualCurrencyPack*)virtualItem];
        
        for(int i=0; i<[self.virtualCurrencyPacks count]; i++) {
            if ([((VirtualCurrencyPack*)[self.virtualCurrencyPacks objectAtIndex:i]).itemId isEqualToString:virtualItem.itemId]) {
                [self.virtualCurrencyPacks removeObjectAtIndex:i];
                break;
            }
        }
        [self.virtualCurrencyPacks addObject:virtualItem];
        
    }
    
    if ([virtualItem isKindOfClass:[VirtualGood class]]) {
        
        if ([virtualItem isKindOfClass:[UpgradeVG class]]) {
            NSMutableArray* upgrades = [self.goodsUpgrades objectForKey:((UpgradeVG*)virtualItem).goodItemId];
            if (!upgrades) {
                upgrades = [NSMutableArray array];
                [self.goodsUpgrades setObject:upgrades forKey:((UpgradeVG*)virtualItem).goodItemId];
            }
            [upgrades addObject:virtualItem];
        }
        
        [self checkAndAddPurchasable:(VirtualGood*)virtualItem];
        
        for(int i=0; i<[self.virtualGoods count]; i++) {
            if ([((VirtualGood*)[self.virtualGoods objectAtIndex:i]).itemId isEqualToString:virtualItem.itemId]) {
                [self.virtualGoods removeObjectAtIndex:i];
                break;
            }
        }
        [self.virtualGoods addObject:virtualItem];
    }
}

- (void)privInitializeWithIStoreAssets:(id)storeAssets {
    LogDebug(TAG, @"Initializing StoreInfo with a given store assets.");
    
    self.virtualGoods = [NSMutableArray arrayWithArray:[storeAssets virtualGoods]];
    self.virtualCurrencies = [NSMutableArray arrayWithArray:[storeAssets virtualCurrencies]];
    self.virtualCurrencyPacks = [NSMutableArray arrayWithArray:[storeAssets virtualCurrencyPacks]];
    self.virtualCategories = [NSMutableArray arrayWithArray:[storeAssets virtualCategories]];
    
    self.virtualItems = [NSMutableDictionary dictionary];
    self.purchasableItems = [NSMutableDictionary dictionary];
    self.goodsCategories = [NSMutableDictionary dictionary];
    self.goodsUpgrades = [NSMutableDictionary dictionary];
    
    for(VirtualCurrency* vi in self.virtualCurrencies) {
        [self.virtualItems setObject:vi forKey:vi.itemId];
    }
    
    for(VirtualCurrencyPack* vi in self.virtualCurrencyPacks) {
        [self.virtualItems setObject:vi forKey:vi.itemId];
        
        [self checkAndAddPurchasable:vi];
    }
    
    for(VirtualGood* vi in self.virtualGoods) {
        [self.virtualItems setObject:vi forKey:vi.itemId];
        
        if ([vi isKindOfClass:[UpgradeVG class]]) {
            NSMutableArray* upgrades = [self.goodsUpgrades objectForKey:((UpgradeVG*)vi).goodItemId];
            if (!upgrades) {
                upgrades = [NSMutableArray array];
                [self.goodsUpgrades setObject:upgrades forKey:((UpgradeVG*)vi).goodItemId];
            }
            [upgrades addObject:vi];
        }
        
        [self checkAndAddPurchasable:vi];
    }
    
    for(VirtualCategory* category in self.virtualCategories) {
        for(NSString* goodItemId in category.goodsItemIds) {
            [self.goodsCategories setObject:category forKey:goodItemId];
        }
    }
    
    // This is only for NonConsumable balance migration to LifetimeVGs.
    // Remove this code when no longer needed.
    if (nonConsumableMigrationNeeded) {
        LogDebug(TAG, @"NonConsumables balance migration is required. Doing it now.");
        [self nonConsBalancesToLTVGs];
    }
    
    [self save];
}

-(BOOL)checkAssetsArrayForMarketIdDuplicates:(NSArray *)assetsArray {
    NSMutableSet *marketItemIds = [NSMutableSet new];
    for (PurchasableVirtualItem *pvi in assetsArray) {
        if ([pvi.purchaseType isKindOfClass:[PurchaseWithMarket class]]) {
            NSString *currentMarketId = ((PurchaseWithMarket *)pvi.purchaseType).marketItem.productId;
            if ([marketItemIds containsObject:currentMarketId]) {
                return NO;
            }
            [marketItemIds addObject:currentMarketId];
        }
    }
    return YES;
}

-(BOOL)validateStoreAssets:(id<IStoreAssets>)storeAssets {
    if (storeAssets == nil) {
        LogError(TAG, @"The given store assets can't be null!");
        return NO;
    }
    if (![storeAssets virtualCurrencies] ||
            ![storeAssets virtualCurrencyPacks] ||
            ![storeAssets virtualGoods] ||
            ![storeAssets virtualCategories]) {
        LogError(TAG, @"All IStoreAssets methods shouldn't return NULL-pointer references!");
        return NO;
    }
    if (![self checkAssetsArrayForMarketIdDuplicates:storeAssets.virtualGoods]
            || ![self checkAssetsArrayForMarketIdDuplicates:storeAssets.virtualCurrencyPacks]) {
        LogError(TAG, @"The given store assets has duplicates at marketItem productId!");
        return NO;
    }
    return YES;
}

- (void)setStoreAssets:(id <IStoreAssets>)storeAssets{
    if (![self validateStoreAssets:storeAssets]) {
        return;
    }

    currentAssetsVersion = [storeAssets getVersion];
    
    // we prefer initialization from the database (storeAssets are only set on the first time the game is loaded)!
    if (![self loadFromDB]){
        [self privInitializeWithIStoreAssets:storeAssets];
    }
}

- (void)setStoreAssetsJSON:(NSString*)storeMetaJSON withVersion:(int)version {
    LogDebug(TAG, ([NSString stringWithFormat:@"trying to set json: %@", storeMetaJSON]));
    currentAssetsVersion = version;
    if (![self loadFromDB]) {
        
        if (![self fromJSONString: storeMetaJSON]) {
            LogError(TAG, @"Couldn't load from store meta json.");
            return;
        }
        [self save];
    }
}

- (BOOL)fromJSONString:(NSString *)storeInfoJSON {
    @try {
        
        NSDictionary* storeInfo = [SoomlaUtils jsonStringToDict:storeInfoJSON];
        
        self.virtualItems = [NSMutableDictionary dictionary];
        self.purchasableItems = [NSMutableDictionary dictionary];
        self.goodsCategories = [NSMutableDictionary dictionary];
        self.goodsUpgrades = [NSMutableDictionary dictionary];
        
        self.virtualCurrencies = [[NSMutableArray alloc] init];
        NSArray* currenciesDicts = [storeInfo objectForKey:JSON_STORE_CURRENCIES];
        for(NSDictionary* currencyDict in currenciesDicts){
            VirtualCurrency* o = [[VirtualCurrency alloc] initWithDictionary: currencyDict];
            [self.virtualCurrencies addObject:o];
            
            [self.virtualItems setObject:o forKey:o.itemId];
        }
        
        self.virtualCurrencyPacks = [[NSMutableArray alloc] init];
        NSArray* currencyPacksDicts = [storeInfo objectForKey:JSON_STORE_CURRENCYPACKS];
        for(NSDictionary* currencyPackDict in currencyPacksDicts){
            VirtualCurrencyPack* o = [[VirtualCurrencyPack alloc] initWithDictionary: currencyPackDict];
            [self.virtualCurrencyPacks addObject:o];
            
            [self.virtualItems setObject:o forKey:o.itemId];
            
            [self checkAndAddPurchasable:o];
        }
        
        
        NSDictionary* goodsDict = [storeInfo objectForKey:JSON_STORE_GOODS];
        NSArray* suGoods = [goodsDict objectForKey:JSON_STORE_GOODS_SU];
        NSArray* ltGoods = [goodsDict objectForKey:JSON_STORE_GOODS_LT];
        NSArray* eqGoods = [goodsDict objectForKey:JSON_STORE_GOODS_EQ];
        NSArray* upGoods = [goodsDict objectForKey:JSON_STORE_GOODS_UP];
        NSArray* paGoods = [goodsDict objectForKey:JSON_STORE_GOODS_PA];
        self.virtualGoods = [[NSMutableArray alloc] init];
        for(NSDictionary* gDict in suGoods){
            SingleUseVG* g = [[SingleUseVG alloc] initWithDictionary: gDict];
            [self addVirtualGood:g];
        }
        for(NSDictionary* gDict in ltGoods){
            LifetimeVG* g = [[LifetimeVG alloc] initWithDictionary: gDict];
            [self addVirtualGood:g];
        }
        for(NSDictionary* gDict in eqGoods){
            EquippableVG* g = [[EquippableVG alloc] initWithDictionary: gDict];
            [self addVirtualGood:g];
        }
        for(NSDictionary* gDict in upGoods){
            UpgradeVG* g = [[UpgradeVG alloc] initWithDictionary: gDict];
            
            NSMutableArray* upgrades = [self.goodsUpgrades objectForKey:g.goodItemId];
            if (!upgrades) {
                upgrades = [NSMutableArray array];
                [self.goodsUpgrades setObject:upgrades forKey:g.goodItemId];
            }
            [upgrades addObject:g];
            
            [self addVirtualGood:g];
        }
        for(NSDictionary* gDict in paGoods){
            SingleUsePackVG* g = [[SingleUsePackVG alloc] initWithDictionary: gDict];
            [self addVirtualGood:g];
        }
        
        self.virtualCategories = [[NSMutableArray alloc] init];
        NSArray* categoriesDicts = [storeInfo objectForKey:JSON_STORE_CATEGORIES];
        for(NSDictionary* categoryDict in categoriesDicts){
            VirtualCategory* c = [[VirtualCategory alloc] initWithDictionary: categoryDict];
            [self.virtualCategories addObject:c];
            
            for(NSString* goodItemId in c.goodsItemIds) {
                [self.goodsCategories setObject:c forKey:goodItemId];
            }
        }
        
        // everything went well... StoreInfo is initialized from the local DB.
        // it's ok to return now.
        
        return YES;
    } @catch (NSException* ex) {
        LogError(TAG, @"An error occured while trying to parse store info JSON.");
    }
    return NO;
}

- (BOOL)loadFromDB{
    [StoreInfo checkAndResetMetadata];
    
    NSString* key = [StoreInfo keyMetaStoreInfo];
    NSString* storeInfoJSON = [KeyValueStorage getValueForKey:key];
    
    if(!storeInfoJSON || [storeInfoJSON length] == 0){
        LogDebug(TAG, @"store json is not in DB yet.")
        return NO;
    }
    
    // This is done in case old versions of the DB exist (especially from
    // Cocos2dx) which used jsonType instead of className
    if ([storeInfoJSON rangeOfString:@"jsonType"].location != NSNotFound) {
        LogDebug(TAG, @"the StoreInfo JSON is from an older version. we need to delete and let it be recreated.");
        [KeyValueStorage deleteValueForKey:key];
        return NO;
    }
    
    LogDebug(TAG, ([NSString stringWithFormat:@"the metadata-economy json (from DB) is %@", storeInfoJSON]));
    
    return ([self fromJSONString:storeInfoJSON]);
}

- (NSDictionary*)toDictionary{
    
    NSMutableArray* currencies = [NSMutableArray array];
    for(VirtualCurrency* c in self.virtualCurrencies){
        [currencies addObject:[c toDictionary]];
    }
    
    NSMutableArray* packs = [NSMutableArray array];
    for(VirtualCurrencyPack* c in self.virtualCurrencyPacks){
        [packs addObject:[c toDictionary]];
    }
    
    NSMutableArray* suGoods = [NSMutableArray array];
    NSMutableArray* ltGoods = [NSMutableArray array];
    NSMutableArray* eqGoods = [NSMutableArray array];
    NSMutableArray* upGoods = [NSMutableArray array];
    NSMutableArray* paGoods = [NSMutableArray array];
    for(VirtualGood* g in self.virtualGoods){
        if ([g isKindOfClass:[SingleUseVG class]]) {
            [suGoods addObject:[g toDictionary]];
        } else if ([g isKindOfClass:[UpgradeVG class]]) {
            [upGoods addObject:[g toDictionary]];
        } else if ([g isKindOfClass:[EquippableVG class]]) {
            [eqGoods addObject:[g toDictionary]];
        } else if ([g isKindOfClass:[SingleUsePackVG class]]) {
            [paGoods addObject:[g toDictionary]];
        } else if ([g isKindOfClass:[LifetimeVG class]]) {
            [ltGoods addObject:[g toDictionary]];
        }
    }
    NSDictionary* goods = [NSDictionary dictionaryWithObjectsAndKeys:
                           suGoods, JSON_STORE_GOODS_SU,
                           ltGoods, JSON_STORE_GOODS_LT,
                           eqGoods, JSON_STORE_GOODS_EQ,
                           upGoods, JSON_STORE_GOODS_UP,
                           paGoods, JSON_STORE_GOODS_PA, nil];
    
    NSMutableArray* categories = [NSMutableArray array];
    for(VirtualCategory* c in self.virtualCategories){
        [categories addObject:[c toDictionary]];
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:categories forKey:JSON_STORE_CATEGORIES];
    [dict setObject:currencies forKey:JSON_STORE_CURRENCIES];
    [dict setObject:packs forKey:JSON_STORE_CURRENCYPACKS];
    [dict setObject:goods forKey:JSON_STORE_GOODS];
    
    return dict;
}

-(void) nonConsBalancesToLTVGs{
    for (VirtualGood* good in virtualGoods) {
        if ([good isKindOfClass:[LifetimeVG class]] &&
            [[good purchaseType] isKindOfClass:[PurchaseWithMarket class]]) {
            NSString* keyNonConsExist = [NSString stringWithFormat:@"%@%@.exists", DB_NONCONSUMABLE_KEY_PREFIX, [good itemId]];
            if ([KeyValueStorage getValueForKey:keyNonConsExist]){
                [good giveAmount:1];
                [KeyValueStorage deleteValueForKey:keyNonConsExist];
            }
        }
    }
    nonConsumableMigrationNeeded = NO;
}

+(BOOL)isMigrationRequired{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"MIGRATE_NONCONSUMABLES"];
}

- (VirtualItem*)virtualItemWithId:(NSString*)itemId {
    VirtualItem* vi = [self.virtualItems objectForKey:itemId];
    if (!vi) {
        @throw [[VirtualItemNotFoundException alloc] initWithLookupField:@"itemId" andLookupValue:itemId];
    }
    
    return vi;
}

- (NSArray*)allProductIds {
    NSMutableArray* array = [NSMutableArray array];
    
    for(PurchasableVirtualItem* pvi in purchasableItems) {
        [array addObject:pvi];
    }
    return array;
}

- (PurchasableVirtualItem*)purchasableItemWithProductId:(NSString*)productId {
    PurchasableVirtualItem* pvi = [self.purchasableItems objectForKey:productId];
    if (!pvi) {
        @throw [[VirtualItemNotFoundException alloc] initWithLookupField:@"productId" andLookupValue:productId];
    }
    
    return pvi;
}

- (VirtualCategory*)categoryForGoodWithItemId:(NSString*)goodItemId {
    VirtualCategory* cat = [self.goodsCategories objectForKey:goodItemId];
    
    if (!cat) {
        @throw [[VirtualItemNotFoundException alloc] initWithLookupField:@"goodItemId" andLookupValue:goodItemId];
    }
    
    return cat;
}

- (UpgradeVG*)firstUpgradeForGoodWithItemId:(NSString*)goodItemId {
    NSArray* upgrades = [self.goodsUpgrades objectForKey:goodItemId];
    if (upgrades) {
        for(UpgradeVG* upgradeVG in upgrades) {
            if ((!upgradeVG.prevGoodItemId) ||
                (upgradeVG.prevGoodItemId.length == 0)) {
                return upgradeVG;
            }
        }
    }
    
    return NULL;
}

- (UpgradeVG*)lastUpgradeForGoodWithItemId:(NSString*)goodItemId {
    NSArray* upgrades = [self.goodsUpgrades objectForKey:goodItemId];
    if (upgrades) {
        for(UpgradeVG* upgradeVG in upgrades) {
            if ((!upgradeVG.nextGoodItemId) ||
                (upgradeVG.nextGoodItemId.length == 0)) {
                return upgradeVG;
            }
        }
    }
    
    return NULL;
}

- (NSArray*)upgradesForGoodWithItemId:(NSString*)goodItemId {
    return [self.goodsUpgrades objectForKey:goodItemId];
}

- (BOOL)goodHasUpgrades:(NSString*)goodItemId {
    return [goodsUpgrades objectForKey:goodItemId] != NULL;
}

+ (void)checkAndResetMetadata {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    int mt_ver = (int)[defaults integerForKey:@"MT_VER"]; // Defaults to 0
    int sa_ver_old = [defaults objectForKey:@"SA_VER_OLD"] == nil ? -1 : (int)[defaults integerForKey:@"SA_VER_OLD"]; //Defaults to -1
    
    if (mt_ver < METADATA_VERSION){
        nonConsumableMigrationNeeded = YES;
    }
    
    if (mt_ver < METADATA_VERSION || sa_ver_old < currentAssetsVersion) {
        [defaults setInteger:METADATA_VERSION forKey:@"MT_VER"];
        [defaults setInteger:currentAssetsVersion forKey:@"SA_VER_OLD"];
        [defaults synchronize];
        
        [KeyValueStorage deleteValueForKey:[self keyMetaStoreInfo]];
    }
}

+ (NSString*) keyMetaStoreInfo {
    return @"meta.storeinfo";
}

@end
