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

#import "LifetimeVG.h"
#import "SoomlaUtils.h"
#import "StorageManager.h"
#import "VirtualGoodStorage.h"

@implementation LifetimeVG

static NSString* TAG = @"SOOMLA LifetimeVG";

/*
 see parent
 
 @param amount see parent.
 @return see parent.
 */
- (int)giveAmount:(int)amount withEvent:(BOOL)notify {
    if (amount > 1) {
        LogDebug(TAG, @"You tried to give more than one LifetimeVG. Will try to give one anyway.");
        amount = 1;
    }
    
    int balance = [[[StorageManager getInstance] virtualGoodStorage] balanceForItem:self.itemId];
    if (balance < 1) {
        return [[[StorageManager getInstance] virtualGoodStorage] addAmount:amount toItem:self.itemId withEvent:notify];
    }
    return 1;
}

/*
 see parent
 
 @param amount see parent.
 @return see parent.
 */
- (int)takeAmount:(int)amount withEvent:(BOOL)notify {
    if (amount > 1) {
        amount = 1;
    }
    
    int balance = [[[StorageManager getInstance] virtualGoodStorage] balanceForItem:self.itemId];
    if (balance > 0) {
        return [[[StorageManager getInstance] virtualGoodStorage] removeAmount:amount fromItem:self.itemId withEvent:notify];
    }
    return 0;
}

/*
 see parent
 
 @return see parent.
 */
- (BOOL)canBuy {
    int balance = [[[StorageManager getInstance] virtualGoodStorage] balanceForItem:self.itemId];
    
    return balance < 1;
}

@end
