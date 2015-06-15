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
#import "FBEncryptorAES.h"

@interface SoomlaVerification () <NSURLConnectionDelegate, SKRequestDelegate> {
    BOOL tryAgain;
}
@end

@implementation SoomlaVerification

static NSString* TAG = @"SOOMLA SoomlaVerification";
static NSMutableArray* cacheRetryRequestReceipt;

- (id) initWithTransaction:(SKPaymentTransaction*)t andPurchasable:(PurchasableVirtualItem*)pvi {
    
    if(cacheRetryRequestReceipt == nil)
        cacheRetryRequestReceipt = [[NSMutableArray alloc] init];
    
    if (self = [super init]) {
        transaction = t;
        purchasable = pvi;
        tryAgain = YES;
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
        
        if( SERVER_AUTHORIZATION_TOKEN && ![SERVER_AUTHORIZATION_TOKEN isEqualToString:@""]  ) {
            [request setValue:SERVER_AUTHORIZATION_TOKEN forHTTPHeaderField:@"Authorization"];
        }
        
        [request setHTTPBody:postData];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn start];
    } else {
        LogError(TAG, ([NSString stringWithFormat:@"An error occured while trying to get receipt data. Stopping the purchasing process for: %@", transaction.payment.productIdentifier]));
        [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_TIMEOUT forObject:self];
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString* dataStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSNumber* verifiedNum = nil;
    NSNumber* successNum = nil;
    
    if ([dataStr isEqualToString:@""]) {
        LogError(TAG, @"There was a problem when verifying. Got an empty response. Will try again later.");
        [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_FAIL forObject:self];
        return;
    }

    NSDictionary* responseDict = NULL;
    @try {
        responseDict = [SoomlaUtils jsonStringToDict:dataStr];
        verifiedNum = (NSNumber*)[responseDict objectForKey:@"verified"];
        successNum = (NSNumber*)[responseDict objectForKey:@"success"];
    } @catch (NSException* e) {
        LogError(TAG, @"There was a problem when verifying when handling response.");
    }
    
    BOOL verified = NO;
    if (responseCode==200 && successNum && [successNum boolValue] && verifiedNum) {
        
        verified = [verifiedNum boolValue];
        if (!verified) {
            NSNumber* emptyResponse = (NSNumber*)[responseDict objectForKey:@"emptyResponse"];
            BOOL needRefresh = [emptyResponse boolValue];
            if (needRefresh && tryAgain) {
                LogDebug(TAG, @"Receipt refresh needed.");
                tryAgain = NO;
                SKReceiptRefreshRequest *req = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:nil];
                req.delegate = self;
                [cacheRetryRequestReceipt addObject:self];
                [req start];

                // we return here ...
                return;
            }
        }
        [StoreEventHandling postMarketPurchaseVerification:verified forItem:purchasable andTransaction:transaction forObject:self];
    } else {
        NSString* errorMsg = @"";
        if (responseDict) {
            @try {
                id errorObject = [responseDict objectForKey:@"error"];
                if([errorObject isKindOfClass:[NSDictionary class]]) {
                    errorMsg = [errorObject objectForKey:@"message"];
                }
                else if([errorObject isKindOfClass:[NSString class]]){
                    errorMsg = (NSString *) errorObject;
                }
                else {
                    errorMsg = @"Unknown Error";
                }

            } @catch (NSException* e) {
                LogError(TAG, @"There was a problem when verifying when handling response.");
            }
        }
        
        if ([errorMsg isEqualToString:@"ECONNRESET"]) {
            LogError(TAG, @"It appears that the iTunes servers are down. We can't verify this receipt.");
        }
        
        LogError(TAG, ([NSString stringWithFormat:@"There was a problem when verifying (%@). Will try again later.", errorMsg]));
        [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_TIMEOUT forObject:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    LogError(TAG, @"Failed to connect to verification server. Not doing anything ... the purchasing process will happen again next time the service is initialized.");
    LogDebug(TAG, [error description]);
    [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_TIMEOUT forObject:self];
}

#pragma mark SKRequestDelegate methods

- (void)requestDidFinish:(SKRequest *)request {
    LogDebug(TAG, @"The refresh request for a receipt completed.");
    [self verifyData];
    if([cacheRetryRequestReceipt containsObject:self])
        [cacheRetryRequestReceipt removeObject:self];

}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    LogDebug(TAG, ([NSString stringWithFormat:@"Error trying to request receipt: %@", error]));
    [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_FAIL forObject:self];
    if([cacheRetryRequestReceipt containsObject:self])
        [cacheRetryRequestReceipt removeObject:self];

}

@end
