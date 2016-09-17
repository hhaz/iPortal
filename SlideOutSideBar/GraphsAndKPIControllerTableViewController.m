//
//  GraphsAndKPIControllerTableViewController.m
//  iPortal
//
//  Created by Hervé AZOULAY on 15/09/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import "GraphsAndKPIControllerTableViewController.h"
#import "SWRevealViewController.h"
//#import "DayAxisValueFormatter.h"

@interface GraphsAndKPIControllerTableViewController ()
@property (nonatomic, strong) NSArray *listOfCurrency;
@property (nonatomic, strong) NSArray *listOfTrxType;
@property (nonatomic, strong) NSArray *listOfAppType;
@property (nonatomic, strong) NSNumber *numberOfTrx;
@end

@implementation GraphsAndKPIControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    [self setupPieChartView:_chartViewApp];
    [self getStats];
    
    
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

    return 3;
}

- (void)setupBarChartView:(BarChartView *)chartView {
    chartView.drawBarShadowEnabled = NO;
    chartView.drawValueAboveBarEnabled = YES;
    
    chartView.maxVisibleCount = 60;
    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.granularity = 1.0; // only intervals of 1 day
    xAxis.labelCount = 7;
    //xAxis.valueFormatter = [[DayAxisValueFormatter alloc] initForChart:chartView];
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.minimumFractionDigits = 0;
    leftAxisFormatter.maximumFractionDigits = 1;
    leftAxisFormatter.negativeSuffix = @" $";
    leftAxisFormatter.positiveSuffix = @" $";
    
    ChartYAxis *leftAxis = chartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 8;
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartYAxis *rightAxis = chartView.rightAxis;
    rightAxis.enabled = YES;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
    rightAxis.labelCount = 8;
    rightAxis.valueFormatter = leftAxis.valueFormatter;
    rightAxis.spaceTop = 0.15;
    rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    chartView.legend.position = ChartLegendPositionBelowChartLeft;
    chartView.legend.form = ChartLegendFormSquare;
    chartView.legend.formSize = 9.0;
    chartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    chartView.legend.xEntrySpace = 4.0;
    
    /*XYMarkerView *marker = [[XYMarkerView alloc]
     initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
     font: [UIFont systemFontOfSize:12.0]
     textColor: UIColor.whiteColor
     insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)
     xAxisValueFormatter: chartView.xAxis.valueFormatter];
     marker.chartView = chartView;
     marker.minimumSize = CGSizeMake(80.f, 40.f);
     chartView.marker = marker;*/
    
}


- (void)setupPieChartView:(PieChartView *)chartView
{
    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = YES;
    chartView.holeRadiusPercent = 0.58;
    chartView.transparentCircleRadiusPercent = 0.61;
    chartView.descriptionText = @"";
    [chartView setExtraOffsetsWithLeft:1.f top:1.f right:1.f bottom:1.f];
    
    chartView.drawCenterTextEnabled = YES;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"iPortal Charts & KPIs"];
    [centerText setAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:6.f],
                                NSParagraphStyleAttributeName: paragraphStyle
                                } range:NSMakeRange(0, centerText.length)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:6.f],
                                NSForegroundColorAttributeName: UIColor.grayColor
                                } range:NSMakeRange(10, centerText.length - 10)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:6.f],
                                NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]
                                } range:NSMakeRange(centerText.length - 19, 19)];
    chartView.centerAttributedText = centerText;
    
    chartView.drawHoleEnabled = YES;
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = YES;
    chartView.highlightPerTapEnabled = YES;
    
    ChartLegend *l = chartView.legend;
    l.position = ChartLegendPositionRightOfChart;
    l.orientation = ChartLegendOrientationVertical;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
}

- (void)getStats {
    [self.view endEditing:YES];
    
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
                            _numberOfTrx = dataJSON[@"response"][@"numFound"];
                            _listOfCurrency = dataJSON[@"facet_counts"][@"facet_fields"][@"Currency"];
                            _listOfTrxType = dataJSON[@"facet_counts"][@"facet_fields"][@"TrxType"];
                            _listOfAppType = dataJSON[@"facet_counts"][@"facet_fields"][@"AppType"];
                            NSLog(@"Number of docs : %@", _numberOfTrx);
                            
                            for (int i=0;i < _listOfCurrency.count;i+=2) {
                                NSLog(@"Currency : %@ : %@",_listOfCurrency[i],_listOfCurrency[i+1]);
                            }
                            
                            
                            for (int i=0;i < _listOfTrxType.count;i+=2) {
                                NSLog(@"Currency : %@ : %@",_listOfTrxType[i],_listOfTrxType[i+1]);
                            }
                            
                            
                            for (int i=0;i < _listOfAppType.count;i+=2) {
                                NSLog(@"Currency : %@ : %@",_listOfAppType[i],_listOfAppType[i+1]);
                            }
                            
                            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                            [self updateChartAppType:_chartViewApp data:_listOfAppType title:@"Applications"];
                            [_chartViewApp animateWithXAxisDuration:1.8 easingOption:ChartEasingOptionEaseOutBack];
                            
                            /*[self updateChartData:_chartViewType data:_listOfTrxType title:@"Trx Type"];
                            [_chartViewType animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
                            
                            [self updateChartData:_chartViewCurr data:_listOfCurrency title:@"Currencies"];
                            [_chartViewCurr animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];*/
                            
                        }
                    }
                }
            }] resume];
}

- (void)updateChartAppType:(PieChartView *)chartView data:(NSArray *)dataArray title:(NSString *)text
{
   if (self.shouldHideData)
    {
        chartView.data = nil;
        return;
    }
    
    chartView.centerText = text;
    
    [self setAppTypeCount:dataArray range:[_numberOfTrx integerValue] chartView:chartView];
}

- (void)setAppTypeCount:(NSArray *)dataArray range:(double)range chartView:(PieChartView *)chartView
{
    int count = (int)dataArray.count;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    int currentNumber;
    int j = 0;
    for (int i = 0; i < count; i+=2)
    {
        currentNumber = [((NSNumber*)[dataArray objectAtIndex:i+1]) intValue];
        
        [values addObject:[[PieChartDataEntry alloc] initWithValue:currentNumber label:dataArray[i]]];
        j++;
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Trx Per App"];
    dataSet.sliceSpace = 2.0;
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.f]];
    [data setValueTextColor:UIColor.blackColor];
    
    chartView.data = data;
    chartView._legend.enabled = true;
    [chartView highlightValues:nil];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
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
