//
//  Aseet.m
//  iTSC
//
//  Created by tss on 2019/1/20.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AssetViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"


@implementation AssetViewController



@synthesize TableView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    RefreshCnt = 0;
    isTimerProcessing = false;
    
    [self InitTableViewCells];
    
    Switch_AutoRefresh = [self AppendSwitch];
    Switch_AutoRefresh.on = [TscConfig isAssetAutoRefresh];
    
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:5];
    UITableViewCell *cell = [TableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = _switch;
    return _switch;
}


//定时器处理函数
-(void)timerFired
{
    if([TscConfig isInBackground] == true) return;
    if([TscConfig isGlobalAutoRefresh] == false) return;
    if([TscConfig isAssetAutoRefresh] == false) return;
    
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
    [TscConfig setAssetAutoRefresh:([Switch_AutoRefresh isOn])];
}



////////////////////////////////////////////////////////////////////////////////////
-(void) InitTableViewCells
{
    [UIHelper ClearTabelViewCellText:TableView];
    
    UITableViewCell *cell;


    
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:0 TitleText:@"HisDate:" DetialText:@"-/-/-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:2 TitleText:@"AccountID:" DetialText:@"-"];

    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:0 TitleText:@"Risk Level (%):" DetialText:@"-"];
    cell.detailTextLabel.textColor = UIColor.magentaColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"Asset (Theory):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:2 TitleText:@"Asset (Market):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:3 TitleText:@"Asset Dif (Market-Theory):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:4 TitleText:@"Total Cash:" DetialText:@"-"];
    cell.detailTextLabel.textColor = UIColor.brownColor;
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:5 TitleText:@"Curr Margin:" DetialText:@"-"];

    
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:0 TitleText:@"Trade PNL (Marktet):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"Yd    PNL (Marktet):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:2 TitleText:@"Total PNL (Marktet):" DetialText:@"-"];
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:0 TitleText:@"Trade PNL (Theo):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:1 TitleText:@"Yd    PNL (Theo):" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:3 Row:2 TitleText:@"Total PNL (Theo):" DetialText:@"-"];
    
    
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:0 TitleText:@"TOR(%):" DetialText:@"-"];
    cell.detailTextLabel.textColor = UIColor.purpleColor;
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:1 TitleText:@"Trade Qty:" DetialText:@"-"];
    cell.detailTextLabel.textColor = UIColor.blueColor;
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:2 TitleText:@"Order Insert Qty:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:3 TitleText:@"Order Insert Cnt:" DetialText:@"-"];
    cell = [UIHelper SetTabelViewCellText:TableView Section:4 Row:4 TitleText:@"Qty Per Order:" DetialText:@"-"];
    cell.detailTextLabel.textColor = UIColor.blueColor;

    
    cell = [UIHelper SetTabelViewCellText:TableView Section:5 Row:0 TitleText:@"AutoRefresh:" DetialText:@""];
    cell = [UIHelper SetTabelViewCellText:TableView Section:5 Row:1 TitleText:@"RefreshCount:" DetialText:@"-"];
    
    RefreshCountCell = cell;
}



//查询，在此获取数据
- (void)QueryAndDisplay
{
    NSLog(@"AssetViewController: start!");
    
    
    [DBHelper Init];
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"AssetViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"AssetViewController: SELECT: start!");
    
    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"hisasset" condition:@"AccountID=1202"];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    
    NSUInteger count = tasks.count;
    NSLog(@"%@", [tasks objectAtIndex:count-1]);

    
    //显示
    NSDictionary  *_field=[tasks objectAtIndex:count-1];
    NSString* _sValue;
    float _fValue;

    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"HisDate:" DetialText:_field[@"HisDate"]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordTime:" DetialText:_field[@"RecordTime"]];
    _sValue = [NSString stringWithFormat:@"%d", [_field[@"AccountID"] intValue]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"AccountID:" DetialText:_sValue];
    
 
    [self DisplayCell:_field TitleName:@"Asset (Theory):" FieldName:@"AssetTheo" SetColor:false];
    [self DisplayCell:_field TitleName:@"Asset (Market):" FieldName:@"Asset" SetColor:false];
    [self DisplayCell:_field TitleName:@"Total Cash:" FieldName:@"TotalCash" SetColor:false];
    [self DisplayCell:_field TitleName:@"Curr Margin:" FieldName:@"CurrMargin" SetColor:false];

    _fValue=[_field[@"Asset"]  floatValue] - [_field[@"AssetTheo"]  floatValue];
    _sValue = [StringHelper fPositiveFormat:_fValue pointNumber:2];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Asset Dif (Market-Theory):" DetialText:_sValue];
    
    _fValue=[_field[@"RiskLevel"]  floatValue] *100;
    _sValue = [StringHelper fPositiveFormat:_fValue pointNumber:2];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Risk Level (%):" DetialText:_sValue];
    

    
    
    [self DisplayCell:_field TitleName:@"Trade PNL (Marktet):" FieldName:@"TradeMktPNL" SetColor:true];
    [self DisplayCell:_field TitleName:@"Yd    PNL (Marktet):" FieldName:@"YdMktPNL" SetColor:true];
    [self DisplayCell:_field TitleName:@"Total PNL (Marktet):" FieldName:@"TotalMktPNL" SetColor:true];

    [self DisplayCell:_field TitleName:@"Trade PNL (Theo):" FieldName:@"TradeTheoPNL" SetColor:true];
    [self DisplayCell:_field TitleName:@"Yd    PNL (Theo):" FieldName:@"YdTheoPNL" SetColor:true];
    [self DisplayCell:_field TitleName:@"Total PNL (Theo):" FieldName:@"TotalTheoPNL" SetColor:true];


    [self DisplayIntCell:_field TitleName:@"Trade Qty:" FieldName:@"TradeQty"];
    [self DisplayIntCell:_field TitleName:@"Order Insert Qty:" FieldName:@"OrderInsertQty"];
    [self DisplayIntCell:_field TitleName:@"Order Insert Cnt:" FieldName:@"OrderInsertCnt"];

    int _TradeQty=[_field[@"TradeQty"] intValue];
    int _OrderInsertQty=[_field[@"OrderInsertQty"] intValue];
    int _OrderInsertCnt = [_field[@"OrderInsertCnt"] intValue];


    //计算TOR
    if(_OrderInsertQty!=0)
    {
        _fValue=1.0*_TradeQty/_OrderInsertQty*100;
        _sValue = [NSString stringWithFormat:@"%0.2f", _fValue];
        [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"TOR(%):" DetialText:_sValue];
    }
    
    
    //计算Qty Per Order
    if(_OrderInsertCnt != 0)
    {
        _fValue=1.0*_OrderInsertQty/_OrderInsertCnt;
        _sValue = [NSString stringWithFormat:@"%0.2f", _fValue];
        [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Qty Per Order:" DetialText:_sValue];
    }
    
 
    NSLog(@"AssetViewController: SELECT: over!");

    RefreshCountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", RefreshCnt];
    [TableView reloadData];
    //[UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RefreshCount:" DetialText:[NSString stringWithFormat:@"%d", RefreshCnt]];

    NSLog(@"AssetViewController: RefreshCnt=%d", RefreshCnt);
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
