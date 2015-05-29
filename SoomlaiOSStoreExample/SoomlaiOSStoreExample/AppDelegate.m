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

#import "AppDelegate.h"
#import "SoomlaStore.h"
#import "Soomla.h"
#import "MuffinRushAssets.h"
#import "StoreInventory.h"
#import "VirtualCurrency.h"
#import "SoomlaConfig.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSNumber* n = [NSNumber numberWithInt:0];
    if (n) {
        NSLog(@"It's true");
    }
    
    DEBUG_LOG = YES;
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    /**
     We initialize SoomlaStore when the application loads !
     */
    id<IStoreAssets> storeAssets = [[MuffinRushAssets alloc] init];
    [Soomla initializeWithSecret:@"ChangeMe!!"];
    [[SoomlaStore getInstance] initializeWithStoreAssets:storeAssets];
    
    // Checking if it's a first run and adding 10000 currencies if it is.
    // OFCOURSE... THIS IS JUST FOR TESTING.
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"NotFirstLaunch"])
    {
        [defaults setBool:YES forKey:@"NotFirstLaunch"];
        [(VirtualCurrency*)[storeAssets.virtualCurrencies objectAtIndex:0] giveAmount:10000];
    }

    return YES;
}

/**
 Sent when the application is about to move from active to inactive state.
 This can occur for certain types of temporary interruptions (such as an
 incoming phone call or SMS message) or when the user quits the application and 
 it begins the transition to the background state. Use this method to pause 
 ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
 Games should use this method to pause the game.
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
}

/**
 Use this method to release shared resources, save user data, invalidate timers, 
 and store enough application state information to restore your application to 
 its current state in case it is terminated later. If your application supports 
 background execution, this method is called instead of 
 `applicationWillTerminate` when the user quits.
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

/**
 Called as part of the transition from the background to the inactive state;
 here you can undo many of the changes made on entering the background.
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

/**
 Restarts any tasks that were paused (or not yet started) while the application 
 was inactive. If the application was previously in the background, optionally 
 refresh the user interface.
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

/**
 Called when the application is about to terminate. Save data if appropriate.
 
 @see `applicationDidEnterBackground`.
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
