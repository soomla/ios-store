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

@class Reward;
@class SequenceReward;

@interface RewardStorage : NSObject

+ (void)setStatus:(BOOL)status forReward:(Reward *)reward;

+ (void)setStatus:(BOOL)status forReward:(Reward *)reward andNotify:(BOOL)notify;

+ (BOOL)isRewardGiven:(Reward *)reward;

+ (int)getLastSeqIdxGivenForReward:(SequenceReward *)sequenceReward;

+ (void)setLastSeqIdxGiven:(int)idx ForReward:(SequenceReward *)sequenceReward;

+ (int)getTimesGivenForReward:(Reward*)reward;

+ (void)setTimesGivenForReward:(Reward*)reward up:(BOOL)up andNotify:(BOOL)notify;

+ (NSDate*)getLastGivenTimeForReward:(Reward*)reward;

+ (long long)getLastGivenTimeMillisForReward:(Reward*)reward;

@end
