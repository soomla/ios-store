### v3.6.22 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.21...v3.6.22)

* Fixes
  * Change type of `marketPriceMicros` variable to avoid type overflow

* Changes
  * Change verification URL

### v3.6.21 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.20...v3.6.21)

* Changes
  * Changed price of MarketItem to have only 2 decimal digits

### v3.6.20 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.19...v3.6.20)

* Changes
  * Added `isRestoring` flag for purchase events

### v3.6.19 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.18...v3.6.19)

* Changes
  * Removed binaries from repo

### v3.6.18 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.17...v3.6.18)

* Changes
  * Added validation - not allowing null pointers in IStoreAssets

### v3.6.17 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.16...v3.6.17)

* New Features
  * Add Verification Started Event to signal when the verification has begun

### v3.6.16 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.15...v3.6.16)

* Features
  * Added Market Purchase Deferred handling

### v3.6.15 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.14...v3.6.15)

* Fixes
  * StoreInventory.RemoveGoodUpgrades crash when upgrade id is null

### v3.6.14 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.13...v3.6.14)

* Changes
  * Removed binaries and improved build scripts

* Fixes
  * Wrong behaviour if purchasable items have the same product ID

### v3.6.13 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.12...v3.6.13)

* Changes
  * Added Fraud Protection flag to OnMarketPurchaseStarted event

### v3.6.12 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.11...v3.6.12)

* Changes
  * Added version in code

### v3.6.11 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.10...v3.6.11)

* Fixes
  * Fixed crash when using LocaliAPStore and getting verification confirmation from server

* Changes
  * Added refresh of receipt in case it doesn't exist, and finalize transaction if still doesn't exist after refresh

### v3.6.10 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.9...v3.6.10)

* Changes
  * Added method to retry unfinished transactions after billing service is loaded.
  * Allowing to force verification on purchases that failed verification b/c of itunes servers didn't work properly.
  * For MarketPurchaseEvent we bundle the specific provider extra params inside a Hash

* Fixes
  * Saving SoomlaVerification objects' pointers until they are not needed anymore.

### v3.6.9 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.8...v3.6.9)

* Changes
  * Removed Consumable struct from MarketItem   (***breaking change***)
  * Supporting new type of verification

### v3.6.8 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.7...v3.6.8)

* Fixes
  * Fixing restore transactions not working when verification is used
  * Guarding against nil error message in refresh failed (iOS6 only)

### v3.6.7 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.6...v3.6.7)

* Fixes
  * Current state balances will now include upgrades balances
  * Fixing KVS issues from submodule

### v3.6.6 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.5...v3.6.6)

* New Features
  * Store will now save your market item details to local storage

### v3.6.5 [view commit logs](https://github.com/soomla/ios-store/compare/v3.6.4...v3.6.5)

* Changes
  * Upgrading submodules

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
