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

@class VirtualGoodStorage;
@class VirtualCurrencyStorage;
@class VirtualItemStorage;
@class VirtualItem;

/**
 This is the place where all the relevant storage classes are created.
 This class contains static methods for you to retrieve the various storages.
 You will usually need the storage in order to get/set the amounts of virtual
 goods/currencies.
 */
@interface StorageManager : NSObject{
    VirtualGoodStorage* virtualGoodStorage;
    VirtualCurrencyStorage* virtualCurrencyStorage;
}

@property (nonatomic, retain)VirtualGoodStorage* virtualGoodStorage;
@property (nonatomic, retain)VirtualCurrencyStorage* virtualCurrencyStorage;

+ (StorageManager*)getInstance;

- (id)init;

/**
 Checks if the item belongs to `VirtualGoodStorage` or `VirtualCurrencyStorage`.

 @param item the item to check what type of storage it belongs to.
 @return the instance of the relevant storage.
 */
- (VirtualItemStorage*)virtualItemStorage:(VirtualItem*)item;


@end
