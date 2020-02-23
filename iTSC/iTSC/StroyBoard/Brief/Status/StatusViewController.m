//
//  StatusViewControler.m
//  iTSC
//
//  Created by tss on 2020/2/22.
//  Copyright © 2020 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StatusViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"


@implementation StatusViewController

@synthesize TableView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    RefreshCnt = 0;
    isTimerProcessing = false;

    [self InitTableViewCells:true];
   
    RefreshTimerElpasedSeconds = 0;
    if(myTimer==nil)
        myTimer  =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [self StopTimer];

    
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
    [UIHelper SetTabelViewCellDetailText:TableView TitleText:@"Server ID:" DetialText:DBHelper.CurrentConnectionKey];


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







////////////////////////////////////////////////////////////////////////////////////
-(void) InitTableViewCells:(BOOL)vInitAll
{
    if(vInitAll)
        [UIHelper ClearTabelViewCellText:TableView];
    
    UITableViewCell *cell;
    
    UIFont* _font = [UIFont boldSystemFontOfSize:12];
    
    [UIHelper SetTabelViewCellText:TableView Section:0 Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    [UIHelper SetTabelViewCellText:TableView Section:0 Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    


    [UIHelper SetTabelViewCellText:TableView Section:1 Row:0 TitleText:@"OOM Cnt:" DetialText:@"-" Font:_font];
    //[UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"Vega:" DetialText:@"-" Font:_font];
    //[UIHelper SetTabelViewCellText:TableView Section:1 Row:2 TitleText:@"Theta:" DetialText:@"-" Font:_font];

    
    [UIHelper SetTabelViewCellText:TableView Section:2 Row:0 TitleText:@"Open Trade Qty:" DetialText:@"-" Font:_font];
    //[UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"Charm:" DetialText:@"-"];
    //[UIHelper SetTabelViewCellText:TableView Section:2 Row:2 TitleText:@"Vanna:" DetialText:@"-"];
    //[UIHelper SetTabelViewCellText:TableView Section:2 Row:3 TitleText:@"Volga:" DetialText:@"-" Font:_font];
    //[UIHelper SetTabelViewCellText:TableView Section:2 Row:4 TitleText:@"Veta:" DetialText:@"-"];
    //[UIHelper SetTabelViewCellText:TableView Section:2 Row:5 TitleText:@"Thema:" DetialText:@"-" Font:_font];
    
    
    //Posion
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:0 TitleText:@"Long Position:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:TableView Section:3 Row:1 TitleText:@"Short Position:" DetialText:@"-"];

    
    //Mds
    [UIHelper SetTabelViewCellText:TableView Section:4 Row:0 TitleText:@"Md Overall Voume:" DetialText:@"-"];


    if(vInitAll)
    {
        cell = [UIHelper SetTabelViewCellText:TableView Section:5 Row:0 TitleText:@"RefreshCount:" DetialText:@"-"];
        RefreshCountCell = cell;
    }
}



//查询，在此获取数据
- (void)QueryAndDisplay
{

    //RefreshCount
    RefreshCountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", RefreshCnt];
    

    //DB Query
    NSLog(@"StatusViewController: start!");
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"StatusViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"StatusViewController: SELECT: start!");
    
    
    //SELECT
    NSString* _condstr = @"(";
    _condstr=[_condstr stringByAppendingString:@" ( ItemKey='MD' )"];

    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='Position' )"];

    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='TradeSum' and (ItemType='TradeQty' or ItemType='OpenTradeQty') )"];
    
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='MDS' and (ItemType='Volume' or ItemType='Value') )"];

    
    
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
    NSString* _keyname;
    NSString* _typename;
    
    for( int i=0; i<count; i++)
    {
        _field=[tasks objectAtIndex:i];
        NSLog(@"%@", _field);
        

        _keyname = _field[@"ItemKey"];
        _typename = _field[@"ItemType"];
        
 
        //Trade
        if([_typename isEqualToString:@"OpenTradeQty"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Open Trade Qty:" FieldName:@"ItemValue"];
            continue;
        }
        

        //Position
        if([_typename isEqualToString:@"LongPosition"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Long Position:" FieldName:@"ItemValue"];
            continue;
        }
        if([_typename isEqualToString:@"Short Position"])
        {
            [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Short Position:" FieldName:@"ItemValue"];
            continue;
        }
        
        //MDS
        if([_keyname isEqualToString:@"MDS"])
        {
            if([_typename isEqualToString:@"Volume"])
            {
                [UIHelper DisplayIntCell:TableView Field:_field TitleName:@"Md Overall Voume:" FieldName:@"ItemValue"];
                continue;
            }
        }
        
        
  
        
        //MD
        if([_keyname isEqualToString:@"MD"])
        {
            if([_typename isEqualToString:@"Date"])
            {
                [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"MD Date:" DetialText:_field[@"ItemValue"]];
                continue;
            }
            if([_typename isEqualToString:@"Time"])
            {
                [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"MD Time:" DetialText:_field[@"ItemValue"]];
                continue;
            }
        }
        

    } //for over
    
    
    
    _field = [tasks objectAtIndex:0];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordDate:" DetialText:_field[@"RecordDate"]];
    [UIHelper SetTabelViewCellDetailText:TableView TitleText: @"RecordTime:" DetialText:[_field[@"RecordTime"] substringToIndex:8]];
    

    NSLog(@"StatusViewController: SELECT: over!");

    [TableView reloadData];

    NSLog(@"AssetViewController: RefreshCnt=%d", RefreshCnt);

}




@end


