### v3.6.4 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.3...v3.6.4)

* New Features
  * Added functions to reset state into StoreInventory

### v3.6.3 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.2...v3.6.3)

* Fixes
  * loadFromDB always returns NO, using empty string as default dictionary value a MarketItem

### v3.6.2 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.1...v3.6.2)

* Fixes
  * Fixed VirtualItemNotFoundException creation with nil itemId (This issue was preventing the first upgrade of goods)

### v3.6.1 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.0...v3.6.1)

* New Features
  * Added a helper function in StoreInventory to fetch the state of balances in the game

### v3.6.0 [view commit logs](https://github.com/soomla/ios-store/compare/v3.5.0...v3.6.0)

* Changes
  * Removed NonConsumables in favor of the better usage of them with LifetimeVGs.
  * Changed the API of storages to work with itemIds instead of actual model objects - Simplification.

### v3.5.0 [view commit logs](https://github.com/soomla/ios-store/compare/v3.4.1...v3.5.0)

***Important***: this is a breaking release. Read the changes carefully.

* Changes:
    * **BREAKING**: `NonConsumableItem` class was **removed**. To create non-consumable item, use `LifeTimeVG` instead.

* Fixes:
    * Fixed issue [#30](https://github.com/soomla/ios-store/issues/30)

### v3.4.1 [view commit logs](https://github.com/soomla/ios-store/compare/v3.4.0...v3.4.1)

* New Features
  * Added the option to provide a payload to the 'buy' function

* Fixed
  * Configuration fixes
  * SOOM_CLASSNAME assigned in parent reward

### v3.4.0 [view commit logs](https://github.com/soomla/ios-store/compare/v3.3.1...v3.4.0)

* New Features
  * Some core objects and features were extracted to a separate project [soomla-ios-core](https://github.com/soomla/soomla-ios-core).
  * SOOM_SEC is no longer relevant. You only supply one secret called Soomla Secret when you initialize "Soomla" (soomla core).

* Changes
  * StoreController is now called SoomlaStore.


### v3.3.1 [view commit logs](https://github.com/soomla/ios-store/compare/v3.3.0...v3.3.1)

* New Features
  * Added the option to overwrite an object in StoreInfo and save it.

* Fixes
  * Enforce providing a SOOM_SEC in obfuscator.
  * If the purchasable item is NonConsumableItem and it already exists then we don't fire any events.

* Optimizations
  * Added build phase to create multiple platform static lib.

### v3.3.0 [view commit logs](https://github.com/soomla/ios-store/compare/v3.2.2...v3.3.0)

* New Features
  * ios-store will now refresh details of market items on initialization.
  * Added the option to fetch prices from the app store.
  * Added the receipt of a successful purchase to EVENT_APPSTORE_PURCHASED's userInfo.

* Optimizations
  * Fixed Names of objects and events so they match in all SOOMLA plugins.
