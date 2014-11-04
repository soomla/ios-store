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

/**
 This class provides basic storage operations for a simple key-value store.
 */
@interface KeyValueStorage : NSObject {

}

/**
 Retrieves the value for the given `key`.
 
 @param key The key in the key-val pair.
 @return The value for given key.
 */
+ (NSString*)getValueForKey:(NSString*)key;

/**
 Sets the given value to the given `key`.
 
 @param val The val in the key-val pair.
 @param key The key in the key-val pair.
 */
+ (void)setValue:(NSString*)val forKey:(NSString*)key;

/**
 Deletes the key-val pair with the given `key`.
 
 @param key The key in the key-val pair.
 */
+ (void)deleteValueForKey:(NSString*)key;

/**
 Retrieves the key-val pairs that answer the given `query`.
 
 @param query What to fetch from the DB.
 @return The key-val pairs that answer the given `query`.
 */
+ (NSDictionary*)getKeysValuesForNonEncryptedQuery:(NSString*)query;

/**
 Retrieves the values of the key-val pairs that answer the given `query`.
 
 @param query What to fetch from the DB.
 @return The values that answer the given `query`.
 */
+ (NSArray*)getValuesForNonEncryptedQuery:(NSString*)query;

/**
 Retrieves the value for the given `key`.
 
 @param key The key in the key-val pair.
 @return The value for given `key`.
 */
+ (NSString*)getValueForNonEncryptedKey:(NSString*)key;

/**
 Sets the given value to the given `key`.
 
 @param val The `val` of the key-val pair.
 @param key The `key` of the key-val pair.
 */
+ (void)setValue:(NSString*)val forNonEncryptedKey:(NSString*)key;

/**
 Deletes the key-val pair with the given `key`.
 
 @param key The key in the key-val pair.
 */
+ (void)deleteValueForNonEncryptedKey:(NSString*)key;

/**
 Purges the entire DB
 
 NOTE: Use with caution, since this will delete all the user's local information
 This message is used mainly for while in testing.
 */
+ (void)purge;

@end
