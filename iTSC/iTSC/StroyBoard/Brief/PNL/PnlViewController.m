//
//  PnlViewController.m
//  iTSC
//
//  Created by tss on 2019/1/21.
//  Copyright © 2019年 tss. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "PnlViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"


@implementation PnlViewController



@synthesize TableView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    RefreshCnt = 0;
    isTimerProcessing = false;
    
    [self InitTableViewCells];
    
    Switch_AutoRefresh = [self AppendSwitch];
    Switch_AutoRefresh.on = [TscConfig isPnlAutoRefresh];
    
    if(myTimer==nil)
    {
        myTimer  =  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
    
    [self setupRefresh];
    TableView.rowHeight = 18;
}

// 设置下拉刷新
- (void)setupRefresh
{
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
    //刷新图形时的颜色，即刷新的时候那个菊花的颜色
    //refreshControl.tintColor = [UIColor redColor];
    [self.TableView addSubview:refreshControl];
    //[refreshControl beginRefreshing];
    //[self refreshClick:refreshControl];
}


// 下拉刷新触发
- (void)refreshClick:(UIRefreshControl *)refreshControl
{
    [self InitTableViewCells];
    RefreshCountCell.detailTextLabel.text = @"0";
    RefreshCnt = 1;
    [self QueryAndDisplay];
    [refreshControl endRefreshing];
    [self.TableView reloadData];// 刷新tableView即可
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
    if([TscConfig isPnlAutoRefresh] == false) return;
    
    if(isTimerProcessing) return;
    
    isTimerProcessing=true;
    RefreshCnt++;
    [self QueryAndDisplay];
    isTimerProcessing=false;
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
    [TscConfig setPnlAutoRefresh:([Switch_AutoRefresh isOn])];
}



////////////////////////////////////////////////////////////////////////////////////
-(void) InitTableViewCells
{
    [UIHelper ClearTabelViewCellText:TableView];
    
    UITableViewCell *cell;
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:0 TitleText:@"Trade PNL (Market):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"Yd PNL (Market):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:2 TitleText:@"Total PNL (Market):" DetialText:@"-"];

    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:0 TitleText:@"Trade PNL (Theo):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"Yd PNL (Theo):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:2 TitleText:@"Total PNL (Theo):" DetialText:@"-"];

    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:0 TitleText:@"Excersize PNL:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:1 TitleText:@"Close PNL (Theo):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:2 TitleText:@"Close PNL (Market):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:3 TitleText:@"Market Value:" DetialText:@"-"];
    
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:0 TitleText:@"AutoRefresh:" DetialText:@""];
    RefreshSwitchCell = cell;
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:1 TitleText:@"RefreshCount:" DetialText:@"-"];
    RefreshCountCell = cell;
}



//查询，在此获取数据
- (void)QueryAndDisplay
{
    
    //DB Query
    NSLog(@"PnlViewController: start!");
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"PnlViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"PnlViewController: SELECT: start!");
    
    
    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"runtimeinfo" condition:@"ItemKey='PNL' and EntityType='A'"];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    
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
        
        if([typename isEqualToString:@"YPNL_Mkt"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Yd PNL (Market):" FieldName:@"ItemValue" SetColor:true];
        if([typename isEqualToString:@"TradePNL_Mkt"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Trade PNL (Market):" FieldName:@"ItemValue" SetColor:true];
        if([typename isEqualToString:@"TotalPNL_Mkt"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Total PNL (Market):" FieldName:@"ItemValue" SetColor:true];

        if([typename isEqualToString:@"YPNL_Theo"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Yd PNL (Theo):" FieldName:@"ItemValue" SetColor:true];
        if([typename isEqualToString:@"TradePNL_Theo"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Trade PNL (Theo):" FieldName:@"ItemValue" SetColor:true];
        if([typename isEqualToString:@"TotalPNL_Theo"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Total PNL (Theo):" FieldName:@"ItemValue" SetColor:true];

        if([typename isEqualToString:@"ExecPNL"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Excersize PNL:" FieldName:@"ItemValue" SetColor:true];
        if([typename isEqualToString:@"CloseTheoryPNL"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Close PNL (Theo):" FieldName:@"ItemValue" SetColor:true];
        if([typename isEqualToString:@"CloseMarketPNL"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Close PNL (Market):" FieldName:@"ItemValue" SetColor:true];

        if([typename isEqualToString:@"MarketValue_Mkt"])
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Market Value:" FieldName:@"ItemValue" SetColor:true];

    }
    
    _field=[tasks objectAtIndex:0];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordDate:" DetialText:_field[@"RecordDate"]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordTime:" DetialText:_field[@"RecordTime"]];
    
    
    NSLog(@"PnlViewController: SELECT: over!");
    
    
    RefreshCountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", RefreshCnt];
    [TableView reloadData];
    
    
    NSLog(@"PnlViewController: RefreshCnt=%d", RefreshCnt);
}


@end
