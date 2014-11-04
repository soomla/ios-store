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

#import <Foundation/Foundation.h>

#define LogDebug(x,y) [SoomlaUtils LogDebug:x withMessage:y];
#define LogError(x,y) [SoomlaUtils LogError:x withMessage:y];

/**
 This class handles printing of error and debug messages.
 */
@interface SoomlaUtils : NSObject

/**
 * Creates Log Debug message according to the given tag and message.
 *
 * @param tag The name of the class whose instance called this function.
 * @param msg The debug message to output to log.
 */
+ (void)LogDebug:(NSString*)tag withMessage:(NSString*)msg;

/**
 * Creates Log Error message according to the given tag and message.
 *
 * @param tag The name of the class whose instance called this function.
 * @param msg The error message to output to log.
 */
+ (void)LogError:(NSString*)tag withMessage:(NSString*)msg;

/**
 * Retrieves the device Id.
 *
 * @return The id of the device being used.
 */
+ (NSString*)deviceId;


+ (NSMutableDictionary*)jsonStringToDict:(NSString*)str;

+ (NSMutableArray*)jsonStringToArray:(NSString*)str;

+ (NSString*)dictToJsonString:(NSDictionary*)str;

+ (NSString*)arrayToJsonString:(NSArray*)arr;

+ (NSString *) applicationDirectory;

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

+ (void)setLoggingEnabled:(BOOL)logEnabled;

+ (NSString *)getClassName:(id)target;

@end

