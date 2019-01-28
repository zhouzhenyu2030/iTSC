//
//  HisAssetChartViewController.m
//  iTSC
//
//  Created by tss on 2019/1/28.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HisAssetChartViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"
#import "TscConnections.h"


@implementation HisAssetChartViewController

@synthesize DatePicker;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    _UserDefaults = [NSUserDefaults standardUserDefaults];
    strDate=[_UserDefaults stringForKey:@"HisAssetStartDate"];
    NSDate* _date=[dateFormatter dateFromString:strDate];
    if(_date!=nil)
        [DatePicker setDate:_date animated:YES];
    [DatePicker setMaximumDate:[NSDate date]];
    
    ScreenWidth=self.view.frame.size.width;
    ScreenHeight==self.view.frame.size.height;
    [self initLineChartView];
    xValueArr =  [[NSMutableArray alloc]init];
    yValueArr=  [[NSMutableArray alloc]init];
    

    //[self QueryAndDisplay];    
    //[self setupRefresh];
}

- (IBAction)ButtonClick:(id)sender
{
    strDate = [dateFormatter stringFromDate:DatePicker.date];
    [_UserDefaults setObject:strDate forKey:(@"HisAssetStartDate")];
    [self QueryAndDisplay];
}

// 设置下拉刷新
- (void)setupRefresh
{
    return;
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
    [self.view addSubview:refreshControl];
}
// 下拉刷新触发
- (void)refreshClick:(UIRefreshControl *)refreshControl
{
    [self QueryAndDisplay];
    //[self.TableView reloadData];
    [refreshControl endRefreshing];
}

-(void)QueryAndDisplay
{
    [_linechartView clear];
    
    [xValueArr removeAllObjects];
    [yValueArr removeAllObjects];
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"AssetViewController: Init: queryContext==nil!");
        return;
    }
    //SELECT
    NSString* _condstr = [TscConnections getCurrentConnection].AccountID;
    //_condstr = [_condstr stringByAppendingString:@" order by HisDate ASC"];
    //_condstr = [_condstr stringByAppendingString:@" and HisDate>'2019-01-10'"];
    _condstr = [_condstr stringByAppendingFormat:@" and HisDate>'%@'", strDate];
    NSLog(@"AssetViewController: Query: %@", _condstr);
    
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"hisasset" condition:_condstr];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    
    NSUInteger count = tasks.count;
    if(count<=0)
        return;
    
    //显示
    NSDictionary  *_field=[tasks objectAtIndex:count-1];
    
    for( int i=0; i<count; i++)
    {
        _field=[tasks objectAtIndex:i];
        NSLog(@"%@", _field);
        
        [xValueArr addObject:[_field[@"HisDate"] substringFromIndex:5]];
        float _value=[_field[@"Asset"] doubleValue];
        _value=_value/100/100;
        [yValueArr addObject:[NSString stringWithFormat:(@"%.2f"), _value]];
        //[yValueArr addObject:_field[@"Asset"]];
    }
    /*
     [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"HisDate:" DetialText:];
     [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordTime:" DetialText:[_field[@"RecordTime"] substringToIndex:8]];
     _sValue = [NSString stringWithFormat:@"%d", [_field[@"AccountID"] intValue]];
     [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"AccountID:" DetialText:_sValue];
     
     
     [UIHelper DisplayCell:TableView Field:_field TitleName:@"Asset (Theory):" FieldName:@"AssetTheo" SetColor:false];
     [UIHelper DisplayCell:TableView Field:_field TitleName:@"Asset (Market):" FieldName:@"Asset" SetColor:false];
     [UIHelper DisplayCell:TableView Field:_field TitleName:@"Total Cash:" FieldName:@"TotalCash" SetColor:false];
     [UIHelper DisplayCell:TableView Field:_field TitleName:@"Curr Margin:" FieldName:@"CurrMargin" SetColor:false];
     */
    
    
    [self initLineChartDataWithXvalueArr:xValueArr YvalueArr:yValueArr];
}




