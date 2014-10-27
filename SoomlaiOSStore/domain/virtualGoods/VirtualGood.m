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

#import "VirtualGood.h"
#import "StorageManager.h"
#import "VirtualGoodStorage.h"

@implementation VirtualGood

- (id)initWithName:(NSString*)oName andDescription:(NSString*)oDescription
         andItemId:(NSString*)oItemId andPurchaseType:(PurchaseType*)oPurchaseType{

    if (self = [super initWithName:oName andDescription:oDescription andItemId:oItemId andPurchaseType:oPurchaseType]){
    }
    
    return self;
}

/**
 see parent 
 
 @param dict see parent.
 @return see parent.
 */
- (id)initWithDictionary:(NSDictionary*)dict{
    if (self = [super initWithDictionary:dict]) {
    }
    
    return self;
}

/**
 see parent
 
 @return see parent.
 */
- (NSDictionary*)toDictionary{
    return [super toDictionary];
}

/**
 see parent
 
 @param balance see parent.
 @return see parent.
 */
- (int)resetBalance:(int)balance withEvent:(BOOL)notify {
    return [[StorageManager getInstance].virtualGoodStorage setBalance:balance toItem:self.itemId withEvent:notify];
}

@end
