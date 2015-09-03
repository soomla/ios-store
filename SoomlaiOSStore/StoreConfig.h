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

/**
 This file holds the store's configurations.
 */

/**
 This value defines the version of the metadata located in your database.
 
 @warning NEVER CHANGE THE VALUE FOR THIS VARIABLE !!!
 */
extern const int METADATA_VERSION;

/**
 When set to 'YES', this will verify purchases on the SOOMLA server
 */
extern BOOL VERIFY_PURCHASES;

/**
 When set to 'YES', this will tell the verification process to mark a purchase 
 as successful in cases where itunes servers are down or unresponsive.
 
 @warning SOOMLA recommends that you leave this value set to 'NO'. Itunes 
            services are usually UP. If you're still testing (Sandbox) then 
            you might want to turn this on to get your purchases running.
 */
extern BOOL VERIFY_ON_ITUNES_FAILURE;

extern NSString* VERIFY_URL;
