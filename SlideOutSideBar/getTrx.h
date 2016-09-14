//
//  getTrx.h
//  Trx
//
//  Created by Hervé AZOULAY on 17/03/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Charts/Charts-Swift.h"
//#import "DemoBaseViewController.h"

@interface getTrx : UITableViewController <NSURLSessionDelegate,UITableViewDelegate>
{
    NSURLConnection *currentConnection;
    IBOutlet UITableView *myTable;
}

@property (weak, nonatomic) IBOutlet UIButton *go;
@property (weak, nonatomic) IBOutlet UITextField *minAmount;
@property (weak, nonatomic) IBOutlet UITextField *maxAmount;
@property (nonatomic, strong) IBOutlet PieChartView *chartViewApp;
@property (nonatomic, strong) IBOutlet PieChartView *chartViewType;
@property (nonatomic, strong) IBOutlet PieChartView *chartViewCurr;
@property (strong, nonatomic) UIAlertController *alert;

@property (nonatomic, assign) BOOL shouldHideData;

@property (nonatomic, retain) AppDelegate *appDelegate;

-(IBAction)getStats;

@end
