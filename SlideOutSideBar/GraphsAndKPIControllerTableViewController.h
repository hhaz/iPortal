//
//  GraphsAndKPIControllerTableViewController.h
//  iPortal
//
//  Created by Hervé AZOULAY on 15/09/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface GraphsAndKPIControllerTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@property (nonatomic, retain) AppDelegate *appDelegate;

@end
