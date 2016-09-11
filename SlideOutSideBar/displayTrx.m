//
//  displayTrx.m
//  i-Portal
//
//  Created by Hervé AZOULAY on 30/05/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import "displayTrx.h"

@interface displayTrx ()

@end

@implementation displayTrx

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self getTrx:@"*"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getNext {
    [self getTrx:_nextCursorMark];
}

- (void) getPrevious {
    [self getTrx:_previousCursorMark];
}

- (void)getTrx:(NSString *)cursorMark {
    [self.view endEditing:YES];
    
    //il faut refaire sans cursorMark et avec pagination. cursorMark ne permet pas de revenir en arière

    cursorMark = [cursorMark stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSString *restCallString = [NSString stringWithFormat:@"%@/api/getTrx?cursorMark=%@&montantMin=%@&montantMax=%@",_appDelegate.trxServerURL,cursorMark,_minAmount, _maxAmount];

    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:restCallString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                if (error) {
                    NSLog(@"%@",error.description);
                }
                else {
                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                    if (httpResp.statusCode == 200) {
                        NSError *jsonError;
                        NSDictionary *dataJSON =
                        [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&jsonError];
                        
                        if (!jsonError) {
                            _nextCursorMark = dataJSON[@"nextCursorMark"];
                            _previousCursorMark = cursorMark;
                            _numberOfTrx = dataJSON[@"totalRows"];
                            _dataTrx = dataJSON[@"trx"];
                        }
                        if( ! [_previousCursorMark isEqualToString:_nextCursorMark] ) {
                            [myTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                        }
                    }
                }
            }] resume];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataTrx.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TrxCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row = [indexPath row];
    
    UILabel *dateTicket = (UILabel *)[cell viewWithTag:100];
    dateTicket.text = _dataTrx[row][@"DateTicket"];
    
    UILabel *amount = (UILabel *)[cell viewWithTag:101];
    //amount.text = _dataTrx[row][@"Amount"];
    amount.text = [NSString stringWithFormat:@"%@", _dataTrx[row][@"Amount"]];
    
    UILabel *application = (UILabel *)[cell viewWithTag:102];
    application.text = _dataTrx[row][@"AppType"];
    
    UILabel *currency = (UILabel *)[cell viewWithTag:103];
    currency.text = _dataTrx[row][@"Currency"];

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

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
