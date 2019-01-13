//
//  SecondViewController.m
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import "SecondViewController.h"
#import "DBHelper.h"



@implementation SecondViewController


/////////////////////////// property /////////////////////////
@synthesize Label_DBGloabalStart;
@synthesize Button_AT;
@synthesize Button_AH;

NSInteger ParaValue;
Boolean isATStarted;
Boolean isAHStarted;


///////////////////////// function /////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self Button_CheckGlobalStart:nil];
}


- (IBAction)Button_CheckGlobalStart:(UIButton *)sender
{

    NSLog(@"SecondViewController: CheckGlobalStart: start!");
    
    
    [DBHelper Init];
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"SecondViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"SecondViewController: SELECT: start!");
    

    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"globalpara" condition:@"ParaID0='Auto' and ParaID1='GloabalStart'"];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    
    NSUInteger count = tasks.count;//减少调用次数
    if(count<=0)
        return;
    
    NSLog(@"%@", [tasks objectAtIndex:count-1]);
    
    
    //显示
    NSDictionary  *_field=[tasks objectAtIndex:count-1];
    
    ParaValue=[_field[@"ParaValue"] intValue];

    Label_DBGloabalStart.text = [NSString stringWithFormat:@"%d", [_field[@"ParaValue"] intValue]];
    
    if(ParaValue==11 || ParaValue==10)
    {
        isATStarted=true;
        Button_AT.backgroundColor= UIColor.greenColor;
    }
    else
    {
        isATStarted=false;
        Button_AT.backgroundColor= UIColor.redColor;
    }

    if(ParaValue==11 || ParaValue==1)
    {
        isAHStarted=true;
        Button_AH.backgroundColor= UIColor.greenColor;
    }
    else
    {
        isAHStarted=false;
        Button_AH.backgroundColor= UIColor.redColor;
    }

    

}

- (void)GenParaValue
{
    NSInteger _t=0;
    if(isATStarted==true)
    {
        _t=10;
    }
    if(isAHStarted==true)
    {
        _t+=1;
    }
    ParaValue=_t;
}

- (IBAction)Button_SetAT:(UIButton *)sender
{
    NSLog(@"SecondViewController: CheckGlobalStart: start!");
    
    
    [DBHelper Init];
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"SecondViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"SecondViewController: SELECT: start!");
    
    //ParaValue
    isATStarted=!isATStarted;
    [self GenParaValue];
   
    //UPDATE
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory
                                  UPDATE:@"globalpara"
                                  set:@{ @"ParaValue": [NSString stringWithFormat:@"%ld", ParaValue] }
                                  condition:@"ParaID0='Auto' and ParaID1='GloabalStart'"];
    NSError *error = nil;
    [_queryContext executeQueryRequest:query error:&error];
    
    
    
    //CheckGlobalStart
    [self Button_CheckGlobalStart:nil];
    
}




- (IBAction)Button_SetAH:(UIButton *)sender
{
    NSLog(@"SecondViewController: CheckGlobalStart: start!");
    
    
    [DBHelper Init];
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"SecondViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"SecondViewController: SELECT: start!");
    
    //ParaValue
    isAHStarted=!isAHStarted;
    [self GenParaValue];
    
    //UPDATE
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory
                                  UPDATE:@"globalpara"
                                  set:@{ @"ParaValue": [NSString stringWithFormat:@"%ld", ParaValue] }
                                  condition:@"ParaID0='Auto' and ParaID1='GloabalStart'"];
    NSError *error = nil;
    [_queryContext executeQueryRequest:query error:&error];
    
    
    
    //CheckGlobalStart
    [self Button_CheckGlobalStart:nil];
    
}

@end
