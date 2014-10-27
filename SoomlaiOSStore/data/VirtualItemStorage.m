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

#import "VirtualItemStorage.h"
#import "VirtualItem.h"
#import "StorageManager.h"
#import "KeyValDatabase.h"
#import "SoomlaUtils.h"
#import "KeyValueStorage.h"

@implementation VirtualItemStorage

- (int)balanceForItem:(NSString*)itemId{
    LogDebug(tag, ([NSString stringWithFormat:@"trying to fetch balance for virtual item with itemId: %@", itemId]));
    
    NSString* key = [self keyBalance:itemId];
    NSString* val = [KeyValueStorage getValueForKey:key];
    
    if (!val || [val length]==0){
        return 0;
    }
    
    LogDebug(tag, ([NSString stringWithFormat:@"the balance for %@ is: %d", itemId, [val intValue]]));
    
    return [val intValue];
}

- (int)addAmount:(int)amount toItem:(NSString*)itemId{
    return [self addAmount:amount toItem:itemId withEvent:YES];
}
- (int)addAmount:(int)amount toItem:(NSString*)itemId withEvent:(BOOL)notify {
    LogDebug(tag, ([NSString stringWithFormat:@"adding %d %@", amount, itemId]));
    
    NSString* key = [self keyBalance:itemId];
    int balance = [self balanceForItem:itemId] + amount;
    [KeyValueStorage setValue:[NSString stringWithFormat:@"%d",balance] forKey:key];

    if (notify) {
        [self postBalanceChangeToItem:itemId withBalance:balance andAmountAdded:amount];
    }
    
    return balance;
}

- (int)removeAmount:(int)amount fromItem:(NSString*)itemId{
    return [self removeAmount:amount fromItem:itemId withEvent:YES];
}

- (int)removeAmount:(int)amount fromItem:(NSString*)itemId withEvent:(BOOL)notify {
    LogDebug(tag, ([NSString stringWithFormat:@"removing %d %@", amount, itemId]));
    
    NSString* key = [self keyBalance:itemId];
    int balance = [self balanceForItem:itemId] - amount;
	if (balance < 0) {
	    balance = 0;
	    amount = 0;
	}
    [KeyValueStorage setValue:[NSString stringWithFormat:@"%d",balance] forKey:key];
    
    if (notify) {
        [self postBalanceChangeToItem:itemId withBalance:balance andAmountAdded:(-1*amount)];
    }
    
    return balance;
}

- (int)setBalance:(int)balance toItem:(NSString*)itemId {
    return [self setBalance:balance toItem:itemId withEvent:YES];
}
- (int)setBalance:(int)balance toItem:(NSString*)itemId withEvent:(BOOL)notify {
    LogDebug(tag, ([NSString stringWithFormat:@"setting balance %d to %@", balance, itemId]));
    
    int oldBalance = [self balanceForItem:itemId];
    if (oldBalance == balance) {
        return balance;
    }
    
    NSString* key = [self keyBalance:itemId];
    [KeyValueStorage setValue:[NSString stringWithFormat:@"%d",balance] forKey:key];
    
    if (notify) {
        [self postBalanceChangeToItem:itemId withBalance:balance andAmountAdded:0];
    }
    
    return balance;
}

- (NSString*)keyBalance:(NSString*)itemId {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)postBalanceChangeToItem:(NSString*)itemId withBalance:(int)balance andAmountAdded:(int)amountAdded {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
