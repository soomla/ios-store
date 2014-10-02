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

#import "VirtualGoodsViewController.h"
#import "MuffinRushAssets.h"
#import "StoreInfo.h"
#import "VirtualGood.h"
#import "VirtualGoodCell.h"
#import "StoreEventHandling.h"
#import "StoreInventory.h"
#import "InsufficientFundsException.h"
#import "PurchaseWithVirtualItem.h"
#import "PurchaseWithMarket.h"
#import "MarketItem.h"

@interface VirtualGoodsViewController () {
    NSDictionary* images;
}

@end

@implementation VirtualGoodsViewController

@synthesize currencyBalance, table;

- (void)viewDidLoad
{
    images = [NSDictionary dictionaryWithObjectsAndKeys:
	      @"chocolate_cake.png", CHOCOLATE_CAKE_GOOD_ITEM_ID,
	      @"pavlova.png", PAVLOVA_GOOD_ITEM_ID,
	      @"cream_cup.png", CREAM_CUP_GOOD_ITEM_ID,
	      @"fruit_cake.png", MUFFIN_CAKE_GOOD_ITEM_ID,
	      nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodBalanceChanged:) name:EVENT_GOOD_BALANCE_CHANGED object:nil];
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

- (void)goodBalanceChanged:(NSNotification*)notification{
    [table reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    VirtualGood* good = [[[StoreInfo getInstance] virtualGoods] objectAtIndex:indexPath.row];
    
    @try {
        [good buyWithPayload:@"this is a payload"];
    }
    @catch (InsufficientFundsException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Insufficient funds"
                                                        message:@"You don't have enough muffins to purchase this item."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];

        [alert show];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[StoreInfo getInstance] virtualGoods] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    VirtualGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[VirtualGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    VirtualGood* good = [[[StoreInfo getInstance] virtualGoods] objectAtIndex:indexPath.row];
    cell.title.text = good.name;
    cell.description.text = good.description;

    if ([good.purchaseType isKindOfClass:[PurchaseWithVirtualItem class]]) {
        cell.price.text = [NSString stringWithFormat:@"%d", ((PurchaseWithVirtualItem*)good.purchaseType).amount];
    } else if ([good.purchaseType isKindOfClass:[PurchaseWithMarket class]]) {
        cell.price.text = [NSString stringWithFormat:@"$ %f", ((PurchaseWithMarket*)good.purchaseType).marketItem.price];
    }
    cell.icon.image = [UIImage imageNamed:[images objectForKey:good.itemId]];
    int balance = [StoreInventory getItemBalance:good.itemId];
    cell.balance.text = [NSString stringWithFormat:@"%d", balance];
    
    return cell;
}

@end
