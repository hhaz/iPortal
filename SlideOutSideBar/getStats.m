//
//  getStats.m
//  SlideOutSideBar
//
//  Created by Hervé AZOULAY on 10/09/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import "getStats.h"

@implementation getStats

- (void)getData:(UITableView *)myTable {
    
    
    NSString *restCallString = [NSString stringWithFormat:@"%@/api/getTrx?montantMin=%@&montantMax=%@",_appDelegate.trxServerURL,_minAmount, _maxAmount];
    
    
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
                            _numberOfTrx = dataJSON[@"totalRows"];
                            _dataTrx = dataJSON[@"trx"];
                        }
                        [myTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                    }
                }
            }] resume];
}




@end
