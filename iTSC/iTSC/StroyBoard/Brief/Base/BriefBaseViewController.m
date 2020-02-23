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




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// viewDidLoad
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//设置LogStr,zTableView
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 设置zTLogStr
-(void) SetLogStr {}


// 设置zTableView
-(void) SetTableView {}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//下拉刷新
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///设置下拉刷新
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



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//定时器
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
//初始化cells显示
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) InitTableViewCells:(BOOL)vInitAll
{}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//查询&显示
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) QueryAndDisplay;
{
    //RefreshCount
    RefreshCountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", RefreshCnt];
    
    //QueryData
    if( [self QueryData] == false)
        return;
    
    //Display
    [self Display];

}





//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//设置查询条件，查询
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) SetQureyCondition
{}

-(bool)QueryData
{
    //Log
    NSLog(@"%@: SELECT: start!", zLogStr);
    
    //queryContext : 检查连接性
    OHMySQLQueryContext *queryContext = [DBHelper GetContext];
    if(queryContext == nil)
    {
        NSLog(@"%@: Init: queryContext==nil!", zLogStr);
        return false;
    }
    
    //SetQureyCondition：设置查询条件
    [self SetQureyCondition];

    
    //Query：查询
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:zTableName condition:zCondStr];
    NSError *queryerror = nil;
    zRecords = [queryContext executeQueryRequestAndFetchResult:query error:&queryerror];
    
    //Log
     NSLog(@"%@: SELECT: over! record cnt=%ld", zLogStr, zRecords.count);

    //清除原显示
     [self InitTableViewCells:false];
     
    //检查查询结果数
     if(zRecords.count <= 0)
     {
         return false;
     }
    
    //
    return true;
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//显示
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) Display
{
    //Log
    NSLog(@"%@: Display: start!", zLogStr);
    
    
    //遍历item
    for( int i=0; i<zRecords.count; i++)
    {
        //Feild
         zField = [zRecords objectAtIndex:i];
        
        //Log
        NSLog(@"record#=%d, %@", i, zField);
        
        
        //Name
        zItemKey = zField[@"ItemKey"];
        zItemType = zField[@"ItemType"];
        zItemValue = zField[@"ItemValue"];
        
        //DisplayItem
        [self DisplayItem];
        
        //MD
        if([zItemKey isEqualToString:@"MD"])
        {
            if([zItemType isEqualToString:@"Date"])
            {
                [UIHelper SetTabelViewCellDetailText:zTableView TitleText: @"MD Date:" DetialText:zField[@"ItemValue"]];
                continue;
            }
            if([zItemType isEqualToString:@"Time"])
            {
                [UIHelper SetTabelViewCellDetailText:zTableView TitleText: @"MD Time:" DetialText:zField[@"ItemValue"]];
                continue;
            }
        }
        
           
    }
    
    
    //RecordDate & RecordTime
    zField = [zRecords objectAtIndex:0];
    [UIHelper SetTabelViewCellDetailText:zTableView TitleText: @"RecordDate:" DetialText:zField[@"RecordDate"]];
    [UIHelper SetTabelViewCellDetailText:zTableView TitleText: @"RecordTime:" DetialText:[zField[@"RecordTime"] substringToIndex:8]];

    
    //reload
    [zTableView reloadData];
    
    //Log
     NSLog(@"%@: Display: over! record cnt=%ld", zLogStr, zRecords.count);
    
    //Log
    NSLog(@"%@: Display: RefreshCnt=%d", zLogStr, RefreshCnt);
}

-(void) DisplayItem
{}



@end
