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

#import "StorageManager.h"
#import "VirtualCurrencyStorage.h"
#import "VirtualGoodStorage.h"
#import "VirtualItemStorage.h"
#import "VirtualItem.h"
#import "VirtualGood.h"
#import "VirtualCurrency.h"


@implementation StorageManager

@synthesize virtualCurrencyStorage, virtualGoodStorage;

static NSString* TAG = @"SOOMLA StorageManager";

+ (StorageManager*)getInstance{
    static StorageManager* _instance = nil;
    
    @synchronized( self ) {
        if( _instance == nil ) {
            _instance = [[StorageManager alloc ] init];
        }
    }
    
    return _instance;
}

- (id)init{
    self = [super init];
    if (self){
        self.virtualCurrencyStorage = [[VirtualCurrencyStorage alloc] init];
        self.virtualGoodStorage = [[VirtualGoodStorage alloc] init];
    }
    
    return self;
}

- (VirtualItemStorage*)virtualItemStorage:(VirtualItem*)item {
    VirtualItemStorage* storage = nil;
    
    if ([item isKindOfClass:[VirtualGood class]]) {
        storage = self.virtualGoodStorage;
    }else if ([item isKindOfClass:[VirtualCurrency class]]) {
        storage = self.virtualCurrencyStorage;
    }
    
    return storage;
}

@end
