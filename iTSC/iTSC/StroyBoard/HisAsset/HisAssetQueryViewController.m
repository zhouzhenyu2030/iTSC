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

//@synthesize delegate;
//@synthesize DatePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //画图数组
    xValueArr =  [[NSMutableArray alloc]init];
    yValueArr =  [[NSMutableArray alloc]init];
}


////////////////////////////////////////////
- (IBAction)ButtonClick:(id)sender
{
    [self QueryData];
    
    HADrawChartViewController *ctrl = [TscConst HADrawChartViewController];
    //HADrawChartView *ctrl = [TscConst HADrawChartView];
    
    if(ctrl!=nil)
        [ctrl initLineChartDataWithXvalueArr:xValueArr YvalueArr:yValueArr];
}




////////////////////////////////////////////
-(void)QueryData
{
 
    [xValueArr removeAllObjects];
    [yValueArr removeAllObjects];
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"HisAssetChartViewController: Init: queryContext==nil!");
        return;
    }
    
    //SELECT
    NSString* _condstr = [TscConnections getCurrentConnection].AccountID;
    _condstr = [_condstr stringByAppendingFormat:@" and HisDate>'%@'", [TscConfig strHisAssetStartDate]];
    NSLog(@"HisAssetChartViewController: Query: %@", _condstr);
    
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

    
    

}


@end
