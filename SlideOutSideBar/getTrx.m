//
//  getTrx.m
//  Trx
//
//  Created by Hervé AZOULAY on 17/03/2016.
//  Copyright © 2016 Hervé AZOULAY. All rights reserved.
//

#import "getTrx.h"
#import "displayTrx.h"

@interface getTrx () <ChartViewDelegate>
@property (nonatomic, strong) NSArray *listOfCurrency;
@property (nonatomic, strong) NSArray *listOfTrxType;
@property (nonatomic, strong) NSArray *listOfAppType;
@property (nonatomic, strong) NSNumber *numberOfTrx;
@end

@implementation getTrx

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupPieChartView:_chartViewApp];
    [self setupPieChartView:_chartViewType];
    [self setupPieChartView:_chartViewCurr];
    
    _chartViewApp.delegate = self;
    _chartViewType.delegate = self;
    _chartViewCurr.delegate = self;
    
    _numberOfTrx = 0;
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"iOS Charts\nby Daniel Cohen Gindi"];
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
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
}

- (void)getStats {
    [self.view endEditing:YES];
    
    NSString *restCallString = [NSString stringWithFormat:@"%@/api/getStats?montantMin=%@&montantMax=%@",_appDelegate.trxServerURL,_minAmount.text, _maxAmount.text];
    
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
                            
                            [myTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                            [self updateChartData:_chartViewApp data:_listOfAppType title:@"Applications"];
                            [_chartViewApp animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
                            
                            [self updateChartData:_chartViewType data:_listOfTrxType title:@"Trx Type"];
                            [_chartViewType animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];

                            [self updateChartData:_chartViewCurr data:_listOfCurrency title:@"Currencies"];
                            [_chartViewCurr animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];

                        }
                    }
                }
            }] resume];
}

- (void)updateChartData:(PieChartView *)chartView data:(NSArray *)dataArray title:(NSString *)text
{
    if (self.shouldHideData)
    {
        chartView.data = nil;
        return;
    }
    
    chartView.centerText = text;
    
    [self setDataCount:dataArray range:[_numberOfTrx integerValue] chartView:chartView];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"segueShowTrx"])
    {
        // Get reference to the destination view controller
        displayTrx *vc = [segue destinationViewController];
        
        vc.minAmount=_minAmount.text;
        vc.maxAmount=_maxAmount.text;
    }
}


- (void)setDataCount:(NSArray *)dataArray range:(double)range chartView:(PieChartView *)chartView
{
    int count = (int)dataArray.count;
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    int currentNumber;
    int j = 0;
    for (int i = 0; i < count; i+=2)
    {
        currentNumber = [((NSNumber*)[dataArray objectAtIndex:i+1]) intValue];
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:currentNumber xIndex:j]];
        j++;
    }
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i+=2)
    {
        [xVals addObject:dataArray[i]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@"Trx Per App"];
    dataSet.sliceSpace = 1.0;
    
    // add a lot of colors
    
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:pFormatter];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.f]];
    [data setValueTextColor:UIColor.blackColor];
    
    chartView.data = data;
    chartView._legend.enabled = false;
    [chartView highlightValues:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Filter Criteria";
            break;
        case 1 :
            if(_numberOfTrx != NULL) {
                sectionName = [NSString stringWithFormat:@"Stats - %@ Transactions", _numberOfTrx];
            }
            else {
                sectionName = @"Stats";
            }
            
            break;

    }
    return sectionName;
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

@end
