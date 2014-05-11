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

/**
 * When a user tries to equip a virtual good which he does not own.
 *
 * Real Game Example:
 *  Example Inventory: { currency_coin: 100, robot_character: 3 }
 *  Suppose that your user would like to equip (LOCAL) a robot_character.
 *  You'll probably call equipVirtualGood("robot_character").
 *  NotEnoughGoodException will be thrown with "robot_character" as the itemId.
 *  You can catch this exception in order to notify the user that he doesn't
 *  own a robot_character (so he cannot equip it!).
 */
@interface NotEnoughGoodsException : NSException

/**
 * Constructor
 *
 * @param itemId of the item that caused the exception
 */
- (id)initWithItemId:(NSString*)itemId;

@end
