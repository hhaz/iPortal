//
//  FiltersTableViewController.h
//  SlideOutSideBar
//
//  Created by Hervé AZOULAY on 04/09/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FiltersTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endDate;
@property (weak, nonatomic) IBOutlet UITextField *minAmount;
@property (weak, nonatomic) IBOutlet UITextField *maxAmount;

@property (nonatomic, retain) AppDelegate *appDelegate;

@end
