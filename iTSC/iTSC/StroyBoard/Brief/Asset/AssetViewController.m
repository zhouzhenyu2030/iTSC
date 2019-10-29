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


NSNumberFormatter *_Asset_numberFormatter;
UIFont* _bold_font;


//////////////////////// viewDidLoad ////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _Asset_numberFormatter = [[NSNumberFormatter alloc] init];
    _bold_font = [UIFont boldSystemFontOfSize:12];
    RefreshCnt = 0;
    isTimerProcessing = false;
    
    [self InitTableViewCells];
    
    RefreshTimerElpasedSeconds = 0;
    if(myTimer==nil)
        myTimer  =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
    [self setupRefresh];
}

//////////////////////// 设置下拉刷新 ////////////////////////
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
    [self ResetTableViewCells];
    RefreshCnt = 1;
    [self QueryAndDisplay];
    [self.TableView reloadData];
    [refreshControl endRefreshing];
}




//////////////////////// 定时器处理函数 ////////////////////////
-(void)timerFired
{
    if([TscConfig isInBackground] == true) return;
    if([TscConfig isGlobalAutoRefresh] == false) return;
    //if([TscConfig isAssetAutoRefresh] == false) return;
    
    if(isTimerProcessing) return;
    
    RefreshTimerElpasedSeconds++;
    if(RefreshTimerElpasedSeconds<TscConfig.RefreshSeconds) return;
    

    //display
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
    [self StartTimer];
}


//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    [self StopTimer];
}


////////////////////////////////////////////////////////////////////////////////////////////
// InitTableViewCells
////////////////////////////////////////////////////////////////////////////////////////////
-(void) InitTableViewCells
{
    TableView.rowHeight = 18;
    [self ResetTableViewCells];
}



-(void) ResetTableViewCells
{
 
    int _iS = 0;
    
    //hisAsset
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:0 TitleText:@"Server ID:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:1 TitleText:@"MD Time:" DetialText:@"-"];
    
    //MD info
    _iS++;
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:0 TitleText:@"U LP:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:1 TitleText:@"U %:" DetialText:@"-" Font:_bold_font];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:2 TitleText:@"Smoothed Basis:" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:3 TitleText:@"Smoothed Vol:" DetialText:@"-" Color:UIColor.blueColor];
    
    //Asset & Position
    _iS++;
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:0 TitleText:@"Risk Level (%):" DetialText:@"-" Color:UIColor.magentaColor];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:1 TitleText:@"NV (Theory):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:2 TitleText:@"Asset (Market):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:3 TitleText:@"Asset (Theory):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:4 TitleText:@"Available:" DetialText:@"-" Color:UIColor.brownColor];
            //From Runtimeinfo
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:5 TitleText:@"Total Margin:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:6 TitleText:@"Position:" DetialText:@"-" Color:UIColor.blackColor Font:_bold_font];

    //Risk
    _iS++;
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:0 TitleText:@"Delta:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:1 TitleText:@"Vega:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:2 TitleText:@"SRR:" DetialText:@"-"];

    //Market PNL
    _iS++;
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:0 TitleText:@"Marktet Trade PNL:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:1 TitleText:@"Marktet Yd PNL:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:2 TitleText:@"Marktet Total PNL:" DetialText:@"-"];
    
    //Theo PNL
    _iS++;
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:0 TitleText:@"Theo Trade PNL:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:1 TitleText:@"Theo Yd PNL:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:2 TitleText:@"Theo Total PNL:" DetialText:@"-"];

    
    //OT & Ratio
    _iS++;
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:0 TitleText:@"Trade Edge:" DetialText:@"-" Color:UIColor.blueColor Font:_bold_font];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:1 TitleText:@"Trade Qty:" DetialText:@"-" Color:UIColor.blackColor Font:_bold_font];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:2 TitleText:@"Order Cnt:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:3 TitleText:@"TPR:" DetialText:@"-" Color:UIColor.magentaColor];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:4 TitleText:@"OCR:" DetialText:@"-" Color:UIColor.orangeColor];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:5 TitleText:@"TOR(%):" DetialText:@"-" Color:UIColor.purpleColor];

    //Auto
    _iS++;
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:0 TitleText:@"AT Trade Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:1 TitleText:@"AT Trade Qty:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:2 TitleText:@"AH Trade Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:3 TitleText:@"AH Trade Qty:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:4 TitleText:@"AL Trade Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:5 TitleText:@"AL Trade Qty:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:6 TitleText:@"AQ Trade Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:7 TitleText:@"AQ Trade Qty:" DetialText:@"-"];

    //PNL
    _iS++;
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:0 TitleText:@"Excersize PNL:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:1 TitleText:@"Market Close PNL:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:2 TitleText:@"Theo Close PNL:" DetialText:@"-"];
    
    //Misc
    _iS++;
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:0 TitleText:@"Avg Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:1 TitleText:@"Positive Avg Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:2 TitleText:@"Negative Avg Edge:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:3 TitleText:@"Asset Dif (Market-Theory):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:4 TitleText:@"Curr Margin:" DetialText:@"-"];
    
 
    //date time
    _iS++;
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:0 TitleText:@"MD Date:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:1 TitleText:@"HisDate:" DetialText:@"-/-/-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:2 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:3 TitleText:@"AccountID:" DetialText:@"-"];
 

    //refresh
    _iS++;
    [UIHelper SetTabelViewCellText:TableView Section:_iS Row:0 TitleText:@"RefreshCount:" DetialText:@"-"];
 
}





