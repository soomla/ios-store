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
#define EVENT_CUSTOM                        @"CustomEvent"

// Dictionary Elements
#define DICT_ELEMENT_REWARD                 @"reward"
#define DICT_ELEMENT_NAME                   @"name"
#define DICT_ELEMENT_EXTRA                  @"extra"

@interface SoomlaEventHandling : NSObject

+ (void)observeAllEventsWithObserver:(id)observer withSelector:(SEL)selector;
+ (void)postRewardGiven:(Reward *)reward;
+ (void)postRewardTaken:(Reward *)reward;
+ (void)postCustomEventWithName:(NSString*)name andExtraInfo:(NSDictionary*)extra;

@end
