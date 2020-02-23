//
//  BriefBaseViewController.m
//  iTSC
//
//  Created by tss on 2020/2/22.
//  Copyright © 2020 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BriefBaseViewController.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"
#import "DBHelper.h"


@implementation BriefBaseViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self SetLogStr];
    [self SetTableView];
    
    RefreshCnt = 0;
    isTimerProcessing = false;

    [self InitTableViewCells:true];
   
    RefreshTimerElpasedSeconds = 0;
    if(myTimer==nil)
        myTimer  =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [self StopTimer];

    
    [self setupRefresh];
    zTableView.rowHeight = 18;
}

// 设置zTLogStr
-(void) SetLogStr {}


// 设置zTableView
-(void) SetTableView {}


// 设置下拉刷新
- (void)setupRefresh
{
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
    zTableView.refreshControl = refreshControl;
}
// 下拉刷新触发
- (void)refreshClick:(UIRefreshControl *)refreshControl
{
    [self InitTableViewCells:true];
    RefreshCountCell.detailTextLabel.text=@"0";
    RefreshCnt = 1;
    [self QueryAndDisplay];
    [zTableView reloadData];
    [refreshControl endRefreshing];
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
 
    
    //Server ID
    [UIHelper SetTabelViewCellDetailText:zTableView TitleText:@"Server ID:" DetialText:DBHelper.CurrentConnectionKey];


    //Display
    if([DBHelper BeginQuery])
    {
        RefreshCnt++;
        [self QueryAndDisplay];
        [DBHelper EndQuery];
    }
    
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


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//查询，在此获取数据
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) SetQureyCondition
{;}

-(bool)QueryData
{
    OHMySQLQueryContext *queryContext;
    OHMySQLQueryRequest *query;
    NSError *queryerror;
    
    //Log
    NSLog(@"%@: SELECT: start!", zLogStr);
    
    //DB Query
    queryContext=[DBHelper GetContext];
    if(queryContext==nil)
    {
        NSLog(@"%@: Init: queryContext==nil!", zLogStr);
        return false;
    }
    
    //SELECT
     NSString* _condstr = @"(";
     _condstr=[_condstr stringByAppendingString:@" ( ItemKey='MD' )"];

     _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='Position' )"];

     _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='TradeSum' and (ItemType='TradeQty' or ItemType='OpenTradeQty') )"];
     
     _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='Status' and (ItemType='OOMCnt') )"];

     _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='MDS' and (ItemType='Volume' or ItemType='Value') )"];

     
     
     _condstr=[_condstr stringByAppendingString:@" ) and EntityType='A'"];

     
     
     query = [OHMySQLQueryRequestFactory SELECT:@"runtimeinfo" condition:_condstr];
     queryerror = nil;
     tasks = [queryContext executeQueryRequestAndFetchResult:query error:&queryerror];
     
}
-(void) InitTableViewCells:(BOOL)vInitAll
{
}
-(void) QueryAndDisplay;
{
}

@end
