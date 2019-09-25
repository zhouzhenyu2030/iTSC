//
//  SecondViewController.m
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import "ControlViewController.h"

#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"
#import "ThreadHelper.h"


@implementation ControlViewController


/////////////////////////// property /////////////////////////
@synthesize TableView;





///////////////////////// function /////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    RefreshCnt=0;
    RefreshTimerElpasedSeconds = 0;
    if(myTimer==nil)
        myTimer  =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
    
    [self InitTableViewCells];
    [self AppendSwitch];

    [self setupRefresh];
    
    [self QueryAndDisplay];
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
    [self QueryAndDisplay];
    [self.TableView reloadData];
    [refreshControl endRefreshing];
}




//定时器处理函数
-(void)timerFired
{
    if([TscConfig isInBackground] == true) return;

    if(isTimerProcessing) return;
    
    RefreshTimerElpasedSeconds++;
    if(RefreshTimerElpasedSeconds<TscConfig.RefreshSeconds) return;
    
    isTimerProcessing=true;
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

//根据switch设定Timer启停
-(void) SetTimerState
{
    //if ([Switch_AutoRefresh isOn])
        [self StartTimer];
    //else
    //    [self StopTimer];
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




/////////////////////// InitTableViewCells
-(void) InitTableViewCells
{
    [UIHelper ClearTabelViewCellText:TableView];
    
    UITableViewCell *cell;
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:0 TitleText:@"AT DB Start:" DetialText:@""];
    Cell_AT_DBStart = cell;
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:1 TitleText:@"AH DB Start:" DetialText:@""];
    Cell_AH_DBStart = cell;
    cell = [UIHelper SetTabelViewCellText:TableView Section:0 Row:2 TitleText:@"DB GlobalStart Value:" DetialText:@"-"];
    Cell_DBGlobalStart_Value = cell;
    

    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:0 TitleText:@"AClose DB Start:" DetialText:@""];
    Cell_AC_Start = cell;
    cell = [UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"AClose DB Start Confirm:" DetialText:@""];
    Cell_AC_StartConfirm = cell;

    
    cell = [UIHelper SetTabelViewCellText:TableView Section:2 Row:0 TitleText:@"RefreshCount:" DetialText:@"-"];
    RefreshCountCell = cell;
    
    ThreadLoopCntCell=[UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"Thread Loop Count:" DetialText:@"-"];
}


