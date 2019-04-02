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
#import "TscConnections.h"

@implementation AssetViewController



@synthesize TableView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    RefreshCnt = 0;
    isTimerProcessing = false;
    
    [self InitTableViewCells:true];
    
    Switch_AutoRefresh = [self AppendSwitch];
    Switch_AutoRefresh.on = [TscConfig isAssetAutoRefresh];
    
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
    /*
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     [self.TableView reloadData];
     if ([self.TableView.refreshControl isRefreshing])
     [self.TableView.refreshControl endRefreshing];
     });
    */
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
    if([TscConfig isAssetAutoRefresh] == false) return;
    
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
    [TscConfig setAssetAutoRefresh:([Switch_AutoRefresh isOn])];
}



////////////////////////////////////////////////////////////////////////////////////
-(void) InitTableViewCells:(BOOL)vInitAll
{
    if(vInitAll)
        [UIHelper ClearTabelViewCellText:TableView];

    UITableViewCell *cell;


    //hisAsset
    if(vInitAll)
    {
        [UIHelper SetTabelViewCellText:TableView Section:0 Row:0 TitleText:@"HisDate:" DetialText:@"-/-/-"];
        [UIHelper SetTabelViewCellText:TableView Section:0 Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
        
        [UIHelper SetTabelViewCellText:TableView Section:1 Row:0 TitleText:@"Risk Level (%):" DetialText:@"-" Color:UIColor.magentaColor];
        [UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"Asset (Market):" DetialText:@"-"];
        [UIHelper SetTabelViewCellText:TableView Section:1 Row:2 TitleText:@"Asset (Theory):" DetialText:@"-"];
        [UIHelper SetTabelViewCellText:TableView Section:1 Row:3 TitleText:@"Asset Dif (Market-Theory):" DetialText:@"-"];
        [UIHelper SetTabelViewCellText:TableView Section:1 Row:4 TitleText:@"Available:" DetialText:@"-" Color:UIColor.brownColor];
        [UIHelper SetTabelViewCellText:TableView Section:1 Row:5 TitleText:@"Curr Margin:" DetialText:@"-"];
        
        
        [UIHelper SetTabelViewCellText:TableView Section:2 Row:0 TitleText:@"Marktet Trade PNL:" DetialText:@"-"];
        [UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"Marktet Yd PNL:" DetialText:@"-"];
        [UIHelper SetTabelViewCellText:TableView Section:2 Row:2 TitleText:@"Marktet Total PNL:" DetialText:@"-"];
        
        [UIHelper SetTabelViewCellText:TableView Section:3 Row:0 TitleText:@"Theo Trade PNL:" DetialText:@"-"];
        [UIHelper SetTabelViewCellText:TableView Section:3 Row:1 TitleText:@"Theo Yd PNL:" DetialText:@"-"];
        [UIHelper SetTabelViewCellText:TableView Section:3 Row:2 TitleText:@"Theo Total PNL:" DetialText:@"-"];
        
    }
    

    
    //Runtimeinfo
    [UIHelper SetTabelViewCellText:TableView Section:1 Row:6 TitleText:@"Total Margin:" DetialText:@"-"];
    
    [UIHelper SetTabelViewCellText:TableView Section:4 Row:0 TitleText:@"TPR:" DetialText:@"-" Color:UIColor.magentaColor];
    [UIHelper SetTabelViewCellText:TableView Section:4 Row:1 TitleText:@"TOR(%):" DetialText:@"-" Color:UIColor.purpleColor];
    [UIHelper SetTabelViewCellText:TableView Section:4 Row:2 TitleText:@"Position:" DetialText:@"-" Color:UIColor.blueColor];


    [UIHelper SetTabelViewCellText:TableView Section:5 Row:0 TitleText:@"Trade Edge:" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:TableView Section:5 Row:1 TitleText:@"Trade Qty:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:5 Row:2 TitleText:@"AT Trade Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:5 Row:3 TitleText:@"AT Trade Qty:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:5 Row:4 TitleText:@"AH Trade Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:5 Row:5 TitleText:@"AH Trade Qty:" DetialText:@"-"];

    
    [UIHelper SetTabelViewCellText:TableView Section:6 Row:0 TitleText:@"Excersize PNL:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:6 Row:1 TitleText:@"Market Close PNL:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:6 Row:2 TitleText:@"Theo Close PNL:" DetialText:@"-"];

    [UIHelper SetTabelViewCellText:TableView Section:7 Row:0 TitleText:@"Avg Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:7 Row:1 TitleText:@"Positive Avg Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:7 Row:2 TitleText:@"Negative Avg Edge:" DetialText:@"-"];
    
    [UIHelper SetTabelViewCellText:TableView Section:7 Row:3 TitleText:@"Smoothed Basis:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:7 Row:4 TitleText:@"Smoothed Vol:" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:TableView Section:7 Row:5 TitleText:@"U %:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:7 Row:6 TitleText:@"U LP:" DetialText:@"-"];

    
    [UIHelper SetTabelViewCellText:TableView Section:8 Row:0 TitleText:@"Server ID:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:8 Row:1 TitleText:@"MD Time:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:8 Row:2 TitleText:@"MD Date:" DetialText:@"-"];
    
    if(vInitAll)
    {
        [UIHelper SetTabelViewCellText:TableView Section:8 Row:3 TitleText:@"AccountID:" DetialText:@"-"];

        cell = [UIHelper SetTabelViewCellText:TableView Section:9 Row:0 TitleText:@"RefreshCount:" DetialText:@"-"];
        RefreshCountCell = cell;
        cell = [UIHelper SetTabelViewCellText:TableView Section:9 Row:1 TitleText:@"AutoRefresh:" DetialText:@""];
        RefreshSwitchCell = cell;
    }
    

}



//查询，在此获取数据
- (void)QueryAndDisplay
{
    NSLog(@"AssetViewController: start!");
    
    RefreshCountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", RefreshCnt];
    NSLog(@"AssetViewController: RefreshCnt=%d", RefreshCnt);
    
    //Display
    [self _DisplayHisAsset];
    [self _DisplayRuntimeInfo];
    
    //ServerName
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Server ID:" DetialText:TscConnections.CurrentConnectionKey];

    //reloadData
    [TableView reloadData];
}


//_DisplayHisAsset
-(void) _DisplayHisAsset
{
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"AssetViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"AssetViewController: SELECT: start!");
    
    //SELECT
    NSString* _condstr = [TscConnections getCurrentConnection].AccountID;
    _condstr = [_condstr stringByAppendingString:@" order by HisDate DESC limit 1"];
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"tsshis.hisasset" condition:_condstr];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    
    NSUInteger count = tasks.count;
    NSLog(@"%@", [tasks objectAtIndex:count-1]);
    if(count<=0)
        return;
    
    //显示
    NSDictionary  *_field=[tasks objectAtIndex:count-1];
    NSString* _sValue;
    float _fValue;
    
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"HisDate:" DetialText:_field[@"HisDate"]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordTime:" DetialText:[_field[@"RecordTime"] substringToIndex:8]];
    _sValue = [NSString stringWithFormat:@"%d", [_field[@"AccountID"] intValue]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"AccountID:" DetialText:_sValue];
    
    
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Asset (Theory):" FieldName:@"AssetTheo" SetColor:false];
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Asset (Market):" FieldName:@"Asset" SetColor:false];
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Available:" FieldName:@"Available" SetColor:false];
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Curr Margin:" FieldName:@"CurrMargin" SetColor:false];
    
    _fValue=[_field[@"Asset"]  floatValue] - [_field[@"AssetTheo"]  floatValue];
    _sValue = [StringHelper fPositiveFormat:_fValue pointNumber:2];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Asset Dif (Market-Theory):" DetialText:_sValue];
    
    _fValue = [_field[@"RiskLevel"]  floatValue] *100;
    _sValue = [StringHelper fPositiveFormat:_fValue pointNumber:2]; _sValue = [_sValue stringByAppendingString:@"%"];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Risk Level (%):" DetialText:_sValue];
    
    
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Marktet Trade PNL:" FieldName:@"TradeMktPNL" SetColor:true];
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Marktet Yd PNL:" FieldName:@"YdMktPNL" SetColor:true];
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Marktet Total PNL:" FieldName:@"TotalMktPNL" SetColor:true];
    
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Theo Trade PNL:" FieldName:@"TradeTheoPNL" SetColor:true];
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Theo Yd PNL:" FieldName:@"YdTheoPNL" SetColor:true];
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Theo Total PNL:" FieldName:@"TotalTheoPNL" SetColor:true];
    
    

    NSLog(@"AssetViewController: SELECT: over!");
}


