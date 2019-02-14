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

    [self InitTableViewCells:true];
 
    Switch_AutoRefresh = [self AppendSwitch];
    Switch_AutoRefresh.on = [TscConfig isGreekAutoRefresh];
    
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
-(void) InitTableViewCells:(BOOL)vInitAll
{
    if(vInitAll)
        [UIHelper ClearTabelViewCellText:TableView];
    
    UITableViewCell *cell;
    
    UIFont* _font = [UIFont boldSystemFontOfSize:12];
    
    [UIHelper SetTabelViewCellText:TableView Section:0 Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    [UIHelper SetTabelViewCellText:TableView Section:0 Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    


    [UIHelper SetTabelViewCellText:TableView Section:1 Row:0 TitleText:@"Delta:" DetialText:@"-" Font:_font];
    [UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"Vega:" DetialText:@"-" Font:_font];
    [UIHelper SetTabelViewCellText:TableView Section:1 Row:2 TitleText:@"Theta:" DetialText:@"-" Font:_font];

    
    [UIHelper SetTabelViewCellText:TableView Section:2 Row:0 TitleText:@"Gamma:" DetialText:@"-" Font:_font];
    [UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"Charm:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:2 Row:2 TitleText:@"Vanna:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:2 Row:3 TitleText:@"Volga:" DetialText:@"-" Font:_font];
    [UIHelper SetTabelViewCellText:TableView Section:2 Row:4 TitleText:@"Veta:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:2 Row:5 TitleText:@"Thema:" DetialText:@"-" Font:_font];
    
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:0 TitleText:@"Color:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:1 TitleText:@"Speed:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:2 TitleText:@"Zomma:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:3 TitleText:@"Ultima:" DetialText:@"-"];
    
    [UIHelper SetTabelViewCellText:TableView Section:4 Row:0 TitleText:@"SRR:" DetialText:@"-" Font:_font];
    [UIHelper SetTabelViewCellText:TableView Section:4 Row:1 TitleText:@"SLR:" DetialText:@"-" Font:_font];
    [UIHelper SetTabelViewCellText:TableView Section:4 Row:2 TitleText:@"PCR:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:4 Row:3 TitleText:@"CCR:" DetialText:@"-"];
    
    
    [UIHelper SetTabelViewCellText:TableView Section:5 Row:0 TitleText:@"Position:" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:TableView Section:5 Row:1 TitleText:@"Trade Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:5 Row:2 TitleText:@"Trade Qty:" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:TableView Section:5 Row:3 TitleText:@"AT Trade Qty:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:5 Row:4 TitleText:@"AH Trade Qty:" DetialText:@"-"];

    [UIHelper SetTabelViewCellText:TableView Section:6 Row:0 TitleText:@"Marktet Total PNL:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:6 Row:1 TitleText:@"Theo Total PNL:" DetialText:@"-"];

    [UIHelper SetTabelViewCellText:TableView Section:7 Row:0 TitleText:@"Avg Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:7 Row:1 TitleText:@"Smoothed Basis:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:7 Row:2 TitleText:@"Smoothed Vol:" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:TableView Section:7 Row:3 TitleText:@"U LP:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:7 Row:4 TitleText:@"U %:" DetialText:@"-"];

    
    if(vInitAll)
    {
        cell = [UIHelper SetTabelViewCellText:TableView Section:8 Row:0 TitleText:@"AutoRefresh:" DetialText:@""];
        RefreshSwitchCell = cell;
        cell = [UIHelper SetTabelViewCellText:TableView Section:8 Row:1 TitleText:@"RefreshCount:" DetialText:@"-"];
        RefreshCountCell = cell;
    }
    
  
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
    NSString* _condstr = @"(";
    
    _condstr=[_condstr stringByAppendingString:@" (ItemKey='Risk')"];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='Position' and ItemType='Position' )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='TradeSum' and (ItemType='TradeQty' or ItemType='ATTradeQty' or ItemType='AHTradeQty' or ItemType='TradeEdge') )"];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='PNL' and (ItemType='TotalPNL_Mkt' or ItemType='TotalPNL_Theo') )"];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='AvgEdge' )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='U' and (ItemType='LP' or ItemType='ChangePercentage') )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='SmoothedWingPara' and (ItemType='Vol') )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='SmoothedBasis' ) "];
    
    _condstr=[_condstr stringByAppendingString:@" ) and EntityType='A'"];
    
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"runtimeinfo" condition:_condstr];
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
    float _fValue;
    NSString* value;
    UITableViewCell *cell;
    
    for( int i=0; i<count; i++)
    {
        _field=[tasks objectAtIndex:i];
        NSLog(@"%@", _field);
        

        typename=_field[@"ItemType"];
        
        if([typename isEqualToString:@"Position"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:0];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Position:" DetialText:value];
            continue;
        }
        if([typename isEqualToString:@"TradeEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Trade Edge:" FieldName:@"ItemValue"  SetColor:true];
            continue;
        }
        
        if([typename isEqualToString:@"TradeQty"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Trade Qty:" FieldName:@"ItemValue"];
            continue;
        }

        if([typename isEqualToString:@"ATTradeQty"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:0];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"AT Trade Qty:" DetialText:value];
            continue;
        }
        if([typename isEqualToString:@"AHTradeQty"])
        {
            value=[StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:0];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"AH Trade Qty:" DetialText:value];
            continue;
        }

        
        //PNL
        if([_field[@"ItemKey"] isEqualToString:@"PNL"])
        {
            if([typename isEqualToString:@"TotalPNL_Mkt"])
            {
                [UIHelper DisplayCell:TableView Field:_field TitleName:@"Marktet Total PNL:" FieldName:@"ItemValue" SetColor:true];
                continue;
            }
            if([typename isEqualToString:@"TotalPNL_Theo"])
            {
                [UIHelper DisplayCell:TableView Field:_field TitleName:@"Theo Total PNL:" FieldName:@"ItemValue" SetColor:true];
                continue;
            }
        }
        
        
        //U
        if([typename isEqualToString:@"AvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Avg Edge:" FieldName:@"ItemValue" SetColor:false];
            continue;
        }
        
        if([_field[@"ItemKey"] isEqualToString:@"U"])
        {
            if([typename isEqualToString:@"LP"])
            {
                _fValue=[_field[@"ItemValue"] floatValue];
                value = [StringHelper fPositiveFormat:_fValue pointNumber:4];
                [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"U LP:" DetialText:value];
                continue;
            }
            if([typename isEqualToString:@"ChangePercentage"])
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
        
        if([typename isEqualToString:@"SmoothedBasis"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Smoothed Basis:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        
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
        
        
        
        
        //Risk Field
        if([_field[@"ItemKey"] isEqualToString:@"Risk"])
        {
            NSString* titlename = [typename substringFromIndex:5]; titlename = [titlename stringByAppendingString:@":"];
            if([titlename isEqualToString:@"Tata:"]) titlename = @"Thema:";
            
            [UIHelper DisplayCell:TableView Field:_field TitleName:titlename FieldName:@"ItemValue" SetColor:true];
        }
   
    } //for over
    
    
    
    _field = [tasks objectAtIndex:0];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordDate:" DetialText:_field[@"RecordDate"]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordTime:" DetialText:[_field[@"RecordTime"] substringToIndex:8]];
    

    NSLog(@"GreeksViewController: SELECT: over!");

    [TableView reloadData];

    NSLog(@"AssetViewController: RefreshCnt=%d", RefreshCnt);

}





@end
