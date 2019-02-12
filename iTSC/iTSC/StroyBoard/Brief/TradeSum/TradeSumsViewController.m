//
//  TradeSumViewController.m
//  iTSC
//
//  Created by tss on 2019/1/20.
//  Copyright © 2019年 tss. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "TradeSumsViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"


@implementation TradeSumsViewController



@synthesize TableView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    RefreshCnt = 0;
    isTimerProcessing = false;
    
    [self InitTableViewCells:true];
    
    Switch_AutoRefresh = [self AppendSwitch];
    Switch_AutoRefresh.on = [TscConfig isTradeSumAutoRefresh];
    
    RefreshTimerElpasedSeconds = 0;
    if(myTimer==nil)
        myTimer  =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];

    
    [self setupRefresh];
    TableView.rowHeight = 18;
}

// 设置下拉刷新
- (void)setupRefresh
{
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
    TableView.refreshControl = refreshControl;
}
// 下拉刷新触发
- (void)refreshClick:(UIRefreshControl *)refreshControl
{
    [self InitTableViewCells:true];
    RefreshCountCell.detailTextLabel.text=@"0";
    RefreshCnt = 1;
    [self QueryAndDisplay];
    [self.TableView reloadData];
    [refreshControl endRefreshing];
}


//AppendSwitch
-(UISwitch*) AppendSwitch
{
    UISwitch *_switch = [[UISwitch alloc] init];
    [_switch addTarget:self action:@selector(SwitchChanged:) forControlEvents:UIControlEventValueChanged];
    RefreshSwitchCell.accessoryView = _switch;
    return _switch;
}


//定时器处理函数
-(void)timerFired
{
    if([TscConfig isInBackground] == true) return;
    if([TscConfig isGlobalAutoRefresh] == false) return;
    if([TscConfig isTradeSumAutoRefresh] == false) return;
    
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
    [self SetTimerState];
}


//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    [self StopTimer];
}


//根据switch设定Timer启停
-(void) SetTimerState
{
    if ([Switch_AutoRefresh isOn])
        [self StartTimer];
    else
        [self StopTimer];
}


//switch状态改变
-(void)SwitchChanged:(id)sender
{
    [self SetTimerState];
    [TscConfig setTradeSumAutoRefresh:([Switch_AutoRefresh isOn])];
}



