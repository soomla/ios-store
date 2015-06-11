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
 When set to 'YES', this removes the need to verify purchases when there's no
 signature.
 NOTE: This is useful while you are in development and testing stages of your 
 game.

 @warning Set to 'NO' before you publish your app!!!
 */
extern BOOL VERIFY_PURCHASES;

extern NSString* VERIFY_URL;
extern NSString* SERVER_AUTHORIZATION_TOKEN;
