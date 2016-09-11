//
//  getStats.h
//  SlideOutSideBar
//
//  Created by Hervé AZOULAY on 10/09/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface getStats : NSObject

@property (nonatomic, retain) NSString *minAmount;
@property (nonatomic, retain) NSString *maxAmount;
@property (nonatomic, retain) AppDelegate *appDelegate;

- (void)getData:(UITableView *)myTable nbTrx:(UILabel *)minAmount amountTrx:(UILabel *)maxAmount;

@end
