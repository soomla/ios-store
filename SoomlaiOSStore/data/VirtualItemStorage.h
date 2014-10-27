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

@class VirtualItem;

/**
 ABSTRACT.
 This class is an abstract definition of a Virtual Item Storage.
 */
@interface VirtualItemStorage : NSObject {
    @protected
    NSString* tag;
}

/**
 Retrieves the balance of the given virtual item.
 
 @param item The virtual item whose balance is being fetched.
 @return The balance of the given virtual item.
 */
- (int)balanceForItem:(NSString*)itemId;

/**
 Adds the given amount of the given item to the storage.
 
 @param amount The amount of items to add.
 @param item The virtual item to add the given amount to.
 @return The balance of the given virtual item.
 */
- (int)addAmount:(int)amount toItem:(NSString*)itemId;
- (int)addAmount:(int)amount toItem:(NSString*)itemId withEvent:(BOOL)notify;

/**
 Removes the given amount of the given item from the storage.
 
 @param amount The amount of items to remove.
 @param item The virtual item to remove the given amount from.
 @return The balance of the given virtual item.
 */
- (int)removeAmount:(int)amount fromItem:(NSString*)itemId;
- (int)removeAmount:(int)amount fromItem:(NSString*)itemId withEvent:(BOOL)notify;

/**
 Sets the balance of the given virtual item.
 
 @param balance The amount to set of given virtual item.
 @param item The virtual item whose balance is to be set.
 @return The balance of the given virtual item.
 */
- (int)setBalance:(int)balance toItem:(NSString*)itemId;
- (int)setBalance:(int)balance toItem:(NSString*)itemId withEvent:(BOOL)notify;

/**
 Retrieves the balance of the virtual item with the given `itemId` (from the 
 `KeyValDatabase`).
 
 @param itemId Id of the virtual item whose balance is to be retrieved.
 @return String containing name of storage base, itemId, and balance
 */
- (NSString*)keyBalance:(NSString*)itemId;

/**
 Posts the given amount changed in the given balance of the given virtual item.
 
 @param item The virtual item whose balance has changed.
 @param balance The balance that has changed.
 @param amountAdded The amount added to the item's balance.
 */
- (void)postBalanceChangeToItem:(NSString*)itemId withBalance:(int)balance andAmountAdded:(int)amountAdded;

@end