////////////////////////////////////////////////////////////////////////////////////////////
//查询，在此获取数据
////////////////////////////////////////////////////////////////////////////////////////////
- (void)QueryAndDisplay
{
    //重置原显示
    [self ResetTableViewCells];
    
   
    //ServerName
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Server ID:" DetialText:DBHelper.CurrentConnectionKey];
    
    //Display
    if([DBHelper BeginQuery])
    {
        [self _DisplayAsset];
        [self _DisplayRuntimeInfo];
        [DBHelper EndQuery];
    }
    
    //RefreshCnt
    [UIHelper SetTabelViewCellDetailText:TableView TitleText:@"RefreshCount:" DetialText:[NSString stringWithFormat:@"%d", RefreshCnt]];
    
    //reloadData
    [TableView reloadData];
}





////////////////////////////////////////////////////////////////////////////////////////////
//_DisplayAsset
////////////////////////////////////////////////////////////////////////////////////////////
-(void) _DisplayAsset
{
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];

    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"tss.asset" condition:@" TypeID='T'"];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    if(error!=nil)
        return;
    
    NSUInteger count = tasks.count;
    if(count <= 0)
        return;
    
    //显示
    NSDictionary  *_field=[tasks objectAtIndex:count - 1];
    NSString* _sValue;
    float _fValue;
    
    _fValue = [_field[@"NetValueTheory"]  floatValue];
    _sValue = [StringHelper fPositiveFormat:_fValue pointNumber:4];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"NV (Theory):" DetialText:_sValue];
    
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Asset (Theory):" FieldName:@"AssetTheory" SetColor:false];
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Asset (Market):" FieldName:@"AssetLP" SetColor:false];
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Available:" FieldName:@"TotalCash" SetColor:false];
    [UIHelper DisplayCell:TableView Field:_field TitleName:@"Curr Margin:" FieldName:@"TotalMargin" SetColor:false];
    
    _fValue=[_field[@"AssetLP"]  floatValue] - [_field[@"AssetTheory"]  floatValue];
    _sValue = [StringHelper fPositiveFormat:_fValue pointNumber:2];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Asset Dif (Market-Theory):" DetialText:_sValue];
    
    _fValue = [_field[@"RiskLevelTheory"]  floatValue] *100;
    _sValue = [StringHelper fPositiveFormat:_fValue pointNumber:2]; _sValue = [_sValue stringByAppendingString:@"%"];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Risk Level (%):" DetialText:_sValue];
    
}



