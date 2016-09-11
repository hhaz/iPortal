//
//  FiltersTableViewController.m
//  SlideOutSideBar
//
//  Created by Hervé AZOULAY on 04/09/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import "FiltersTableViewController.h"
#import "SWRevealViewController.h"
#import "ManageDefaults.h"


@interface FiltersTableViewController ()

@end

@implementation FiltersTableViewController
NSArray *menuItemsFilters;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _startDate.text = _appDelegate.startDate;
    _endDate.text = _appDelegate.endDate;
    
    _minAmount.text = [_appDelegate.minAmount stringValue];
    _maxAmount.text = [_appDelegate.maxAmount stringValue];
    
    menuItemsFilters = @[@"Amounts", @"Dates"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [_minAmount addTarget:self action: @selector(amountChanged:) forControlEvents:UIControlEventEditingDidEnd];
    [_maxAmount addTarget:self action: @selector(amountChanged:) forControlEvents:UIControlEventEditingDidEnd];
    

    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [_startDate setInputView:datePicker];
    [_endDate setInputView:datePicker];
    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];

}


- (void)amountChanged:(UITextField *)amountField {
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    _appDelegate.minAmount = [f numberFromString:_minAmount.text];
    _appDelegate.maxAmount = [f numberFromString:_maxAmount.text];
    
    ManageDefaults *defaults = [[ManageDefaults alloc]init];
    
    [defaults saveDefaults];
    
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    
    if(_startDate.isFirstResponder) {
        _startDate.text = strDate;
        _appDelegate.startDate = strDate;
    }
    else {
        _endDate.text = strDate;
        _appDelegate.endDate = strDate;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItemsFilters.count;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
