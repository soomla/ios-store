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


@implementation SoomlaVerification

static NSString* TAG = @"SOOMLA SoomlaVerification";

- (id) initWithTransaction:(SKPaymentTransaction*)t andPurchasable:(PurchasableVirtualItem*)pvi {
    if (self = [super init]) {
        transaction = t;
        purchasable = pvi;
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
        
        NSDictionary* postDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [data base64Encoding], @"receipt_base64",
                                  nil];

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
    if (![dataStr isEqualToString:@""]) {
        @try {
            NSDictionary* responseDict = [SoomlaUtils jsonStringToDict:dataStr];
            verifiedNum = (NSNumber*)[responseDict objectForKey:@"verified"];
        } @catch (NSException* e) {
            LogError(TAG, @"There was a problem when verifying when handling response.");
        }
    }

    BOOL verified = NO;
    if (responseCode==200 && verifiedNum) {
        verified = [verifiedNum boolValue];
        [StoreEventHandling postMarketPurchaseVerification:verified forItem:purchasable andTransaction:transaction forObject:self];
    } else {
        LogError(TAG, @"There was a problem when verifying. Will try again later.");
        [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_TIMEOUT forObject:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    LogError(TAG, @"Failed to connect to verification server. Not doing anything ... the purchasing process will happen again next time the service is initialized.");
    LogDebug(TAG, [error description]);
    [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_TIMEOUT forObject:self];
}

// - (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
//     return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
// }
// 
// - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//     if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//             [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//     
//     [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
// }

@end