////////////////////////////////////////////////////////////////////////////////////
-(void) InitTableViewCells:(BOOL)vInitAll
{
    if(vInitAll)
        [UIHelper ClearTabelViewCellText:TableView];

    UITableViewCell *cell;
    
    [UIHelper SetTabelViewCellText:TableView Section:0 Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    [UIHelper SetTabelViewCellText:TableView Section:0 Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    
    [UIHelper SetTabelViewCellText:TableView Section:1 Row:0 TitleText:@"Order Trade Ratio (%):" DetialText:@"-" Color:UIColor.purpleColor];
    [UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"Order Insert Cnt:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:1 Row:2 TitleText:@"Order Insert Qty:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:1 Row:3 TitleText:@"Order Delete Cnt:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:1 Row:4 TitleText:@"Order Rsp Cnt:" DetialText:@"-"];

    [UIHelper SetTabelViewCellText:TableView Section:2 Row:0 TitleText:@"TPR:" DetialText:@"-" Color:UIColor.magentaColor];
    [UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"Trade Edge:" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:TableView Section:2 Row:2 TitleText:@"Trade Qty:" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:TableView Section:2 Row:3 TitleText:@"Edge Per Order:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:2 Row:4 TitleText:@"Buy Open Trade:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:2 Row:5 TitleText:@"Trade Fee:" DetialText:@"-"];
    
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:0 TitleText:@"Trade Edge (AT):" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:1 TitleText:@"Trade Qty (AT):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:2 TitleText:@"Edge Per Order (AT):" DetialText:@"-"];

    [UIHelper SetTabelViewCellText:TableView Section:4 Row:0 TitleText:@"Trade Edge (AH):" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:TableView Section:4 Row:1 TitleText:@"Trade Qty (AH):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:4 Row:2 TitleText:@"Edge Per Order (AH):" DetialText:@"-"];

    if(vInitAll)
    {
        cell = [UIHelper SetTabelViewCellText:TableView Section:5 Row:0 TitleText:@"AutoRefresh:" DetialText:@""];
        RefreshSwitchCell = cell;
        cell = [UIHelper SetTabelViewCellText:TableView Section:5 Row:1 TitleText:@"RefreshCount:" DetialText:@"-"];
        RefreshCountCell = cell;
    }
    
}



//查询，在此获取数据
- (void)QueryAndDisplay
{
 
    RefreshCountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", RefreshCnt];

    //DB Query
    NSLog(@"TradeSumViewController: start!");
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"TradeSumViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"TradeSumViewController: SELECT: start!");
    
    
    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"runtimeinfo" condition:@"ItemKey='TradeSum' and EntityType='A'"];
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
    NSString* value;
    for( int i=0; i<count; i++)
    {
        _field=[tasks objectAtIndex:i];
        NSLog(@"%@", _field);
        
        typename=_field[@"ItemType"];
        
        
        if([typename isEqualToString:@"OrderTradeRatio"])
        {
            value=_field[@"ItemValue"];
            float _fValue=value.floatValue*100;
            value = [StringHelper fPositiveFormat:_fValue pointNumber:2]; value = [value stringByAppendingString:@"%"]; 
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Order Trade Ratio (%):" DetialText:value];
        }
        if([typename isEqualToString:@"OrderInsertCnt"])
             [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Order Insert Cnt:" FieldName:@"ItemValue"];
        if([typename isEqualToString:@"OrderInsertQty"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Order Insert Qty:" FieldName:@"ItemValue"];
        if([typename isEqualToString:@"OrderDeleteCnt"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Order Delete Cnt:" FieldName:@"ItemValue"];
        if([typename isEqualToString:@"OrderRspCnt"])
               [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Order Rsp Cnt:" FieldName:@"ItemValue"];


        //Trade
        if([typename isEqualToString:@"TradePosRatio"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"TPR:" FieldName:@"ItemValue" SetColor:false];

        if([typename isEqualToString:@"TradeQty"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Trade Qty:" FieldName:@"ItemValue"];

        if([typename isEqualToString:@"TradeFee"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Trade Fee:" FieldName:@"ItemValue" SetColor:false];

        if([typename isEqualToString:@"TradeEdge"])
            
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Trade Edge:" FieldName:@"ItemValue" SetColor:true];
        if([typename isEqualToString:@"EPO"])
            
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Edge Per Order:" FieldName:@"ItemValue" SetColor:false];
        if([typename isEqualToString:@"BuyOpenTrade"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Buy Open Trade:" FieldName:@"ItemValue"];



        if([typename isEqualToString:@"ATTradeEdge"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Trade Edge (AT):" FieldName:@"ItemValue" SetColor:true];

        if([typename isEqualToString:@"ATTradeQty"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Trade Qty (AT):" FieldName:@"ItemValue"];

        if([typename isEqualToString:@"ATEPO"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Edge Per Order (AT):" FieldName:@"ItemValue" SetColor:false];


        
        if([typename isEqualToString:@"AHTradeEdge"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Trade Edge (AH):" FieldName:@"ItemValue" SetColor:true];

        if([typename isEqualToString:@"AHTradeQty"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Trade Qty (AH):" FieldName:@"ItemValue"];

        if([typename isEqualToString:@"AHEPO"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Edge Per Order (AH):" FieldName:@"ItemValue" SetColor:false];


    }
    
    _field=[tasks objectAtIndex:0];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordDate:" DetialText:_field[@"RecordDate"]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordTime:" DetialText:[_field[@"RecordTime"] substringToIndex:8]];
    
    
    NSLog(@"TradeSumViewController: SELECT: over!");
 
    [TableView reloadData];

    
    NSLog(@"TradeSumViewController: RefreshCnt=%d", RefreshCnt);
}






@end

