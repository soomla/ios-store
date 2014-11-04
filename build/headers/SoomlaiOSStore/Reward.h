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

#import "SoomlaEntity.h"

@class Schedule;

// TODOL document abstract class
@interface Reward : SoomlaEntity {
    Schedule* schedule;
}

@property (nonatomic, retain) Schedule* schedule;


- (id)initWithRewardId:(NSString *)oRewardId andName:(NSString *)oName;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary *)toDictionary;

- (BOOL)give;

- (BOOL)take;

- (BOOL)canGive;

- (BOOL)isOwned;

// Abstract methods

- (BOOL)giveInner;

- (BOOL)takeInner;

// Static methods

+ (Reward *)fromDictionary:(NSDictionary *)dict;

@end
