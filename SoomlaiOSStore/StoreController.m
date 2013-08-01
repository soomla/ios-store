/*
 * Copyright (C) 2012 Soomla Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "StoreController.h"
#import "StoreConfig.h"
#import "StorageManager.h"
#import "StoreInfo.h"
#import "EventHandling.h"
#import "VirtualGood.h"
#import "VirtualCategory.h"
#import "VirtualCurrency.h"
#import "VirtualCurrencyPack.h"
#import "VirtualCurrencyStorage.h"
#import "NonConsumableStorage.h"
#import "VirtualGoodStorage.h"
#import "InsufficientFundsException.h"
#import "NotEnoughGoodsException.h"
#import "VirtualItemNotFoundException.h"
#import "ObscuredNSUserDefaults.h"
#import "AppStoreItem.h"
#import "NonConsumableItem.h"
#import "StoreUtils.h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

@implementation StoreController

@synthesize initialized, storeOpen;

static NSString* TAG = @"SOOMLA StoreController";

- (BOOL)checkInit {
    if (!self.initialized) {
        LogDebug(TAG, @"You can't perform any of StoreController's actions before it was initialized. Initialize it once when your game loads.");
        return NO;
    }
    
    return YES;
}

+ (StoreController*)getInstance{
    static StoreController* _instance = nil;
    
    @synchronized( self ) {
        if( _instance == nil ) {
            _instance = [[StoreController alloc ] init];
        }
    }
    
    return _instance;
}

- (void)initializeWithStoreAssets:(id<IStoreAsssets>)storeAssets andCustomSecret:(NSString*)secret {
    
    if (secret && secret.length > 0) {
        [ObscuredNSUserDefaults setString:secret forKey:@"ISU#LL#SE#REI"];
    } else if ([[ObscuredNSUserDefaults stringForKey:@"ISU#LL#SE#REI" withDefaultValue:@""] isEqualToString:@""]){
        LogError(TAG, @"secret is null or empty. can't initialize store !!");
        return;
    }
    
    [ObscuredNSUserDefaults setInt:[storeAssets getVersion] forKey:@"SA_VER_NEW"];
    
    [StorageManager getInstance];
    [[StoreInfo getInstance] initializeWithIStoreAsssets:storeAssets];
    
    if ([SKPaymentQueue canMakePayments]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        [EventHandling postBillingSupported];
    } else {
        [EventHandling postBillingNotSupported];
    }
    
    self.initialized = YES;
    [EventHandling postStoreControllerInitialized];
}

- (BOOL)buyInAppStoreWithAppStoreItem:(AppStoreItem*)appStoreItem{
    if (![self checkInit]) return NO;
    
    if ([SKPaymentQueue canMakePayments]) {
        SKMutablePayment *payment = [[SKMutablePayment alloc] init] ;
        payment.productIdentifier = appStoreItem.productId;
        payment.quantity = 1;
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        @try {
            PurchasableVirtualItem* pvi = [[StoreInfo getInstance] purchasableItemWithProductId:appStoreItem.productId];
            [EventHandling postAppStorePurchaseStarted:pvi];
        }
        @catch (NSException *exception) {
            LogError(TAG, ([NSString stringWithFormat:@"Couldn't find a purchasable item with productId: %@", appStoreItem.productId]));
        }
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"IAP Failed!"
                                                          message:@"Can't make purchases. Parental control is probably enabled."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        LogError(TAG, @"Can't make purchases. Parental control is probably enabled.");
        return NO;
    }
    
    return YES;
}

- (void)storeOpening{
    if(![self checkInit]) return;
    
    @synchronized(self) {
        if (self.storeOpen) {
            LogError(TAG, @"You called storeOpening whern the store was already open !");
            return;
        }
        
        if(![[StoreInfo getInstance] initializeFromDB]){
            [EventHandling postUnexpectedError];
            LogError(TAG, @"An unexpected error occured while trying to initialize storeInfo from DB.");
            return;
        }
        
        [EventHandling postOpeningStore];
        
        self.storeOpen = YES;
    }
}

- (void)storeClosing{
    if (!self.storeOpen) return;
    
    self.storeOpen = NO;
    
    [EventHandling postClosingStore];
}


- (void)restoreTransactions {
    if(![self checkInit]) return;
    
    LogDebug(TAG, @"Sending restore transaction request");
    if ([SKPaymentQueue canMakePayments]) {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }
    
    [EventHandling postTransactionRestoreStarted];
}

- (BOOL)transactionsAlreadyRestored {
    return [ObscuredNSUserDefaults boolForKey:@"RESTORED" withDefaultValue:NO];
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)givePurchasedItem:(SKPaymentTransaction *)transaction
{
    @try {
        PurchasableVirtualItem* pvi = [[StoreInfo getInstance] purchasableItemWithProductId:transaction.payment.productIdentifier];
        
        [EventHandling postAppStorePurchase:pvi];
        
        [pvi giveAmount:1];
        
        [EventHandling postItemPurchased:pvi];
        
        // Remove the transaction from the payment queue.
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    } @catch (VirtualItemNotFoundException* e) {
        LogDebug(TAG, ([NSString stringWithFormat:@"ERROR : Couldn't find the PurchasableVirtualItem with productId: %@"
                        @". It's unexpected so an unexpected error is being emitted.", transaction.payment.productIdentifier]));
        [EventHandling postUnexpectedError];
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    
    LogDebug(TAG, ([NSString stringWithFormat:@"Transaction completed for product: %@", transaction.payment.productIdentifier]));
    [self givePurchasedItem:transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    LogDebug(TAG, ([NSString stringWithFormat:@"Restore transaction for product: %@", transaction.payment.productIdentifier]));
    [self givePurchasedItem:transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        LogError(TAG, ([NSString stringWithFormat:@"An error occured for product id \"%@\" with code \"%d\" and description \"%@\"", transaction.payment.productIdentifier, transaction.error.code, transaction.error.localizedDescription]));
        
        [EventHandling postUnexpectedError];
    }
    else{
        
        @try {
            PurchasableVirtualItem* pvi = [[StoreInfo getInstance] purchasableItemWithProductId:transaction.payment.productIdentifier];
            
            [EventHandling postAppStorePurchaseCancelled:pvi];
        }
        @catch (VirtualItemNotFoundException* e) {
            LogError(TAG, ([NSString stringWithFormat:@"Couldn't find the CANCELLED VirtualCurrencyPack OR AppStoreItem with productId: %@"
                            @". It's unexpected so an unexpected error is being emitted.", transaction.payment.productIdentifier]));
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"IAP Failed!"
                                                              message:@"Unexpected error happened during IAP. You will NOT be charged"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            [EventHandling postUnexpectedError];
        }
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    [ObscuredNSUserDefaults setBool:YES forKey:@"RESTORED"];
    [EventHandling postTransactionRestored:YES];
}


#pragma mark -
#pragma mark SKProductsRequestDelegate methods

// When using SOOMLA's server you don't need to get information about your products. SOOMLA will keep this information
// for you and will automatically load it into your game.
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //    NSArray *products = response.products;
    //    proUpgradeProduct = [products count] == 1 ? [products objectAtIndex:0] : nil;
    //    if (proUpgradeProduct)
    //    {
    //        NSLog(@"Product title: %@" , proUpgradeProduct.localizedTitle);
    //        NSLog(@"Product description: %@" , proUpgradeProduct.localizedDescription);
    //        NSLog(@"Product price: %@" , proUpgradeProduct.price);
    //        NSLog(@"Product id: %@" , proUpgradeProduct.productIdentifier);
    //    }
    //
    //    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    //    {
    //        NSLog(@"Invalid product id: %@" , invalidProductId);
    //    }
    //
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}


@end
