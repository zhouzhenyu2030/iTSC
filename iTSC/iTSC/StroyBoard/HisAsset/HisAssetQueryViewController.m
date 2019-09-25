//
//  HisAssetQueryViewController.m
//  iTSC
//
//  Created by tss on 2019/1/29.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"
#import "TscConnections.h"
#import "TscConst.h"

#import "HADrawChartView.h"
#import "HADrawChartViewController.h"
#import "HisAssetQueryViewController.h"

@implementation HisAssetQueryViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    myFunctionName=@"HAMktOrTheoPickerViewController";
    
    //画图数组
    xValueArr =  [[NSMutableArray alloc]init];
    yValueArr =  [[NSMutableArray alloc]init];
}


////////////////////////////////////////////
- (IBAction)ButtonClick:(id)sender
{
    //Display
    if([DBHelper BeginQuery])
    {
        [self QueryData];
        [DBHelper EndQuery];
    }
}




////////////////////////////////////////////
-(void)QueryData
{
 
    [xValueArr removeAllObjects];
    [yValueArr removeAllObjects];
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"%@: Init: queryContext==nil!", myFunctionName);
        return;
    }
    
    //SELECT
    NSString* _condstr = [TscConnections getCurrentConnection].AccountID;
    _condstr = [_condstr stringByAppendingFormat:@" and HisDate>'%@'", [TscConfig strHisAssetStartDate]];
    NSLog(@"%@: Query: %@",  myFunctionName, _condstr);
    
    NSString* _displayFieldName=[TscConfig strHisAssetDisplayFieldName];
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"tsshis.hisasset" condition:_condstr];
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
        float _value=[_field[_displayFieldName] doubleValue];
 
        [yValueArr addObject:[NSString stringWithFormat:(@"%.4f"), _value]];
        
         //_value=_value/100/100;  //zzy
        //[yValueArr addObject:_field[@"Asset"]];
    }

    
    //设置Y坐标轴最大最小值
    HADrawChartViewController *ctrl = [TscConst HADrawChartViewController];
    if(ctrl!=nil)
        [ctrl initLineChartDataWithXvalueArr:xValueArr YvalueArr:yValueArr];

}


@end
