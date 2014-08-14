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

#import "VirtualItemReward.h"
#import "VirtualItem.h"
#import "StoreInventory.h"
#import "StoreJSONConsts.h"
#import "VirtualItemNotFoundException.h"
#import "SoomlaUtils.h"

@implementation VirtualItemReward

@synthesize associatedItemId, amount;

static NSString* TAG = @"SOOMLA VirtualItemReward";

- (id)initWithRewardId:(NSString *)oRewardId andName:(NSString *)oName andAmount:(int)oAmount andAssociatedItemId:(NSString *)oAssociatedItemId {
    if (self = [super initWithRewardId:oRewardId andName:oName]) {
        self.amount = oAmount;
        self.associatedItemId = oAssociatedItemId;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.amount = [dict[VIR_AMOUNT] intValue];
        self.associatedItemId = dict[VIR_ASSOCITEMID];
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setObject:[NSNumber numberWithInt:self.amount] forKey:VIR_AMOUNT];
    [toReturn setObject:self.associatedItemId forKey:VIR_ASSOCITEMID];
    
    return toReturn;
}

- (BOOL)giveInner {
    @try {
        [StoreInventory giveAmount:self.amount ofItem:self.associatedItemId];
    }
    @catch (VirtualItemNotFoundException *ex) {
        LogError(TAG, ([NSString stringWithFormat:@"(give) Couldn't find associated itemId: %@", self.associatedItemId]));
        return NO;
    }
    
    return YES;
}

- (BOOL)takeInner {
    @try {
        [StoreInventory takeAmount:self.amount ofItem:self.associatedItemId];
    }
    @catch (VirtualItemNotFoundException *ex) {
        LogError(TAG, ([NSString stringWithFormat:@"(take) Couldn't find associated itemId: %@", self.associatedItemId]));
        return NO;
    }
    
    return YES;
}


@end