//_DisplayRuntimeInfo
-(void) _DisplayRuntimeInfo
{
 
    
    //SELECT
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"AssetViewController: Init: queryContext==nil!");
        return;
    }
    
    NSString* _condstr = @"( ";

    _condstr=[_condstr stringByAppendingString:@" ( ItemKey='Position' and ItemType='Position' )"];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='Capital' and ItemType='TotalMargin' )"];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='TradePosRatio' or ItemType='OrderTradeRatio' )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='TradeEdge' or ItemType='TradeQty' )"];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='ATTradeEdge' or ItemType='ATTradeQty' or ItemType='AHTradeEdge' or ItemType='AHTradeQty' )"];

    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='ExecPNL' or ItemType='CloseTheoryPNL' or ItemType='CloseMarketPNL' )"];

    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='Edge' )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='U' and (ItemType='LP' or ItemType='ChangePercentage') )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='SmoothedWingPara' and (ItemType='Vol') )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='SmoothedBasis' ) "];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='MD' )"];
    
    _condstr=[_condstr stringByAppendingString:@" ) and EntityType='A'"];


    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"runtimeinfo" condition:_condstr];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    //清除原显示
    [self InitTableViewCells:false];
    
    NSInteger count = tasks.count;
    if(count <= 0)
        return;
    
    
    //显示
    NSDictionary  *_field;
    float _fValue;
    NSString* value;
    UITableViewCell *cell;
    
    for( int i=0; i<count; i++)
    {
        _field=[tasks objectAtIndex:i];
        NSLog(@"%@", _field);
        
        if([_field[@"ItemType"] isEqualToString:@"TotalMargin"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Total Margin:" FieldName:@"ItemValue" SetColor:false];
            continue;
        }
        

        if([_field[@"ItemType"] isEqualToString:@"OrderTradeRatio"])
        {
            _fValue=[_field[@"ItemValue"] floatValue]*100;
            value = [StringHelper fPositiveFormat:_fValue pointNumber:2]; value = [value stringByAppendingString:@"%"];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"TOR(%):" DetialText:value];
            continue;
        }
        if([_field[@"ItemType"] isEqualToString:@"TradePosRatio"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"TPR:" FieldName:@"ItemValue" SetColor:false];
            continue;
        }
        if([_field[@"ItemType"] isEqualToString:@"Position"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Position:" FieldName:@"ItemValue"];
            continue;
        }
        
        
        if([_field[@"ItemType"] isEqualToString:@"TradeEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Trade Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([_field[@"ItemType"] isEqualToString:@"TradeQty"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Trade Qty:" FieldName:@"ItemValue"];
            continue;
        }
        
        if([_field[@"ItemType"] isEqualToString:@"ATTradeEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"AT Trade Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }        if([_field[@"ItemType"] isEqualToString:@"ATTradeQty"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"AT Trade Qty:" FieldName:@"ItemValue"];
            continue;
        }
        
        if([_field[@"ItemType"] isEqualToString:@"AHTradeEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"AH Trade Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([_field[@"ItemType"] isEqualToString:@"AHTradeQty"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"AH Trade Qty:" FieldName:@"ItemValue"];
            continue;
        }


        //PNL
        if([_field[@"ItemType"] isEqualToString:@"ExecPNL"])
        {
           [UIHelper DisplayCell:TableView Field:_field TitleName:@"Excersize PNL:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([_field[@"ItemType"] isEqualToString:@"CloseTheoryPNL"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Theo Close PNL:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([_field[@"ItemType"] isEqualToString:@"CloseMarketPNL"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Market Close PNL:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        
        
        //AvgEdge
        if([_field[@"ItemType"] isEqualToString:@"AvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Avg Edge:" FieldName:@"ItemValue" SetColor:false];
            continue;
        }
        if([_field[@"ItemType"] isEqualToString:@"PAvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Positive Avg Edge:" FieldName:@"ItemValue" SetColor:false];
             continue;
        }
        if([_field[@"ItemType"] isEqualToString:@"NAvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Negative Avg Edge:" FieldName:@"ItemValue" SetColor:false];
             continue;
        }
        
        
        
        //U
        if([_field[@"ItemKey"] isEqualToString:@"U"])
        {
            if([_field[@"ItemType"] isEqualToString:@"LP"])
            {
                _fValue=[_field[@"ItemValue"] floatValue];
                value = [StringHelper fPositiveFormat:_fValue pointNumber:4];
                [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"U LP:" DetialText:value];
                continue;
            }
            if([_field[@"ItemType"] isEqualToString:@"ChangePercentage"])
            {
                _fValue=[_field[@"ItemValue"] floatValue];
                value = [StringHelper fPositiveFormat:_fValue pointNumber:2]; value = [value stringByAppendingString:@"%"];
                cell=[UIHelper SetTabelViewCellDetailText:TableView TitleText: @"U %:" DetialText:value];
                if(_fValue>0)
                    cell.detailTextLabel.textColor=UIColor.purpleColor;
                else
                    cell.detailTextLabel.textColor=UIColor.darkGrayColor;
                continue;
            }
        }
 
        
        //SmoothedBasis
        if([_field[@"ItemType"] isEqualToString:@"SmoothedBasis"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Smoothed Basis:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        
        
        //SmoothedWingPara
        if([_field[@"ItemKey"] isEqualToString:@"SmoothedWingPara"])
        {
            if([_field[@"ItemType"] isEqualToString:@"Vol"])
            {
                _fValue=[_field[@"ItemValue"] floatValue]*100;
                value = [StringHelper fPositiveFormat:_fValue pointNumber:2]; value = [value stringByAppendingString:@"%"];
                [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Smoothed Vol:" DetialText:value];
                continue;
            }
        }
        
        
        //MD
        if([_field[@"ItemKey"] isEqualToString:@"MD"])
        {
            if([_field[@"ItemType"] isEqualToString:@"Date"])
            {
                [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"MD Date:" DetialText:_field[@"ItemValue"]];
                continue;
            }
            if([_field[@"ItemType"] isEqualToString:@"Time"])
            {
                [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"MD Time:" DetialText:_field[@"ItemValue"]];
                continue;
            }
        }
        
        
    }
}


@end
