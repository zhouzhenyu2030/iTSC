//
//  GreeksViewController.m
//  iTSC
//
//  Created by tss on 2019/1/19.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GreeksViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"


@implementation GreeksViewController



@synthesize TableView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    RefreshCnt = 0;
    isTimerProcessing = false;

    [self InitTableViewCells];
 
    Switch_AutoRefresh = [self AppendSwitch];
    Switch_AutoRefresh.on = [TscConfig isGreekAutoRefresh];
    
    RefreshTimerElpasedSeconds = 0;
    if(myTimer==nil)
        myTimer  =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];

    
    [self setupRefresh];
    TableView.rowHeight = 18; //UITableViewAutomaticDimension;
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
    [self InitTableViewCells];
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
    if([TscConfig isGreekAutoRefresh] == false) return;
    
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
    [TscConfig setGreekAutoRefresh:([Switch_AutoRefresh isOn])];
}



////////////////////////////////////////////////////////////////////////////////////
-(void) InitTableViewCells
{
    [UIHelper ClearTabelViewCellText:TableView];
    
    UITableViewCell *cell;
    
    [UIHelper SetTabelViewCellText:TableView Section:0 Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    [UIHelper SetTabelViewCellText:TableView Section:0 Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:0 TitleText:@"Delta:" DetialText:@"-"];
    cell.detailTextLabel.textColor= UIColor.blueColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"Vega:" DetialText:@"-"];
    cell.detailTextLabel.textColor= UIColor.blueColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:2 TitleText:@"Theta:" DetialText:@"-"];
    cell.detailTextLabel.textColor= UIColor.blueColor;
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:0 TitleText:@"Gamma:" DetialText:@"-"];
    cell.detailTextLabel.textColor= UIColor.blueColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"Charm:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:2 TitleText:@"Vanna:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:3 TitleText:@"Volga:" DetialText:@"-"];
    cell.detailTextLabel.textColor= UIColor.blueColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:4 TitleText:@"Veta:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:5 TitleText:@"Thema:" DetialText:@"-"];
    cell.detailTextLabel.textColor= UIColor.blueColor;
    
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:0 TitleText:@"Color:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:1 TitleText:@"Speed:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:2 TitleText:@"Zomma:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:3 TitleText:@"Ultima:" DetialText:@"-"];
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:0 TitleText:@"SRR:" DetialText:@"-"];
    cell.detailTextLabel.textColor= UIColor.blueColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:1 TitleText:@"SLR:" DetialText:@"-"];
    cell.detailTextLabel.textColor= UIColor.blueColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:2 TitleText:@"PCR:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:3 TitleText:@"CCR:" DetialText:@"-"];
    
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:5 Row:0 TitleText:@"Position:" DetialText:@"-"];
    cell.detailTextLabel.textColor= UIColor.blueColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:5 Row:1 TitleText:@"AT Trade Qty:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:5 Row:2 TitleText:@"AH Trade Qty:" DetialText:@"-"];
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:6 Row:0 TitleText:@"AutoRefresh:" DetialText:@""];
    RefreshSwitchCell = cell;
    cell = [UIHelper SetTabelViewCellText:TableView Section:6 Row:1 TitleText:@"RefreshCount:" DetialText:@"-"];
    RefreshCountCell = cell;
  
}



//查询，在此获取数据
- (void)QueryAndDisplay
{

    RefreshCountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", RefreshCnt];

    //DB Query
    NSLog(@"GreeksViewController: start!");
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"GreeksViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"GreeksViewController: SELECT: start!");
    
    
    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"runtimeinfo" condition:@"(ItemKey='Risk' and EntityType='A') or (ItemKey='Position' and ItemType='Position' and EntityType='A') or (ItemKey='TradeSum' and (ItemType='ATTradeQty' or ItemType='AHTradeQty') and EntityType='A')"];
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
        if([_field[@"ItemType"] isEqualToString:@"Position"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:0];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Position:" DetialText:value];
            continue;
        }
        if([_field[@"ItemType"] isEqualToString:@"ATTradeQty"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:0];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"AT Trade Qty:" DetialText:value];
            continue;
        }
        if([_field[@"ItemType"] isEqualToString:@"AHTradeQty"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:0];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"AH Trade Qty:" DetialText:value];
            continue;
        }
        
        typename=[typename substringFromIndex:5];
        typename=[typename stringByAppendingString:@":"];
        value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        [UIHelper SetTabelViewCellDetailText:TableView TitleText: typename DetialText:value];
        
        if([typename isEqualToString:@"Tata:"])
        {
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Thema:" DetialText:value];
        }
        
    }
    
    _field=[tasks objectAtIndex:0];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordDate:" DetialText:_field[@"RecordDate"]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordTime:" DetialText:[_field[@"RecordTime"] substringToIndex:8]];
    

    NSLog(@"GreeksViewController: SELECT: over!");

    [TableView reloadData];

    NSLog(@"AssetViewController: RefreshCnt=%d", RefreshCnt);

}





@end
