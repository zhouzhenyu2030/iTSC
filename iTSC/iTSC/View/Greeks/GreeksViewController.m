//
//  GreeksViewController.m
//  iTSC
//
//  Created by tss on 2019/1/14.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GreeksViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"


@implementation GreeksViewController

@synthesize Label_RecordTime;
//@synthesize Label_ItemKey;

@synthesize Label_TotalDelta;
@synthesize Label_TotalVega;
@synthesize Label_TotalTheta;

@synthesize Label_TotalGamma;
@synthesize Label_TotalCharm;
@synthesize Label_TotalVanna;
@synthesize Label_TotalVolga;
@synthesize Label_TotalVeta;
@synthesize Label_TotalTata;

@synthesize Label_TotalColor;
@synthesize Label_TotalSpeed;
@synthesize Label_TotalZomma;
@synthesize Label_TotalUltima;

@synthesize Label_TotalSRR;
@synthesize Label_TotalSLR;
@synthesize Label_TotalPCR;
@synthesize Label_TotalCCR;

@synthesize Switch_AutoRefresh;


@synthesize Label_RefreshCount;


NSTimer* myTimer_Greek=nil;

int i;



///////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    i=0;
    
    Switch_AutoRefresh.on = [TscConfig isGreekAutoRefresh];
    
    if(myTimer_Greek==nil)
    {
        myTimer_Greek  =  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
}



//定时器处理函数
bool isTimerProcessing1=false;
-(void)timerFired
{
    if([TscConfig isInBackground] == true) return;
    if([TscConfig isGlobalAutoRefresh] == false) return;
    
    if(isTimerProcessing1) return;
    
    isTimerProcessing1=true;
    [self QueryAndDisplay];
    isTimerProcessing1=false;
    
    i=i+1;
    Label_RefreshCount.text=[NSString stringWithFormat:@"%d", i];
}


//开启定时器
-(void) StartTimer
{
    if(myTimer_Greek!=nil)
    {
        [myTimer_Greek setFireDate:[NSDate distantPast]];
    }
}

//关闭定时器
-(void) StopTimer
{
    if(myTimer_Greek!=nil)
    {
        [myTimer_Greek setFireDate:[NSDate distantFuture]];
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
-(IBAction)AutoRefresh:(id)sender
{
    [self SetTimerState];
    [TscConfig setGreekAutoRefresh:([Switch_AutoRefresh isOn])];
}





///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//查询按钮
- (IBAction)Button_Risk_Query_Click:(UIButton *)sender
{
    [self QueryAndDisplay];
}


//查询
- (void)QueryAndDisplay
{
 
    //
    Label_RecordTime.text = @"-:-:-";
    Label_TotalDelta.text = @"-";
    Label_TotalVega.text = @"-";
    Label_TotalTheta.text = @"-";
    
    Label_TotalGamma.text = @"-";
    Label_TotalCharm.text = @"-";
    Label_TotalVanna.text = @"-";
    Label_TotalVolga.text = @"-";
    Label_TotalVeta.text = @"-";
    Label_TotalTata.text = @"-";
    
    Label_TotalColor.text = @"-";
    Label_TotalSpeed.text = @"-";
    Label_TotalZomma.text = @"-";
    Label_TotalUltima.text = @"-";
    
    Label_TotalSRR.text = @"-";
    Label_TotalSLR.text = @"-";
    Label_TotalPCR.text = @"-";
    Label_TotalCCR.text = @"-";
    
    
    //DB Query
    NSLog(@"GreeksViewController: start!");
    
    
    [DBHelper Init];
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"GreeksViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"GreeksViewController: SELECT: start!");
    
    
    
    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"runtimeinfo" condition:@"ItemKey='Risk' and EntityType='A'"];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    
    NSUInteger count = tasks.count;
    if(count <= 0)
        return;
    



    
    //显示
    Label_RecordTime.text = [tasks objectAtIndex:count-1][@"RecordTime"];
    
    NSDictionary  *_field;
    NSString* _typename;

    for( int i=0; i<count; i++)
    {
        _field=[tasks objectAtIndex:i];
        NSLog(@"%@", _field);
        
        _typename = _field[@"ItemType"];
        
        if([_typename isEqualToString:@"TotalDelta"]) Label_TotalDelta.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalVega"]) Label_TotalVega.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalTheta"]) Label_TotalTheta.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];

        if([_typename isEqualToString:@"TotalGamma"]) Label_TotalGamma.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalCharm"]) Label_TotalCharm.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalVanna"]) Label_TotalVanna.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalVolga"]) Label_TotalVolga.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalVeta"]) Label_TotalVeta.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalTata"]) Label_TotalTata.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];

        if([_typename isEqualToString:@"TotalColor"]) Label_TotalColor.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalSpeed"]) Label_TotalSpeed.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalZomma"]) Label_TotalZomma.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalUltima"]) Label_TotalUltima.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];

        if([_typename isEqualToString:@"TotalSRR"]) Label_TotalSRR.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalSLR"]) Label_TotalSLR.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalPCR"]) Label_TotalPCR.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        if([_typename isEqualToString:@"TotalCCR"]) Label_TotalCCR.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
    }




    
    NSLog(@"GreeksViewController: SELECT: over!");
}

@end