/////////////////////// AppendSwitch
-(void) AppendSwitch
{
    UISwitch *_switch;
    
    //AT_DBStart
    _switch = [[UISwitch alloc] init];
    [_switch addTarget:self action:@selector(Switch_AT_DBStart_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    Cell_AT_DBStart.accessoryView = _switch;
    Switch_AT_DBStart = _switch;

    //AH_DBStart
    _switch = [[UISwitch alloc] init];
    [_switch addTarget:self action:@selector(Switch_AH_DBStart_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    Cell_AH_DBStart.accessoryView = _switch;
    Switch_AH_DBStart = _switch;
    
    
    //AC_Start
    _switch = [[UISwitch alloc] init];
    [_switch addTarget:self action:@selector(Switch_AC_Start_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    Cell_AC_Start.accessoryView = _switch;
    Switch_AC_Start = _switch;
    
    //AC_StartConfirm
    _switch = [[UISwitch alloc] init];
    [_switch addTarget:self action:@selector(Switch_AC_StartConfirm_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    Cell_AC_StartConfirm.accessoryView = _switch;
    Switch_AC_StartConfirm = _switch;
}

/////////////////////// QueryAndDisplay
- (void)QueryAndDisplay
{

    NSLog(@"ControlViewController: CheckGlobalStart: start!");
    
    RefreshCountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", (int)RefreshCnt];
    ThreadLoopCntCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", [ThreadHelper ThreadLoopCnt]];
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        Cell_DBGlobalStart_Value.detailTextLabel.text=@"queryContext==nil";
        NSLog(@"ControlViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"ControlViewController: SELECT: start!");
    

    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory
                                  SELECT:@"globalpara"
                                  condition:@"ParaID0='Auto' and (ParaID1='GlobalStart' or ParaID1='AClose')"];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    
    NSUInteger count = tasks.count;
    if(count<=0)
    {
        Cell_DBGlobalStart_Value.detailTextLabel.text=@"count==0";
        return;
    }

    //显示
    NSDictionary  *_field;
    
    for( int i=0; i<count; i++)
    {
        _field=[tasks objectAtIndex:i];
        NSLog(@"%@", _field);
        
        if([_field[@"ParaID1"] isEqualToString:@"GlobalStart"])
        {
            ParaValue=[_field[@"ParaValue"] intValue];
            
            Cell_DBGlobalStart_Value.detailTextLabel.text = [NSString stringWithFormat:@"%d", [_field[@"ParaValue"] intValue]];
            
            if(ParaValue == 11 || ParaValue == 10)
            {
                isATStarted = true;
            }
            else
            {
                isATStarted = false;
            }
            
            if(ParaValue == 11 || ParaValue == 1)
            {
                isAHStarted = true;
            }
            else
            {
                isAHStarted = false;
            }
            
            Switch_AT_DBStart.on = isATStarted;
            Switch_AH_DBStart.on = isAHStarted;
            
            continue;
        }
        
        
        
        if([_field[@"ParaID2"] isEqualToString:@"ACloseStart"])
        {
            Switch_AC_Start.on = [_field[@"ParaValue"] boolValue];
        }
        if([_field[@"ParaID2"] isEqualToString:@"ACloseStartConfirm"])
        {
            Switch_AC_StartConfirm.on = [_field[@"ParaValue"] boolValue];
        }
        
    }
    
}



/////////////////////// Swtich
- (void)Switch_AT_DBStart_ValueChanged:(id)sender
{
    isATStarted=!isATStarted;
    [self UpdateDBGlobalStart];
    [self QueryAndDisplay];
}
- (void)Switch_AH_DBStart_ValueChanged:(id)sender
{
    isAHStarted=!isAHStarted;
    [self UpdateDBGlobalStart];
    [self QueryAndDisplay];
}
-(void)Switch_AC_Start_ValueChanged:(id)sender
{
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"Switch_AC_StartConfirm_ValueChanged: Init: queryContext==nil!");
    }
    
    
    //UPDATE
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory
                                  UPDATE:@"globalpara"
                                  set:@{ @"ParaValue": [NSString stringWithFormat:@"%d", Switch_AC_Start.on] }
                                  condition:@"ParaID1='ACLose' and ParaID2='ACloseStart'"];
    NSError *error = nil;
    [_queryContext executeQueryRequest:query error:&error];
    
    
    //QueryAndDisplay
    [self QueryAndDisplay];
}
-(void)Switch_AC_StartConfirm_ValueChanged:(id)sender
{
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"Switch_AC_StartConfirm_ValueChanged: Init: queryContext==nil!");
    }
    

    //UPDATE
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory
                                  UPDATE:@"globalpara"
                                  set:@{ @"ParaValue": [NSString stringWithFormat:@"%d", Switch_AC_StartConfirm.on] }
                                  condition:@"ParaID1='ACLose' and ParaID2='ACloseStartConfirm'"];
    NSError *error = nil;
    [_queryContext executeQueryRequest:query error:&error];
    
    
    //QueryAndDisplay
    [self QueryAndDisplay];
}



-(BOOL) UpdateDBGlobalStart
{
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"SecondViewController: Init: queryContext==nil!");
        Cell_DBGlobalStart_Value.detailTextLabel.text=@"queryContext==nil";
        return false;
    }
    
    //ParaValue
    [self GenParaValue];
    
    //UPDATE
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory
                                  UPDATE:@"globalpara"
                                  set:@{ @"ParaValue": [NSString stringWithFormat:@"%ld", ParaValue] }
                                  condition:@"ParaID0='Auto' and ParaID1='GlobalStart'"];
    NSError *error = nil;
    [_queryContext executeQueryRequest:query error:&error];
    

    //QueryAndDisplay
    [self QueryAndDisplay];
    
    
    return true;
}

- (void)GenParaValue
{
    NSInteger _t=0;
    if(isATStarted==true)        _t=10;
    if(isAHStarted==true)        _t+=1;
    ParaValue=_t;
}


///////////////////////

@end
