//
//  HomePageTableViewController.h
//  SlideOutSideBar
//
//  Created by Hervé AZOULAY on 04/09/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HomePageTableViewController : UITableViewController {
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UILabel *labelNbTrx;
@property (weak, nonatomic) IBOutlet UILabel *labelAmountTrx;

@property (nonatomic, retain) AppDelegate *appDelegate;

@end
