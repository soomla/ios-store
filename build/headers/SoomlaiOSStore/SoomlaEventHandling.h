//
//  SoomlaEventHandling.h
//  SoomlaiOSProfile
//
//  Created by Gur Dotan on 6/2/14.
//  Copyright (c) 2014 Soomla. All rights reserved.
//

@class Reward;

// Events
#define EVENT_REWARD_GIVEN                  @"RewardGiven"
#define EVENT_REWARD_TAKEN                  @"RewardTaken"

// Dictionary Elements
#define DICT_ELEMENT_REWARD                 @"reward"


@interface SoomlaEventHandling : NSObject

+ (void)observeAllEventsWithObserver:(id)observer withSelector:(SEL)selector;
+ (void)postRewardGiven:(Reward *)reward;
+ (void)postRewardTaken:(Reward *)reward;

@end