////////////////////////////////////////////////////////////////////////////////////////////
//_DisplayRuntimeInfo
////////////////////////////////////////////////////////////////////////////////////////////
-(void) _DisplayRuntimeInfo
{
 
    
    //SELECT
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"AssetViewController: DisplayRuntimeInfo: queryContext==nil!");
        return;
    }
    
    NSString* _condstr = @"( ";

    _condstr=[_condstr stringByAppendingString:@" ( ItemKey='Position' and ItemType='Position' )"];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='Capital' and ItemType='TotalMargin' )"];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='Risk' )"];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='OrderInsertCnt' )"];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='TradePosRatio' or ItemType='OrderTradeRatio' or ItemType='OCR' )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='TradeEdge' or ItemType='TradeQty' )"];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='ATTradeEdge' or ItemType='ATTradeQty') "];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='ALTradeEdge' or ItemType='ALTradeQty' )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='AHTradeEdge' or ItemType='AHTradeQty' )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='AQTradeEdge' or ItemType='AQTradeQty' )"];

    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='PNL' and EntityType='A' )"];

    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='Edge' )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='U' and (ItemType='LP' or ItemType='ChangePercentage') )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='SmoothedWingPara' and (ItemType='Vol') )"];
    _condstr=[_condstr stringByAppendingString:@" or ( ItemType='SmoothedBasis' ) "];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='MD' )"];
    
    _condstr=[_condstr stringByAppendingString:@" ) and EntityType='A'"];


    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"runtimeinfo" condition:_condstr];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
 
    NSInteger count = tasks.count;
    if(count <= 0)
        return;
    
    
    //显示
    NSDictionary  *_field;
    NSString* _typename;
    float _fValue;
    NSString* value;
    UITableViewCell *cell;
    
    for( int i=0; i<count; i++)
    {
        _field=[tasks objectAtIndex:i];
        
        _typename=_field[@"ItemType"];

        
        
        
          //U
        if([_field[@"ItemKey"] isEqualToString:@"U"])
        {
            //
            if([_typename isEqualToString:@"LP"])
            {
                _fValue=[_field[@"ItemValue"] floatValue];
                //value = [StringHelper fPositiveFormat:_fValue pointNumber:2];
                
                //价格表示方式: nnn. nn nn
                int _ivalue =(int)(_fValue);
                [_Asset_numberFormatter setPositiveFormat:@",###;"];
                value = [_Asset_numberFormatter stringFromNumber:[NSNumber numberWithFloat:_ivalue]];

                _ivalue=_fValue*100 - _ivalue*100;
                value = [value stringByAppendingString:[NSString stringWithFormat: @". %02d", _ivalue]];
                
                _ivalue=(int)(_fValue * 100);
                _ivalue=_fValue*10000 - _ivalue*100;
                value = [value stringByAppendingString:[NSString stringWithFormat: @" %02d", _ivalue]];
 
                [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"U LP:" DetialText:value];
                continue;
            }
            
            //
            if([_typename isEqualToString:@"ChangePercentage"])
            {
                _fValue=[_field[@"ItemValue"] floatValue];
                value = [StringHelper fPositiveFormat:_fValue pointNumber:2]; value = [value stringByAppendingString:@"%"];
                cell=[UIHelper SetTabelViewCellDetailText:TableView TitleText: @"U %:" DetialText:value];
                if(_fValue > 0)
                {
                    //酸橙绿(50,205,50)-稍暗，(50,215,50); 嫩绿色(0,255,127)-过亮；绿土(56,94,15)-颜色过暗；森林绿(34,139,34)-较绿土亮，但亮度仍不足;
                    cell.detailTextLabel.textColor = [UIColor colorWithRed:50/255.0f green:215/255.0f blue:50/255.0f alpha:1.0f];
                }
                if(_fValue < 0)
                {
                    //棕色(128,42,42);  印度红(176,23,31);  cyanColor:亮蓝色
                    cell.detailTextLabel.textColor = [UIColor colorWithRed:176/255.0f green:23/255.0f blue:31/255.0f alpha:1.0f];
                }
                if(_fValue == 0)
                {
                    cell.detailTextLabel.textColor = UIColor.blackColor;
                }
            }
            
            //
            continue;
            
        }
        
        
        
        //SmoothedBasis
        if([_typename isEqualToString:@"SmoothedBasis"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Smoothed Basis:" FieldName:@"ItemValue" SetColor:false];
            continue;
        }
        
        
        //SmoothedWingPara
        if([_field[@"ItemKey"] isEqualToString:@"SmoothedWingPara"])
        {
            if([_typename isEqualToString:@"Vol"])
            {
                _fValue=[_field[@"ItemValue"] floatValue]*100;
                value = [StringHelper fPositiveFormat:_fValue pointNumber:2]; value = [value stringByAppendingString:@"%"];
                [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"Smoothed Vol:" DetialText:value];
                continue;
            }
        }
        
        
        
        
        
        //Margin
        if([_typename isEqualToString:@"TotalMargin"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Total Margin:" FieldName:@"ItemValue" SetColor:false];
            continue;
        }
        
        //Risk Field
        if([_field[@"ItemKey"] isEqualToString:@"Risk"])
        {
            NSString* titlename = [_typename substringFromIndex:5]; titlename = [titlename stringByAppendingString:@":"];
            if([titlename isEqualToString:@"Tata:"]) titlename = @"Thema:";
            
            [UIHelper DisplayCell:TableView Field:_field TitleName:titlename FieldName:@"ItemValue" SetColor:false];
            
            continue;
        }
        

        //Ratio
        if([_typename isEqualToString:@"OrderTradeRatio"])
        {
            _fValue=[_field[@"ItemValue"] floatValue]*100;
            value = [StringHelper fPositiveFormat:_fValue pointNumber:2]; value = [value stringByAppendingString:@"%"];
            [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"TOR(%):" DetialText:value];
            continue;
        }
        if([_typename isEqualToString:@"OCR"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"OCR:" FieldName:@"ItemValue" SetColor:false];
            continue;
        }
        if([_typename isEqualToString:@"TradePosRatio"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"TPR:" FieldName:@"ItemValue" SetColor:false];
            continue;
        }
        
        
        //Position
        if([_typename isEqualToString:@"Position"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Position:" FieldName:@"ItemValue"];
            continue;
        }
        
        
        //Order
        if([_typename isEqualToString:@"OrderInsertCnt"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Order Cnt:" FieldName:@"ItemValue"];
            continue;
        }

        //Trade
        if([_typename isEqualToString:@"TradeQty"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Trade Qty:" FieldName:@"ItemValue"];
            continue;
        }

        
       
        
        //Auto Trade Qty Edge
        if([_typename isEqualToString:@"TradeEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Trade Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        
        
        if([_typename isEqualToString:@"ATTradeEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"AT Trade Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([_typename isEqualToString:@"ATTradeQty"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"AT Trade Qty:" FieldName:@"ItemValue"];
            continue;
        }
  
        
        if([_typename isEqualToString:@"ALTradeEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"AL Trade Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([_typename isEqualToString:@"ALTradeQty"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"AL Trade Qty:" FieldName:@"ItemValue"];
            continue;
        }
        
        

        if([_typename isEqualToString:@"AHTradeEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"AH Trade Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([_typename isEqualToString:@"AHTradeQty"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"AH Trade Qty:" FieldName:@"ItemValue"];
            continue;
        }
        
        if([_typename isEqualToString:@"AQTradeEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"AQ Trade Edge:" FieldName:@"ItemValue" SetColor:true];
            continue;
        }
        if([_typename isEqualToString:@"AQTradeQty"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"AQ Trade Qty:" FieldName:@"ItemValue"];
            continue;
        }

  

        //PNL
        if([_field[@"ItemKey"] isEqualToString:@"PNL"])
        {
            if([_typename isEqualToString:@"ExecPNL"])
            {
                [UIHelper DisplayCell:TableView Field:_field TitleName:@"Excersize PNL:" FieldName:@"ItemValue" SetColor:true];
                continue;
            }
            if([_typename isEqualToString:@"CloseTheoryPNL"])
            {
                [UIHelper DisplayCell:TableView Field:_field TitleName:@"Theo Close PNL:" FieldName:@"ItemValue" SetColor:true];
                continue;
            }
            if([_typename isEqualToString:@"CloseMarketPNL"])
            {
                [UIHelper DisplayCell:TableView Field:_field TitleName:@"Market Close PNL:" FieldName:@"ItemValue" SetColor:true];
                continue;
            }
          
    
            if([_typename isEqualToString:@"YPNL_Mkt"])
                [UIHelper DisplayCell:TableView Field:_field TitleName:@"Marktet Yd PNL:" FieldName:@"ItemValue"    SetColor:true];
            if([_typename isEqualToString:@"TradePNL_Mkt"])
                [UIHelper DisplayCell:TableView Field:_field TitleName:@"Marktet Trade PNL:" FieldName:@"ItemValue"     SetColor:true];
            if([_typename isEqualToString:@"TotalPNL_Mkt"])
                [UIHelper DisplayCell:TableView Field:_field TitleName:@"Marktet Total PNL:" FieldName:@"ItemValue"     SetColor:true];
            
            if([_typename isEqualToString:@"YPNL_Theo"])
                [UIHelper DisplayCell:TableView Field:_field TitleName:@"Theo Yd PNL:" FieldName:@"ItemValue" SetColor:true];
            if([_typename isEqualToString:@"TradePNL_Theo"])
                [UIHelper DisplayCell:TableView Field:_field TitleName:@"Theo Trade PNL:" FieldName:@"ItemValue"    SetColor:true];
            if([_typename isEqualToString:@"TotalPNL_Theo"])
                [UIHelper DisplayCell:TableView Field:_field TitleName:@"Theo Total PNL:" FieldName:@"ItemValue"    SetColor:true];
        }
        
        
        
        //AvgEdge
        if([_typename isEqualToString:@"AvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Avg Edge:" FieldName:@"ItemValue" SetColor:false];
            continue;
        }
        if([_typename isEqualToString:@"PAvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Positive Avg Edge:" FieldName:@"ItemValue" SetColor:false];
             continue;
        }
        if([_typename isEqualToString:@"NAvgEdge"])
        {
            [UIHelper DisplayCell:TableView Field:_field TitleName:@"Negative Avg Edge:" FieldName:@"ItemValue" SetColor:false];
             continue;
        }
        
 
   
        
        //MD
        if([_field[@"ItemKey"] isEqualToString:@"MD"])
        {
            if([_typename isEqualToString:@"Date"])
            {
                [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"MD Date:" DetialText:_field[@"ItemValue"]];
                continue;
            }
            if([_typename isEqualToString:@"Time"])
            {
                value=_field[@"ItemValue"];
                if([value length]>=8)  value = [value substringToIndex:8];
                [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"MD Time:" DetialText:value];
                continue;
            }
        }
        
        
    }
}





////////////////////////////////////////////////////////////////////////////////////////////
//_DisplayHisAsset
////////////////////////////////////////////////////////////////////////////////////////////
-(void) _DisplayHisAsset
{
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"AssetViewController: DisplayHisAsset: queryContext==nil!");
        return;
    }
    
    //NSLog(@"AssetViewController: SELECT: start!");
    
    //SELECT
    NSString* _condstr = [TscConnections getCurrentConnection].AccountID;
    _condstr = [_condstr stringByAppendingString:@" order by HisDate DESC limit 1"];
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"tsshis.hisasset" condition:_condstr];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    
    NSUInteger count = tasks.count;
    //NSLog(@"%@", [tasks objectAtIndex:count-1]);
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
    
    
    
    _fValue = [_field[@"NVTheo"]  floatValue];
    _sValue = [StringHelper fPositiveFormat:_fValue pointNumber:4];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"NV (Theory):" DetialText:_sValue];
    
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
    
    
    //NSLog(@"AssetViewController: SELECT: over!");
}


@end




//AppendSwitch
/*
 -(UISwitch*) AppendSwitch
 {
 UISwitch *_switch = [[UISwitch alloc] init];
 [_switch addTarget:self action:@selector(SwitchChanged:) forControlEvents:UIControlEventValueChanged];
 return _switch;
 }
 */
