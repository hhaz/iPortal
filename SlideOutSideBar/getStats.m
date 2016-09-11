//
//  getStats.m
//  SlideOutSideBar
//
//  Created by Hervé AZOULAY on 10/09/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import "getStats.h"

@implementation getStats

- (void)getData:(UITableView *)myTable nbTrx:(UILabel *)nbTrx amountTrx:(UILabel *)amountTrx{
    

    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *restCallString = [NSString stringWithFormat:@"%@/api/getStats?montantMin=%@&montantMax=%@",_appDelegate.trxServerURL,_appDelegate.minAmount, _appDelegate.maxAmount];
    
    
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
                            NSNumber *numberOfTrx;
                            NSNumber *sumTrx;
                            
                            numberOfTrx = dataJSON[@"response"][@"numFound"];
                            sumTrx = dataJSON[@"stats"][@"stats_fields"][@"Amount"][@"sum"];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                                NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
                                [formatter setGroupingSeparator:groupingSeparator];
                                [formatter setGroupingSize:3];
                                [formatter setAlwaysShowsDecimalSeparator:NO];
                                [formatter setUsesGroupingSeparator:YES];
                                
                                nbTrx.text =  [numberOfTrx stringValue];
                                amountTrx.text = [sumTrx stringValue];
                                
                                 nbTrx.text  = [formatter stringFromNumber:numberOfTrx];
                                 amountTrx.text = [formatter stringFromNumber:sumTrx];
                                [myTable reloadData];
                            });
                            
                        }
                    }
                }
            }] resume];
}

@end