- (void)initLineChartView
{
    _linechartView = [[LineChartView alloc]init];
    _linechartView.frame = CGRectMake(10, 60, ScreenWidth - 20, 460);
    _linechartView.legend.form = ChartLegendFormNone; //说明图标
    _linechartView.dragEnabled = NO;//拖动手势
    _linechartView.pinchZoomEnabled = NO;//捏合手势
    _linechartView.rightAxis.enabled = NO;//隐藏右Y轴
    _linechartView.chartDescription.enabled = NO;//不显示描述label
    _linechartView.doubleTapToZoomEnabled = NO; //禁止双击缩放 _linechartView.drawGridBackgroundEnabled = NO;
    _linechartView.drawBordersEnabled = NO;
    _linechartView.dragEnabled = YES;///拖动气泡
    [_linechartView animateWithXAxisDuration:2.20 easingOption:ChartEasingOptionEaseOutBack];//加载动画时长
    [self.view addSubview:_linechartView];
}



- (void)initLineChartViewWithLeftaxisMaxValue:(double)vmaxValue MinValue:(double)vminValue
{
    //气泡
    /*
    BalloonMarker* marker = [[BalloonMarker alloc]initWithColor:[UIColororangeColor]font: [UIFontsystemFontOfSize:10]textColor:UIColor.whiteColorinsets:UIEdgeInsetsMake(9.0,8.0,20.0,8.0)];
    marker.bubbleImg = [UIImageimageNamed:@"chartqipaoBubble"];
    marker.chartView = _linechartView;
    marker.minimumSize = CGSizeMake(50.f,25.f);
    _linechartView.marker = marker;
     */
    //设置左Y轴
    ChartYAxis* leftAxis = _linechartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.axisMaximum = vmaxValue; //设置Y轴的最大值
    leftAxis.axisMinimum = vminValue;//0.00;//设置Y轴的最小值
    leftAxis.axisLineWidth = 1;
    leftAxis.labelCount=5; //y轴展示多少个
    leftAxis.labelFont = [UIFont systemFontOfSize:12];
    leftAxis.labelTextColor = [UIColor lightGrayColor];
    leftAxis.axisLineColor = [UIColor lightGrayColor];//左Y轴线条颜色
    leftAxis.gridColor = [UIColor lightGrayColor];
    leftAxis.zeroLineColor = [UIColor lightGrayColor];//左Y轴底线条颜色
    leftAxis.drawZeroLineEnabled = YES;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    // 设置X轴
    ChartXAxis* xAxis =_linechartView.xAxis;
    xAxis.axisLineColor = [UIColor lightGrayColor];
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:12];
    xAxis.labelTextColor = [UIColor lightGrayColor];
    xAxis.axisMaximum = -0.3; // label间距
    xAxis.granularity = 1.0;
    xAxis.drawAxisLineEnabled = NO;//是否画x轴线
    xAxis.drawGridLinesEnabled = NO;//是否画网格
}


- (void)initLineChartDataWithXvalueArr:(NSArray*)xValueArr YvalueArr:(NSArray*)yValueArr
{
    
    NSArray* _xValueArr = xValueArr;// 设置x轴折线数据 （模拟数据）
    NSArray* _yValueArr = yValueArr;// 设置y轴折线数据 （模拟数据）
    double _chart_YmaxValue = [[_yValueArr valueForKeyPath:@"@max.doubleValue"] doubleValue];   //最大值
    double _chart_YminValue = [[_yValueArr valueForKeyPath:@"@min.doubleValue"] doubleValue];  //最小值
    if(_chart_YmaxValue<0.03&& (_chart_YminValue==_chart_YmaxValue))
    {
        _scale = 10;
    }
    else
        if(_chart_YminValue==_chart_YmaxValue)
        {
            _scale = 2;
        }
        else
        {
            _scale = 1;
        }
    
    [self initLineChartViewWithLeftaxisMaxValue:_chart_YmaxValue MinValue:_chart_YminValue]; //引入
     
    //chartView设置X轴数据（日期）
    if(_xValueArr.count>0) {
        _linechartView.xAxis.axisMaximum = (double)xValueArr.count-1+0.3;
        _linechartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc]initWithValues:xValueArr];
    }
   
    // 创建数据集数组
    NSMutableArray* dataSets = [[NSMutableArray alloc]init];
    LineChartDataSet*set = [self drawLineWithArr:yValueArr title:nil color:[UIColor orangeColor]];
    if(set) {
        [dataSets addObject:set];// 赋值数据集数组
        }
    LineChartData*data = [[LineChartData alloc]initWithDataSets:dataSets];
    _linechartView.data = data;
}




