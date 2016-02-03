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

#import "SoomlaVerification.h"
#import "SoomlaUtils.h"
#import "PurchasableVirtualItem.h"
#import "StoreEventHandling.h"
#import "StoreConfig.h"

@interface SoomlaVerification () <NSURLConnectionDelegate, SKRequestDelegate> {
    BOOL tryAgain;
    BOOL purchaseRestored;
}
@end

@implementation SoomlaVerification

static NSString* TAG = @"SOOMLA SoomlaVerification";

- (id)initWithTransaction:(SKPaymentTransaction*)t andPurchasable:(PurchasableVirtualItem*)pvi isRestored:(BOOL)isRestored {
    if (self = [super init]) {
        transaction = t;
        purchasable = pvi;
        tryAgain = YES;
        purchaseRestored = isRestored;
    }
    
    return self;
}

- (void)verifyData {
    LogDebug(TAG, ([NSString stringWithFormat:@"verifying purchase for: %@", transaction.payment.productIdentifier]));
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];

    NSData* data = nil;
    if (version < 7) {
        data = transaction.transactionReceipt;
    } else {
        NSURL* receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[receiptUrl path]]) {
            data = [NSData dataWithContentsOfURL:receiptUrl];
        }
    }
    
    if (data) {
        
        NSMutableDictionary* postDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [data base64Encoding], @"receipt_base64",
                                  transaction.payment.productIdentifier, @"productId",
                                  nil];

        NSString* extraDataS = [[NSUserDefaults standardUserDefaults] stringForKey:@"EXTRA_SEND_RECEIPT"];
        if (extraDataS && [extraDataS length]>0) {
            NSDictionary* extraData = [SoomlaUtils jsonStringToDict:extraDataS];
            for(NSString* key in [extraData allKeys]) {
                [postDict setObject:[extraData objectForKey:key] forKey:key];
            }
        }
        

        NSData *postData = [[SoomlaUtils dictToJsonString:postDict] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        LogDebug(TAG, ([NSString stringWithFormat:@"verifying purchase on server: %@", VERIFY_URL]));
        
        [request setURL:[NSURL URLWithString:VERIFY_URL]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
    } else {
        if (tryAgain) {
            tryAgain = NO;
            LogDebug(TAG, @"Receipt not found. Refreshing...");
            [self refreshReceipt];
        } else {
            LogError(TAG, ([NSString stringWithFormat:@"An error occured while trying to get receipt data. Stopping the purchasing process for: %@", transaction.payment.productIdentifier]));
            [StoreEventHandling postMarketPurchaseVerification:NO forItem:purchasable andTransaction:transaction isRestored:purchaseRestored forObject:self];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)response;
    responseCode = (int)[httpResponse statusCode];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)refreshReceipt {
    SKReceiptRefreshRequest *req = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:nil];
    req.delegate = self;
    [req start];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString* dataStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSNumber* verifiedNum = nil;
    if ([dataStr isEqualToString:@""]) {
        LogError(TAG, @"There was a problem when verifying. Got an empty response. Will try again later.");
        [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_FAIL forObject:self];
        return;
    }

    NSDictionary* responseDict = NULL;
    @try {
        responseDict = [SoomlaUtils jsonStringToDict:dataStr];
        verifiedNum = (NSNumber*)[responseDict objectForKey:@"verified"];
    } @catch (NSException* e) {
        LogError(TAG, @"There was a problem when verifying when handling response.");
    }
    
    BOOL verified = NO;
    if (responseCode==200 && verifiedNum) {
        
        verified = [verifiedNum boolValue];
        if (!verified) {
            NSNumber* emptyResponse = (NSNumber*)[responseDict objectForKey:@"emptyResponse"];
            BOOL needRefresh = [emptyResponse boolValue];
            if (needRefresh && tryAgain) {
                LogDebug(TAG, @"Receipt refresh needed.");
                tryAgain = NO;
                [self refreshReceipt];
                
                // we return here ...
                return;
            }
        } else {
            LogDebug(TAG, @"purchase verified");
        }
        [StoreEventHandling postMarketPurchaseVerification:verified forItem:purchasable andTransaction:transaction isRestored:purchaseRestored forObject:self];
    } else {
        NSString* errorMsg = @"";
        if (responseDict) {
            @try {
                errorMsg = [responseDict objectForKey:@"error"];
            } @catch (NSException* e) {
                LogError(TAG, @"There was a problem when verifying when handling response.");
            }
        }
        
        if ([errorMsg isEqualToString:@"ECONNRESET"]) {
            LogError(TAG, @"It appears that the iTunes servers are down. We can't verify this receipt.");
            if (VERIFY_ON_ITUNES_FAILURE) {
                LogDebug(TAG, @"You decided you want to allow situations where Itunes is down for verification. finalizing the purchase now.");
                [StoreEventHandling postMarketPurchaseVerification:YES forItem:purchasable andTransaction:transaction isRestored:purchaseRestored forObject:self];
                return;
            }
        }
        
        LogError(TAG, ([NSString stringWithFormat:@"There was a problem when verifying (%@). Will try again later.", errorMsg]));
        [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_TIMEOUT forObject:self];
    }
}


#pragma mark SKRequestDelegate methods

- (void)requestDidFinish:(SKRequest *)request {
    LogDebug(TAG, @"The refresh request for a receipt completed.");
    [self verifyData];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    LogDebug(TAG, ([NSString stringWithFormat:@"Error trying to request receipt: %@", error]));
    [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_FAIL forObject:self];
}

@end
