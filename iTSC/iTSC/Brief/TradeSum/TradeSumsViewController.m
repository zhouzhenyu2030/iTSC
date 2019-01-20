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
    
    [self InitTableViewCells];
    
    Switch_AutoRefresh = [self AppendSwitch];
    Switch_AutoRefresh.on = [TscConfig isTradeSumAutoRefresh];
    
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
    if([TscConfig isTradeSumAutoRefresh] == false) return;
    
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
    [TscConfig setTradeSumAutoRefresh:([Switch_AutoRefresh isOn])];
}



////////////////////////////////////////////////////////////////////////////////////
-(void) InitTableViewCells
{
    [UIHelper ClearTabelViewCellText:TableView];
    
    UITableViewCell *cell;
    
    
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:0 TitleText:@"TPR:" DetialText:@"-"];
    cell.detailTextLabel.textColor=UIColor.magentaColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"Trade Edge:" DetialText:@"-"];
    cell.detailTextLabel.textColor=UIColor.blueColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:2 TitleText:@"Trade Qty:" DetialText:@"-"];
    cell.detailTextLabel.textColor=UIColor.blueColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:3 TitleText:@"Buy Open Trade:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:4 TitleText:@"Trade Fee:" DetialText:@"-"];

    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:0 TitleText:@"Order Trade Ratio (%):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"Order Insert Cnt:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:2 TitleText:@"Order Insert Qty:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:3 TitleText:@"Order Rsp Cnt:" DetialText:@"-"];


    
    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:0 TitleText:@"Trade Edge (AT):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:1 TitleText:@"Trade Qty (AT):" DetialText:@"-"];
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:0 TitleText:@"Trade Edge (AH):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:1 TitleText:@"Trade Qty (AH):" DetialText:@"-"];


    cell = [UIHelper SetTabelViewCellText:TableView Section:5 Row:0 TitleText:@"AutoRefresh:" DetialText:@""];
    RefreshSwitchCell = cell;
    cell = [UIHelper SetTabelViewCellText:TableView Section:5 Row:1 TitleText:@"RefreshCount:" DetialText:@"-"];
    RefreshCountCell = cell;
}



//查询，在此获取数据
- (void)QueryAndDisplay
{
 
    //DB Query
    NSLog(@"TradeSumViewController: start!");
    
    [DBHelper Init];
    
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
        typename=[typename stringByAppendingString:@":"];
        
        if([typename isEqualToString:@"TradePosRatio:"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"TPR:" DetialText:value];
        }
        if([typename isEqualToString:@"TradeQty:"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:0];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Trade Qty:" DetialText:value];
        }
        if([typename isEqualToString:@"TradeFee:"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Trade Fee:" DetialText:value];
        }
        if([typename isEqualToString:@"TradeEdge:"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Trade Edge:" DetialText:value];
        }
        if([typename isEqualToString:@"BuyOpenTrade:"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:0];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Buy Open Trade:" DetialText:value];
        }


        if([typename isEqualToString:@"OrderTradeRatio:"])
        {
            value=_field[@"ItemValue"];
            float _fValue=value.floatValue*100;
            value=[StringHelper fPositiveFormat:_fValue pointNumber:2];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Order Trade Ratio (%):" DetialText:value];
        }
        if([typename isEqualToString:@"OrderInsertCnt:"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:0];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Order Insert Cnt:" DetialText:value];
        }
        if([typename isEqualToString:@"OrderInsertQty:"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:0];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Order Insert Qty:" DetialText:value];
        }
        if([typename isEqualToString:@"OrderRspCnt:"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:0];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Order Rsp Cnt:" DetialText:value];
        }


    }
    
    _field=[tasks objectAtIndex:0];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordDate:" DetialText:_field[@"RecordDate"]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordTime:" DetialText:_field[@"RecordTime"]];
    
    
    NSLog(@"TradeSumViewController: SELECT: over!");
    

    RefreshCountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", RefreshCnt];
    [TableView reloadData];

    
    NSLog(@"TradeSumViewController: RefreshCnt=%d", RefreshCnt);
}




///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) DisplayCell:(NSDictionary*)vField TitleName:(NSString*)vTitleName FieldName:(NSString*) vFieldName SetColor:(BOOL) visSetColor
{
    
    NSString* value = [StringHelper sPositiveFormat:vField[vFieldName] pointNumber:2];
    UITableViewCell* cell=[UIHelper SetTabelViewCellDetailText:TableView TitleText: vTitleName DetialText:value];
    
    if(cell==nil)
        return;
    
    if(visSetColor == false)
        return;
    
    if([vField[vFieldName] floatValue]==0)
    {
        cell.detailTextLabel.textColor=UIColor.blackColor;
    }
    else
    {
        if([vField[vFieldName] floatValue]>0)
            cell.detailTextLabel.textColor=UIColor.blueColor;
        else
            cell.detailTextLabel.textColor=UIColor.redColor;
    }
}
-(UITableViewCell*) DisplayIntCell:(NSDictionary*)vField TitleName:(NSString*)vTitleName FieldName:(NSString*) vFieldName
{
    NSString* value = [StringHelper sPositiveFormat:vField[vFieldName] pointNumber:0];
    UITableViewCell* cell=[UIHelper SetTabelViewCellDetailText:TableView TitleText: vTitleName DetialText:value];
    return cell;
}


@end

