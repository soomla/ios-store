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
 ABSTRACT.
 This is the parent class of all entities in the application.
 Almost every entity in your virtual economy will be an entity. There
 are many types of entities - each one of the various types extends
 `SoomlaEntity` and adds its own behavior on top of it.
 */
@interface SoomlaEntity : NSObject {
    NSString* name;
    NSString* description;
    NSString* ID;
}

@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSString* description;
@property (retain, nonatomic, readonly) NSString* ID;

- (id)init;

/**
 Constructor.
 
 @param oName The name of the entity.
 @param oDescription The description of the entity.
 @param oID The id of the entity. 
 */
- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription andID:(NSString*)oID;

/** 
 Constructor.
 Generates an instance of `SoomlaEntity` from an `NSDictionary`.
 
 @param dict An `NSDictionary` representation of the wanted `SoomlaEntity`.
 */
- (id)initWithDictionary:(NSDictionary*)dict;

/**
 Converts the current `SoomlaEntity` to an `NSDictionary`.
 
 @return This instance of SoomlaEntityas an `NSDictionary`.
 */
- (NSDictionary*)toDictionary;

/**
 Tests equality between two `SoomlaEntity`s
 
 @return `YES` if they are equal, false otherwise
 */
- (BOOL)isEqualToSoomlaEntity:(SoomlaEntity*)soomlaEntity;

- (id)clone:(NSString*)newId;
@end
