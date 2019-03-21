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
    
    //FP
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:0 TitleText:@"FP Option Numbr:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"FP Average Edge:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:2 TitleText:@"FP Max Edge:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:3 TitleText:@"FP Min Edge:" DetialText:@"-"];
    
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:4 TitleText:@"FP Positive Option Number:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:5 TitleText:@"FP Positive Avg Edge:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:6 TitleText:@"FP Positive Max Edge:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:7 TitleText:@"FP Positive Min Edge:" DetialText:@"-"];
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:8 TitleText:@"FP Negative Option Number:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:9 TitleText:@"FP Negative Avg Edge:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:10 TitleText:@"FP Negative Max Edge:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:11 TitleText:@"FP Negative Min Edge:" DetialText:@"-"];
    
 
    //NP
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:0 TitleText:@"NP Option Numbr:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"NP Average Edge:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:2 TitleText:@"NP Max Edge:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:3 TitleText:@"NP Min Edge:" DetialText:@"-"];
    
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:4 TitleText:@"NP Positive Option Number:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:5 TitleText:@"NP Positive Avg Edge:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:6 TitleText:@"NP Positive Max Edge:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:7 TitleText:@"NP Positive Min Edge:" DetialText:@"-"];
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:8 TitleText:@"NP Negative Option Number:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:9 TitleText:@"NP Negative Avg Edge:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:10 TitleText:@"NP Negative Max Edge:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:11 TitleText:@"NP Negative Min Edge:" DetialText:@"-"];
    
    
    //Refresh
    if(vInitAll)
    {
        cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:0 TitleText:@"RefreshCount:" DetialText:@"-"];
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
        
        
        ////////////////////////////////////////  FP  /////////////////////////////////////////////
        
        if([typename isEqualToString:@"OptionNumber"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"FP Option Numbr:" FieldName:@"ItemValue"];
            continue;
        }
        if([typename isEqualToString:@"AvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"FP Average Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([typename isEqualToString:@"MaxEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"FP Max Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([typename isEqualToString:@"MinEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"FP Min Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        
        
        if([typename isEqualToString:@"POptionNumber"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"FP Positive Option Number:" FieldName:@"ItemValue"];
            continue;
        }
        if([typename isEqualToString:@"PAvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"FP Positive Avg Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([typename isEqualToString:@"PMaxEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"FP Positive Max Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([typename isEqualToString:@"PMinEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"FP Positive Min Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        
        
        if([typename isEqualToString:@"NOptionNumber"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"FP Negative Option Number:" FieldName:@"ItemValue"];
        continue;
        }
    
        if([typename isEqualToString:@"NAvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"FP Negative Avg Edge:" FieldName:@"ItemValue" SetColor:true];
        continue;
        }
        if([typename isEqualToString:@"NMaxEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"FP Negative Max Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([typename isEqualToString:@"NMinEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"FP Negative Min Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        
        
        
        ////////////////////////////////////////  NP  /////////////////////////////////////////////
        if([typename isEqualToString:@"NPOptionNumber"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"NP Option Numbr:" FieldName:@"ItemValue"];
            continue;
        }
        if([typename isEqualToString:@"NPAvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"NP Average Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([typename isEqualToString:@"NPMaxEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"NP Max Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([typename isEqualToString:@"NPMinEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"NP Min Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        
        
        if([typename isEqualToString:@"PNPOptionNumber"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"NP Positive Option Number:" FieldName:@"ItemValue"];
            continue;
        }
        if([typename isEqualToString:@"PNPAvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"NP Positive Avg Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([typename isEqualToString:@"PNPMaxEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"NP Positive Max Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([typename isEqualToString:@"PNPMinEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"NP Positive Min Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        
        
        if([typename isEqualToString:@"NNPOptionNumber"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"NP Negative Option Number:" FieldName:@"ItemValue"];
            continue;
        }
        
        if([typename isEqualToString:@"NNPAvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"NP Negative Avg Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([typename isEqualToString:@"NNPMaxEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"NP Negative Max Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([typename isEqualToString:@"NNPMinEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"NP Negative Min Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        
    }
    

    
    _field=[tasks objectAtIndex:0];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordDate:" DetialText:_field[@"RecordDate"]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordTime:" DetialText:[_field[@"RecordTime"] substringToIndex:8]];
    
    
    NSLog(@"%@: SELECT: over!", FunctionName);
    
    [TableView reloadData];
    
    
    NSLog(@"%@: RefreshCnt=%d", FunctionName, RefreshCnt);
}


@end
