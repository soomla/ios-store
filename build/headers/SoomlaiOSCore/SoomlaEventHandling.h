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
#define EVENT_KEYVALUE_CHANGE               @"KeyValueChange"

// Dictionary Elements
#define DICT_ELEMENT_REWARD                 @"reward"
#define DICT_ELEMENT_NAME                   @"name"
#define DICT_ELEMENT_EXTRA                  @"extra"
#define DICT_ELEMENT_KEY                    @"key"
#define DICT_ELEMENT_VAL                    @"val"

@interface SoomlaEventHandling : NSObject

+ (void)observeAllEventsWithObserver:(id)observer withSelector:(SEL)selector;
+ (void)postRewardGiven:(NSString *)rewardId;
+ (void)postRewardTaken:(NSString *)rewardId;
+ (void)postCustomEventWithName:(NSString*)name andExtraInfo:(NSDictionary*)extra;
+ (void)postKeyValueStorageChange:(NSString *)val forKey:(NSString*)key;

@end
