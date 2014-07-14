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

#import "VirtualCurrencyPacksViewController.h"
#import "MuffinRushAssets.h"
#import "StoreInfo.h"
#import "StoreEventHandling.h"
#import "StoreInventory.h"
#import "VirtualCurrencyPack.h"
#import "MarketItem.h"
#import "VirtualItemNotFoundException.h"
#import "VirtualCurrencyPackCell.h"
#import "PurchaseWithMarket.h"

@interface VirtualCurrencyPacksViewController () {
    NSDictionary* images;
}

@end

@implementation VirtualCurrencyPacksViewController

@synthesize currencyBalance, table;

- (void)viewDidLoad
{
    images = [NSDictionary dictionaryWithObjectsAndKeys:
	      @"muffins01.png", _10_MUFFINS_PRODUCT_ID,
	      @"muffins02.png", _50_MUFFINS_PRODUCT_ID,
	      @"muffins03.png", _400_MUFFINS_PRODUCT_ID,
	      @"muffins04.png", _1000_MUFFINS_PRODUCT_ID,
	      nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(curBalanceChanged:) name:EVENT_CURRENCY_BALANCE_CHANGED object:nil];
    
    int balance = [StoreInventory getItemBalance:MUFFINS_CURRENCY_ITEM_ID];
    currencyBalance.text = [NSString stringWithFormat:@"%d", balance];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)back:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)curBalanceChanged:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    currencyBalance.text = [NSString stringWithFormat:@"%d", [(NSNumber*)[userInfo objectForKey:@"balance"] intValue]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    VirtualCurrencyPack* pack = [[[StoreInfo getInstance] virtualCurrencyPacks] objectAtIndex:indexPath.row];
    
    [pack buyWithPayload:@"this is a payload"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[StoreInfo getInstance] virtualCurrencyPacks] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    VirtualCurrencyPackCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[VirtualCurrencyPackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    VirtualCurrencyPack* pack = [[[StoreInfo getInstance] virtualCurrencyPacks] objectAtIndex:indexPath.row];
    cell.title.text = pack.name;
    cell.description.text = pack.description;
    cell.price.text = [NSString stringWithFormat:@"%.02f", ((PurchaseWithMarket*)pack.purchaseType).marketItem.price];
    cell.icon.image = [UIImage imageNamed:[images objectForKey:((PurchaseWithMarket*)pack.purchaseType).marketItem.productId]];
    
    return cell;
}

@end
