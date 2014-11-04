//
//  TimeStrategy.h
//  SoomlaiOSCore
//
//  Created by Refael Dakar on 06/08/14.
//  Copyright (c) 2014 SOOMLA. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Recurrence) {
    EVERY_MONTH,
    EVERY_WEEK,
    EVERY_DAY,
    EVERY_HOUR,
    NONE
};

@interface DateTimeRange : NSObject {
    NSDate* start;
    NSDate* end;
}

@property (nonatomic, retain, readonly) NSDate*  start;
@property (nonatomic, retain, readonly) NSDate*  end;

- (id) initWithStartDate:(NSDate*)oStart andEndDate:(NSDate*)oEnd;

@end


@interface Schedule : NSObject {
    Recurrence  recurrence;
    NSArray*    timeRanges;
    int         activationLimit;
}

@property (nonatomic, readonly) Recurrence       recurrence;
@property (nonatomic, retain, readonly) NSArray*  timeRanges;
@property (nonatomic, readonly) int              activationLimit;


+ (Schedule*)Once;
+ (Schedule*)AnyTimeLimited:(int)oActivationLimit;
+ (Schedule*)AnyTimeUnlimited;


- (id)initWithActivationLimit:(int)oActivationLimit;
- (id)initWithStartDate:(NSDate*)oStart andEndDate:(NSDate*)oEnd andRecurrence:(Recurrence)oRecurrence andActivationLimit:(int)oActivationLimit;
- (id)initWithTimeRanges:(NSArray*)oTimeRanges andRecurrence:(Recurrence)oRecurrence andActivationLimit:(int)oActivationLimit;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;
- (BOOL)approveWithActivationTimes:(int)activationTimes;

@end


