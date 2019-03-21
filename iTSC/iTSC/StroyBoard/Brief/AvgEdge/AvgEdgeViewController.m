//
//  AvgEdgeViewController.m
//  iTSC
//
//  Created by tss on 2019/2/27.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>

#import "AvgEdgeViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"


@implementation AvgEdgeViewController



@synthesize TableView;

NSString* FunctionName=@"AvgEdgeViewController";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    RefreshCnt = 0;
    isTimerProcessing = false;
    
    [self InitTableViewCells:true];
    
    RefreshTimerElpasedSeconds = 0;
    if(myTimer==nil)
        myTimer  =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
     [self StopTimer];
    
    TableView.rowHeight = 18;
}


//定时器处理函数
-(void)timerFired
{
    if([TscConfig isInBackground] == true) return;
    if([TscConfig isGlobalAutoRefresh] == false) return;
    
    if(isTimerProcessing) return;
    
    RefreshTimerElpasedSeconds++;
    if(RefreshTimerElpasedSeconds<TscConfig.RefreshSeconds) return;
    
    isTimerProcessing=true;
    RefreshCnt++;
    [self QueryAndDisplay];
    isTimerProcessing=false;
    
    RefreshTimerElpasedSeconds=0;
}


//开启定时器
-(void) StartTimer
{
    if(myTimer != nil)
    {
        [myTimer setFireDate:[NSDate distantPast]];
    }
}

//关闭定时器
-(void) StopTimer
{
    if(myTimer != nil)
    {
        [myTimer setFireDate:[NSDate distantFuture]];
    }
}


//页面将要进入前台，开启定时器
-(void)viewWillAppear:(BOOL)animated
{
    [self StartTimer];
}


//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    [self StopTimer];
}


////////////////////////////////////////////////////////////////////////////////////
-(void) InitTableViewCells:(BOOL)vInitAll
{
    if(vInitAll)
        [UIHelper ClearTabelViewCellText:TableView];
    
    UITableViewCell *cell;
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:0 TitleText:@"Option Numbr:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"Average Edge:" DetialText:@"-"];
    
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:0 TitleText:@"Positive Option Number:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"Positive Avg Edge:" DetialText:@"-"];
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:0 TitleText:@"Negative Option Number:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:1 TitleText:@"Negative Avg Edge:" DetialText:@"-"];
    
    if(vInitAll)
    {
        cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:0 TitleText:@"RefreshCount:" DetialText:@"-"];
        RefreshCountCell = cell;
    }
    
}



//查询，在此获取数据
- (void)QueryAndDisplay
{
    
    RefreshCountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", RefreshCnt];
    
    //DB Query
    NSLog(@"%@: start!", FunctionName);
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"%@: Init: queryContext==nil!", FunctionName);
        return;
    }
    
    NSLog(@"%@: SELECT: start!", FunctionName);
    
    
    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"runtimeinfo" condition:@"ItemKey='Edge' and EntityType='A'"];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    
    //清除原显示
    [self InitTableViewCells:false];
    
    
    NSUInteger count = tasks.count;
    if(count <= 0)
        return;
    
    
    //显示
    NSDictionary  *_field;
    NSString* typename;
    for( int i=0; i<count; i++)
    {
        _field=[tasks objectAtIndex:i];
        NSLog(@"%@", _field);
        
        typename=_field[@"ItemType"];
        
        if([typename isEqualToString:@"OptionNumber"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Option Numbr:" FieldName:@"ItemValue"];
        if([typename isEqualToString:@"AvgEdge"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Average Edge:" FieldName:@"ItemValue" SetColor:true];
        
        if([typename isEqualToString:@"POptionNumber"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Positive Option Number:" FieldName:@"ItemValue"];
        if([typename isEqualToString:@"PAvgEdge"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Positive Avg Edge:" FieldName:@"ItemValue" SetColor:true];
       
        if([typename isEqualToString:@"NOptionNumber"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Negative Option Number:" FieldName:@"ItemValue"];
        if([typename isEqualToString:@"NAvgEdge"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Negative Avg Edge:" FieldName:@"ItemValue" SetColor:true];
    }
    

    
    _field=[tasks objectAtIndex:0];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordDate:" DetialText:_field[@"RecordDate"]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordTime:" DetialText:[_field[@"RecordTime"] substringToIndex:8]];
    
    
    NSLog(@"%@: SELECT: over!", FunctionName);
    
    [TableView reloadData];
    
    
    NSLog(@"%@: RefreshCnt=%d", FunctionName, RefreshCnt);
}


@end