//
- (LineChartDataSet *)drawLineWithArr:(NSArray *)arr title:(NSString *)title color:(UIColor *)color
{
    if (arr.count == 0)
        return nil;
    
    // 处理折线数据
    NSMutableArray *statistics = [NSMutableArray array];
    double leftAxisMin = 0;
    double leftAxisMax = 0;
    
    for (int i = 0; i < arr.count; i++)
    {
        NSString *num = arr[i];
        
        double temp  = [num doubleValue];
        double value = temp;//round(temp); //[self roundFloat:temp];
        leftAxisMax  = MAX(value, leftAxisMax);
        leftAxisMin  = MIN(value, leftAxisMin);
        
        [statistics addObject:[[ChartDataEntry alloc] initWithX:i y:value]];
    }
    
    
    /*
    CGFloat topNum = leftAxisMax * (5.0/4.0);
    if (leftAxisMax == leftAxisMin)
    {
        _linechartView.leftAxis.axisMaximum = 10;
    }
    else
    {
        _linechartView.leftAxis.axisMaximum = topNum*_scale;
    }
    
    
    
    if (leftAxisMin < 0)
    {
        CGFloat minNum = leftAxisMin * (5.0/4.0);
        _linechartView.leftAxis.axisMaximum = minNum ;
    }
    
    */
    
    /// 设置Y轴数据
    //_linechartView.leftAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:statistics];//self; //需要遵IChartAxisValueFormatter协议
    
    // 设置折线数据
    LineChartDataSet *chartDataSet = nil;
    chartDataSet = [[LineChartDataSet alloc] initWithValues:statistics label:title];
    [chartDataSet setColor:color]; //折线颜色
    chartDataSet.valueFont = [UIFont systemFontOfSize:12];   //折线字体大小
    //chartDataSet.valueFormatter =  [[ChartIndexAxisValueFormatter alloc] initWithValues:statistics];//self; //需要遵循IChartValueFormatter协议
    
       chartDataSet.lineWidth = 1.0f;//折线宽度
    
     chartDataSet.valueColors = @[color]; //折线拐点处显示数据的颜色
    
       chartDataSet.drawCirclesEnabled = NO;//是否绘制拐点
    
       chartDataSet.axisDependency = AxisDependencyLeft; //轴线方向
    
     chartDataSet.highlightColor = [UIColor clearColor];//选中线条颜色
    chartDataSet.highlightLineWidth = 1.00f;
    chartDataSet.drawCircleHoleEnabled = YES;//是否绘制中间的空心
    // chartDataSet.circleHoleRadius = 2.0f; //空心的半径
    // chartDataSet.circleHoleColor = WKOrangeColor; //空心的颜色
    chartDataSet.drawFilledEnabled = YES;//是否填充颜色
    NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#ffffff"].CGColor,
                                                     (id)[ChartColorTemplates colorFromString:@"#f9511e"].CGColor];
    CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
      chartDataSet.fillAlpha = 0.7f;//透明度
      chartDataSet.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f]; //赋值填充颜色对象
      CGGradientRelease(gradientRef);
    return chartDataSet;
    
}

#pragma mark - IChartValueFormatter delegate (折线值)

- (NSString *)stringForValue:(double)value entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex viewPortHandler:(ChartViewPortHandler *)viewPortHandler
{
    return nil;
    // return [NSString stringWithFormat:@"%@", value];
}

#pragma mark - IChartAxisValueFormatter delegate (y轴值) (x轴的值写在DateValueFormatter类里, 都是这个协议方法)
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    if (ABS(value) > 10000)
    {
        return [NSString stringWithFormat:@"%.1fw", value/(double)10000];
    }
    return [NSString stringWithFormat:@"%0.2f", value];
}


