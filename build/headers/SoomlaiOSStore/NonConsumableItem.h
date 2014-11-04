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

#import "PurchasableVirtualItem.h"

/**
 A representation of a non-consumable item in the App Store.
 These kinds of items are bought by the user once and kept for him/her forever.
 
 NOTE: Don't be confused: this is not a `LifetimeVG`, it's a Non-Consumable item 
 in the App Store. This means that the product is purchased only once per user 
 (such as a new level in a game), and is remembered by the App Store.
 
 Inheritance: NonConsumableItem > PurchasableVirtualItem > VirtualItem
 */
@interface NonConsumableItem : PurchasableVirtualItem {
}

/**
 Constructor
 
 @param oName see parent
 @param oDescription see parent
 @param oItemId see parent
 @param oPurchaseType see parent
 */
- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
                andItemId:(NSString*)oItemId andPurchaseType:(PurchaseType*)oPurchaseType;

/**
 see parent
 
 @param dict see parent.
 */
- (id)initWithDictionary:(NSDictionary*)dict;

/**
 see parent
 
 @return see parent.
 */
- (NSDictionary*)toDictionary;

@end
