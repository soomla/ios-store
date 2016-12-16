# Looking for great devs who want maintain and moderate this project !!
# If you want to take over... contact us at os@soom.la

*This project is a part of The [SOOMLA](http://project.soom.la) Framework which is a series of open source initiatives with a joint goal to help mobile game developers do more together. SOOMLA encourages better game design, economy modeling, social engagement, and faster development.*

Haven't you ever wanted an in-app purchase one liner that looks like this ?!

```objective-c
    [StoreInventory buyItemWithItemId:@"[itemId]"]
```

ios-store
---

*SOOMLA's Store Module for iOS*

**March 31st, 2014:** SoomlaStore will **automatically try to fetch prices** for PurchasableItems that has a purchase type of PurchaseWithMarket. The product ids that'll be found in the App Store will update the associated 'AppStoreItem' in special fields: appStorePrice, appStoreLocale, appStoreTitle, appStoreDescription.

**September 29th, 2013:** Server Side Verification is now implemented into ios-store. The server is a complimentary server provided by [SOOMLA](http://soom.la) to help you get your in-game purchases a bit more secured. This feature is not enabled by default. In order to enable Server Side verification go to StoreConfig.m and set  **VERIFY_PURCHASES = YES**.

Want to learn more about modelV3? Try these:  
* [Economy Model Objects](https://github.com/soomla/ios-store/wiki/Economy-Model-Objects)  
* [Handling Store Operations](https://github.com/soomla/ios-store/wiki/Handling-Store-Operations)

ios-store is the iOS flavor of SOOMLA's Store Module.

Check out our [Wiki] (https://github.com/soomla/ios-store/wiki) for more information about the project and how to use it better.

## Download

#### Pre baked libraries:

- [ios-store 3.6.22](http://library.soom.la/fetch/ios-store/3.6.22?cf=github)

#### From sources:
 - Clone this repository recursively: `git clone --recursive https://github.com/soomla/ios-store.git`
 - Run `./build_all` from project directory
 - Take created binaries from `build` directory and use it!

Getting Started
---

#### **WE USE ARC !**


Before doing anything, SOOMLA recommends that you go through [Selling with In-App Purchase](https://developer.apple.com/appstore/in-app-purchase/index.html).

1. The static libs and headers you need are in the zip you downloaded from the link above.

  * Set your project's "Library Search Paths" and "Header Search Paths" to that folder.
  * Add `-ObjC -lSoomlaiOSStore -lSoomlaiOSCore` to the project's "Other Linker Flags".

2. Make sure you have the following frameworks in your application's project: **Security, libsqlite3.0.dylib, StoreKit**.

3. Initialize **Soomla** with a secret that you chose to encrypt the user data. (For those who came from older versions, this should be the same as the old "custom secret"):

    ```objective-c
     [Soomla initializeWithSecret:@"[YOUR CUSTOM GAME SECRET HERE]"];
    ```
> The secret is your encryption secret for data saved in the DB.

4. Create your own implementation of _IStoreAssets_ in order to describe your specific game's assets. Initialize _SoomlaStore_ with the class you just created:

    ```objective-c
     [[SoomlaStore getInstance] initializeWithStoreAssets:[[YourStoreAssetsImplementation alloc] init]];
    ```

And that's it ! You have Storage and in-app purchasing capabilities... ALL-IN-ONE.

What's next? In App Purchasing.
---

When we implemented modelV3, we were thinking about ways people buy things inside apps. We figured many ways you can let your users purchase stuff in your game and we designed the new modelV3 to support 2 of them: PurchaseWithMarket and PurchaseWithVirtualItem.

**PurchaseWithMarket** is a PurchaseType that allows users to purchase a VirtualItem with the App Store.  
**PurchaseWithVirtualItem** is a PurchaseType that lets your users purchase a VirtualItem with a different VirtualItem. For Example: Buying 1 Sword with 100 Gems.

In order to define the way your various virtual items (Goods, Coins ...) are purchased, you'll need to create your implementation of IStoreAsset (the same one from step 4 in the "Getting Started" above).

Here is an example:

Lets say you have a _VirtualCurrencyPack_ you call `TEN_COINS_PACK` and a _VirtualCurrency_ you call `COIN_CURRENCY`:

```objective-c
VirtualCurrencyPack* TEN_COINS_PACK = [[VirtualCurrencyPack alloc] initWithName:@"10 Coins"
											   andDescription:@"A pack of 10 coins"
											        andItemId:@"10_coins"
											andCurrencyAmount:10
											 	  andCurrency:COIN_CURRENCY_ITEM_ID
											  andPurchaseType:[[PurchaseWithMarket alloc] initWithProductId:TEN_COINS_PACK_PRODUCT_ID andPrice:1.99]];
```

Now you can use _StoreInventory_ to buy your new VirtualCurrencyPack:

```objective-c
    [StoreInventory buyItemWithItemId:TEN_COINS_PACK.itemId];
```

And that's it! iOS-store knows how to contact the App Store for you and redirect the user to their purchasing system to complete the transaction. Don't forget to subscribe to events of successful or failed purchases (see [Event Handling](https://github.com/soomla/ios-store#event-handling)).

Storage & Meta-Data
---

When you initialize _SoomlaStore_, it automatically initializes two other classes: _StorageManager_ and _StoreInfo_. _StorageManager_ is the father of all storage related instances in your game. Use it to access the balances of virtual currencies and virtual goods (usually, using their itemIds). _StoreInfo_ is the mother of all meta data information about your specific game. It is initialized with your implementation of `IStoreAssets` and you can use it to retrieve information about your specific game.

The on-device storage is encrypted and kept in a SQLite database. SOOMLA is preparing a cloud-based storage service that will allow this SQLite to be synced to a cloud-based repository that you'll define. Stay tuned... this is just one of the goodies we prepare for you.

**Example Usages**

* Give the user 10 pieces of a virtual currency with itemId "currency_coin":

    ```objective-c
    [StoreInventory giveAmount:10 ofItem:@"currency_coin"];
    ```

* Take 10 virtual goods with itemId "green_hat":

    ```objective-c
    [StoreInventory takeAmount:10 ofItem:@"currency_coin"];
    ```

* Get the current balance of a virtual good with itemId "green_hat" (here we decided to show you the 'long' way. you can also use StoreInventory):

    ```objective-c
    VirtualGood* greenHat = (VirtualGood*)[[StoreInfo getInstance] virtualItemWithId:@"green_hat"];
    int greenHatsBalance = [[[StorageManager getInstance] virtualGoodStorage] balanceForItem:greenHat];
    ```

Security
---

If you want to protect your application from 'bad people' (and who doesn't?!), you might want to follow some guidelines:

+ SOOMLA keeps the game's data in an encrypted database. In order to encrypt your data, SOOMLA generates a private key out of several parts of information. Soomla's secret (before v3.4.0 is was known as custom secret) is one of them. SOOMLA recommends that you change this value before you release your game. BE CAREFUL: You can change this value once! If you try to change it again, old data from the database will become unavailable.


Event Handling
---

SOOMLA lets you get notifications on various events and implement your own application specific behavior.

> Your behavior is an addition to the default behavior implemented by SOOMLA. You don't replace SOOMLA's behavior.

In order to observe store events you need to import EventHandling.h and then you can add a notification to *NSNotificationCenter*:

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourCustomSelector:) name:EVENT_ITEM_PURCHASED object:nil];

OR, you can observe all events with the same selector by calling:

    [EventHandling observeAllEventsWithObserver:self withSelector:@selector(yourCustomSelector:)];

Our way of saying "Thanks !"
---

Other open-source projects that we use:

* [FBEncryptor](https://github.com/dev5tec/FBEncryptor)

Contribution
---
SOOMLA appreciates code contributions! You are more than welcome to extend the capabilities of SOOMLA.

Fork -> Clone -> Implement -> Add documentation -> Test -> Pull-Request.

IMPORTANT: If you would like to contribute, please follow our [Documentation Guidelines](https://github.com/soomla/ios-store/blob/master/documentation.md). Clear, consistent comments will make our code easy to understand.

## SOOMLA, Elsewhere ...

+ [Framework Website](http://www.soom.la/)
+ [Knowledge Base](http://know.soom.la/)


<a href="https://www.facebook.com/pages/The-SOOMLA-Project/389643294427376"><img src="http://know.soom.la/img/tutorial_img/social/Facebook.png"></a><a href="https://twitter.com/Soomla"><img src="http://know.soom.la/img/tutorial_img/social/Twitter.png"></a><a href="https://plus.google.com/+SoomLa/posts"><img src="http://know.soom.la/img/tutorial_img/social/GoogleP.png"></a><a href ="https://www.youtube.com/channel/UCR1-D9GdSRRLD0fiEDkpeyg"><img src="http://know.soom.la/img/tutorial_img/social/Youtube.png"></a>

License
---
Apache License. Copyright (c) 2012-2014 SOOMLA. http://project.soom.la
+ http://opensource.org/licenses/Apache-2.0