/*
 <ChartViewDelegate>
 -(void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
 
 _markY.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)entry.y];
 //将点击的数据滑动到中间
 [_lineView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_lineView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
 
 
 }
 -(void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView {
 
 
 }
 
 
 - (LineChartData *)setData{
 
 int xVals_count = 12;//X轴上要显示多少条数据
 double maxYVal = 100;//Y轴的最大值
 
 //X轴上面需要显示的数据
 NSMutableArray *xVals = [[NSMutableArray alloc] init];
 for (int i = 0; i < xVals_count; i++) {
 [xVals addObject:[NSString stringWithFormat:@"%d月", i+1]];
 }
 
 //对应Y轴上面需要显示的数据
 NSMutableArray *yVals = [[NSMutableArray alloc] init];
 for (int i = 0; i < xVals_count; i++) {
 double mult = maxYVal + 1;
 double val = (double)(arc4random_uniform(mult));
 ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:val xIndex:i];
 [yVals addObject:entry];
 }
 
 LineChartDataSet *set1 = nil;
 if (self.LineChartView.data.dataSetCount > 0) {
 LineChartData *data = (LineChartData *)self.LineChartView.data;
 set1 = (LineChartDataSet *)data.dataSets[0];
 set1.yVals = yVals;
 return data;
 }else{
 //创建LineChartDataSet对象
 set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"lineName"];
 //设置折线的样式
 set1.lineWidth = 1.0/[UIScreen mainScreen].scale;//折线宽度
 set1.drawValuesEnabled = YES;//是否在拐点处显示数据
 set1.valueColors = @[[UIColor brownColor]];//折线拐点处显示数据的颜色
 [set1 setColor:[self colorWithHexString:@"#007FFF"]];//折线颜色
 set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
 //折线拐点样式
 set1.drawCirclesEnabled = NO;//是否绘制拐点
 set1.circleRadius = 4.0f;//拐点半径
 set1.circleColors = @[[UIColor redColor], [UIColor greenColor]];//拐点颜色
 //拐点中间的空心样式
 set1.drawCircleHoleEnabled = YES;//是否绘制中间的空心
 set1.circleHoleRadius = 2.0f;//空心的半径
 set1.circleHoleColor = [UIColor blackColor];//空心的颜色
 //折线的颜色填充样式
 //第一种填充样式:单色填充
 //        set1.drawFilledEnabled = YES;//是否填充颜色
 //        set1.fillColor = [UIColor redColor];//填充颜色
 //        set1.fillAlpha = 0.3;//填充颜色的透明度
 //第二种填充样式:渐变填充
 set1.drawFilledEnabled = YES;//是否填充颜色
 NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,
 (id)[ChartColorTemplates colorFromString:@"#FF007FFF"].CGColor];
 CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
 set1.fillAlpha = 0.3f;//透明度
 set1.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//赋值填充颜色对象
 CGGradientRelease(gradientRef);//释放gradientRef
 
 //点击选中拐点的交互样式
 set1.highlightEnabled = YES;//选中拐点,是否开启高亮效果(显示十字线)
 set1.highlightColor = [self colorWithHexString:@"#c83c23"];//点击选中拐点的十字线的颜色
 set1.highlightLineWidth = 1.0/[UIScreen mainScreen].scale;//十字线宽度
 set1.highlightLineDashLengths = @[@5, @5];//十字线的虚线样式
 
 //将 LineChartDataSet 对象放入数组中
 NSMutableArray *dataSets = [[NSMutableArray alloc] init];
 [dataSets addObject:set1];
 
 //添加第二个LineChartDataSet对象
 //        LineChartDataSet *set2 = [set1 copy];
 //        NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
 //        for (int i = 0; i < xVals_count; i++) {
 //            double mult = maxYVal + 1;
 //            double val = (double)(arc4random_uniform(mult));
 //            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithValue:val xIndex:i];
 //            [yVals2 addObject:entry];
 //        }
 //        set2.yVals = yVals2;
 //        [set2 setColor:[UIColor redColor]];
 //        set2.drawFilledEnabled = YES;//是否填充颜色
 //        set2.fillColor = [UIColor redColor];//填充颜色
 //        set2.fillAlpha = 0.1;//填充颜色的透明度
 //        [dataSets addObject:set2];
 
 //创建 LineChartData 对象, 此对象就是lineChartView需要最终数据对象
 LineChartData *data = [[LineChartData alloc] initWithXVals:xVals dataSets:dataSets];
 [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];//文字字体
 [data setValueTextColor:[UIColor grayColor]];//文字颜色
 NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
 //自定义数据显示格式
 [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
 [formatter setPositiveFormat:@"#0.0"];
 [data setValueFormatter:formatter];
 
 
 return data;
 }
 
 
 }
 
 */

@end
