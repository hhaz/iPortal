//
//  displayTrx.h
//  i-Portal
//
//  Created by Hervé AZOULAY on 30/05/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface displayTrx : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView *myTable;
    
}

@property (nonatomic, retain) NSString *minAmount;
@property (nonatomic, retain) NSString *maxAmount;
@property (nonatomic, retain) NSString *nextCursorMark;
@property (nonatomic, retain) NSString *previousCursorMark;
@property (nonatomic, strong) NSNumber *numberOfTrx;
@property (nonatomic, strong) NSArray *dataTrx;
@property (nonatomic, retain) AppDelegate *appDelegate;

-(IBAction)getNext;
-(IBAction)getPrevious;

@end
