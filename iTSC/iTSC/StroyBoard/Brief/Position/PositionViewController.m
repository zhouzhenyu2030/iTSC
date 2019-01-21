//
//  PositionViewController.m
//  iTSC
//
//  Created by tss on 2019/1/21.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PositionViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"


@implementation PositionViewController



@synthesize TableView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    RefreshCnt = 0;
    isTimerProcessing = false;
    
    [self InitTableViewCells];
    
    Switch_AutoRefresh = [self AppendSwitch];
    Switch_AutoRefresh.on = [TscConfig isPositionAutoRefresh];
    
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
    if([TscConfig isPositionAutoRefresh] == false) return;
    
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
    [TscConfig setPositionAutoRefresh:([Switch_AutoRefresh isOn])];
}



////////////////////////////////////////////////////////////////////////////////////
-(void) InitTableViewCells
{
    [UIHelper ClearTabelViewCellText:TableView];
    
    UITableViewCell *cell;

    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:0 TitleText:@"Position (Yd):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"Long Position (Yd):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:2 TitleText:@"Short Position (Yd):" DetialText:@"-"];

    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:0 TitleText:@"Position:" DetialText:@"-"];
    cell.detailTextLabel.textColor = UIColor.blueColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"Long Position:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:2 TitleText:@"Short Position:" DetialText:@"-"];

    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:0 TitleText:@"Frozen:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:1 TitleText:@"Available:" DetialText:@"-"];
 
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:0 TitleText:@"AutoRefresh:" DetialText:@""];
    RefreshSwitchCell = cell;
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:1 TitleText:@"RefreshCount:" DetialText:@"-"];
    RefreshCountCell = cell;
}



//查询，在此获取数据
- (void)QueryAndDisplay
{

    RefreshCountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", RefreshCnt];

    //DB Query
    NSLog(@"PositionViewController: start!");
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"PositionViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"PositionViewController: SELECT: start!");
    
    
    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"runtimeinfo" condition:@"ItemKey='Position' and EntityType='A'"];
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
        
        if([typename isEqualToString:@"YdPosition"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Position (Yd):" FieldName:@"ItemValue"];
        if([typename isEqualToString:@"YdLongPosition"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Long Position (Yd):" FieldName:@"ItemValue"];
        if([typename isEqualToString:@"YdShortPosition"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Short Position (Yd):" FieldName:@"ItemValue"];
        
        if([typename isEqualToString:@"Position"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Position:" FieldName:@"ItemValue"];
        if([typename isEqualToString:@"LongPosition"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Long Position:" FieldName:@"ItemValue"];
        if([typename isEqualToString:@"ShortPosition"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Short Position:" FieldName:@"ItemValue"];
        
        if([typename isEqualToString:@"Frozen"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Frozen:" FieldName:@"ItemValue"];
        if([typename isEqualToString:@"Available"])
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Available:" FieldName:@"ItemValue"];
    }
    
    _field=[tasks objectAtIndex:0];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordDate:" DetialText:_field[@"RecordDate"]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordTime:" DetialText:_field[@"RecordTime"]];
    
    
    NSLog(@"PositionViewController: SELECT: over!");
    
    [TableView reloadData];
    
    
    NSLog(@"PositionViewController: RefreshCnt=%d", RefreshCnt);
}


@end
