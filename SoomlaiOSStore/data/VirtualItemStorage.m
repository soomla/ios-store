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

#import "VirtualItemStorage.h"
#import "VirtualItem.h"
#import "StorageManager.h"
#import "KeyValDatabase.h"
#import "StoreUtils.h"
#import "KeyValueStorage.h"

@implementation VirtualItemStorage

- (int)balanceForItem:(VirtualItem*)item{
    LogDebug(tag, ([NSString stringWithFormat:@"trying to fetch balance for virtual item with itemId: %@", item.itemId]));
    
    NSString* key = [self keyBalance:item.itemId];
    NSString* val = [[[StorageManager getInstance] keyValueStorage] getValueForKey:key];
    
    if (!val || [val length]==0){
        return 0;
    }
    
    LogDebug(tag, ([NSString stringWithFormat:@"the balance for %@ is: %d", item.itemId, [val intValue]]));
    
    return [val intValue];
}

- (int)addAmount:(int)amount toItem:(VirtualItem*)item{
    return [self addAmount:amount toItem:item withEvent:YES];
}
- (int)addAmount:(int)amount toItem:(VirtualItem*)item withEvent:(BOOL)notify {
    LogDebug(tag, ([NSString stringWithFormat:@"adding %d %@", amount, item.name]));
    
    NSString* key = [self keyBalance:item.itemId];
    int balance = [self balanceForItem:item] + amount;
    [[[StorageManager getInstance] keyValueStorage] setValue:[NSString stringWithFormat:@"%d",balance] forKey:key];

    if (notify) {
        [self postBalanceChangeToItem:item withBalance:balance andAmountAdded:amount];
    }
    
    return balance;
}

- (int)removeAmount:(int)amount fromItem:(VirtualItem*)item{
    return [self removeAmount:amount fromItem:item withEvent:YES];
}

- (int)removeAmount:(int)amount fromItem:(VirtualItem*)item withEvent:(BOOL)notify {
    LogDebug(tag, ([NSString stringWithFormat:@"removing %d %@", amount, item.name]));
    
    NSString* key = [self keyBalance:item.itemId];
    int balance = [self balanceForItem:item];
	
    if ((balance - amount) < 0) {
	    amount = 0;
        
        if (notify)
        {
            [self postBalanceUnchangeToItem:item withBalance:balance andAmountAdded:amount];
        }
        
        return balance;
	}
    else
    {
        [[[StorageManager getInstance] keyValueStorage] setValue:[NSString stringWithFormat:@"%d",(balance - amount)] forKey:key];
    }
    
    if (notify) {
        [self postBalanceChangeToItem:item withBalance:balance andAmountAdded:(-1*amount)];
    }
    
    return balance;
}

- (int)setBalance:(int)balance toItem:(VirtualItem*)item {
    return [self setBalance:balance toItem:item withEvent:YES];
}
- (int)setBalance:(int)balance toItem:(VirtualItem*)item withEvent:(BOOL)notify {
    LogDebug(tag, ([NSString stringWithFormat:@"setting balance %d to %@", balance, item.name]));
    
    int oldBalance = [self balanceForItem:item];
    if (oldBalance == balance) {
        return balance;
    }
    
    NSString* key = [self keyBalance:item.itemId];
    [[[StorageManager getInstance] keyValueStorage] setValue:[NSString stringWithFormat:@"%d",balance] forKey:key];
    
    if (notify) {
        [self postBalanceChangeToItem:item withBalance:balance andAmountAdded:0];
    }
    
    return balance;
}

- (NSString*)keyBalance:(NSString*)itemId {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)postBalanceChangeToItem:(VirtualItem*)item withBalance:(int)balance andAmountAdded:(int)amountAdded {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass",
                                           NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
