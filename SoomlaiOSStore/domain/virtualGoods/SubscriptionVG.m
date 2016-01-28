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

#import "SubscriptionVG.h"
#import "SoomlaUtils.h"
#import "StorageManager.h"
#import "VirtualGoodStorage.h"


@implementation SubscriptionVG {

}

- (id)initWithName:(NSString *)oName andDescription:(NSString *)oDescription
         andItemId:(NSString *)oItemId andPurchaseType:(PurchaseType *)oPurchaseType andDueDate:(NSDate *)dueDate {
    if (self = [super initWithName:oName andDescription:oDescription andItemId:oItemId andPurchaseType:oPurchaseType]) {
        self.dueDate = dueDate;
    }
    return self;
}

static NSString* TAG = @"SOOMLA SubscriptionVG";

/*
 see parent

 @param amount see parent.
 @return see parent.
 */
- (int)giveAmount:(int)amount withEvent:(BOOL)notify {
    if (amount > 1) {
        LogDebug(TAG, @"You tried to give more than one SubscriptionVG. Will try to give one anyway.");
        amount = 1;
    }

    if (self.canBuy) {
        return [[[StorageManager getInstance] virtualGoodStorage] addAmount:amount toItem:self.itemId withEvent:notify];
    } else {
        LogDebug(TAG, @"You can't buy SubscriptionVG right now, because current SubscriptionVG is still active.");
        return 1;
    }
}

/*
 see parent

 @return see parent.
 */
- (BOOL)canBuy {
    return [super canBuy] && (self.dueDate == nil || [self.dueDate compare:[NSDate date]] == NSOrderedDescending);
}

-(void)setDueDate:(NSDate *)dueDate {
    [[[StorageManager getInstance] virtualGoodStorage] setDueDate:dueDate forGood:self.itemId];
}

-(NSDate *)dueDate {
    return [[[StorageManager getInstance] virtualGoodStorage] dueDateForGood:self.itemId];
}

@end