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
#import "SoomlaEntity.h"

/**
 ABSTRACT.
 This is the parent class of all virtual items in the application.
 Almost every entity in your virtual economy will be a virtual item. There
 are many types of virtual items - each one of the various types extends
 `VirtualItem` and adds its own behavior on top of it.
 */
@interface VirtualItem : SoomlaEntity {
}

@property (retain, nonatomic) NSString* itemId;

- (id)init;

/**
 Constructor.
 
 @param oName The name of the virtual item.
 @param oDescription The description of the virtual item.
 @param oItemId The id of the virtual item. 
 */
- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription andItemId:(NSString*)oItemId;

/** 
 Constructor.
 Generates an instance of `VirtualItem` from an `NSDictionary`.
 
 @param dict An `NSDictionary` representation of the wanted `VirtualItem`.
 */
- (id)initWithDictionary:(NSDictionary*)dict;

/**
 Converts the current `VirtualItem` to an `NSDictionary`.
 
 @return This instance of VirtualItemas an `NSDictionary`.
 */
- (NSDictionary*)toDictionary;

/**
 Gives your user the given amount of the specific `VirtualItem`.
 For example, when your users play your game for the first time you GIVE them
 1000 gems for free.
 
 NOTE: This action is different than `buy`:
 You use `giveAmount` to give your user something for free.
 You use `buy` to give your user something and get something in return.
 
 @param amount The amount of the specific item to be given.
 @return The balance after the giving process.
 */
- (int)giveAmount:(int)amount;
- (int)giveAmount:(int)amount withEvent:(BOOL)notify;

/**
 Takes from your user the given amount of the specific virtual item.
 For example, when you want to downgrade a virtual good, you take the upgrade.
 
 @param amount The amount of the specific item to be taken.
 @return The balance after the taking process.
 */
- (int)takeAmount:(int)amount;
- (int)takeAmount:(int)amount withEvent:(BOOL)notify;

/**
 Resets this Virtual Item's balance to the given balance.
 
 @param balance The balance of the current virtual item.
 @return The balance after the reset process.
 */
- (int)resetBalance:(int)balance;
- (int)resetBalance:(int)balance withEvent:(BOOL)notify;
@end
