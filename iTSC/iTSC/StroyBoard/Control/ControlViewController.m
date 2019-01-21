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



@implementation ControlViewController


/////////////////////////// property /////////////////////////
@synthesize TableView;





///////////////////////// function /////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self InitTableViewCells];
    [self AppendSwitch];

    [self QueryAndDisplay];
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
}

/////////////////////// QueryAndDisplay
- (void)QueryAndDisplay
{

    NSLog(@"ControlViewController: CheckGlobalStart: start!");
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        Cell_DBGlobalStart_Value.detailTextLabel.text=@"queryContext==nil";
        NSLog(@"ControlViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"ControlViewController: SELECT: start!");
    

    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"globalpara" condition:@"ParaID0='Auto' and ParaID1='GloabalStart'"];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    
    NSUInteger count = tasks.count;
    if(count<=0)
    {
        Cell_DBGlobalStart_Value.detailTextLabel.text=@"count==0";
        return;
    }
    
    
    //显示
    NSDictionary  *_field=[tasks objectAtIndex:count-1];
    
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
                                  condition:@"ParaID0='Auto' and ParaID1='GloabalStart'"];
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
