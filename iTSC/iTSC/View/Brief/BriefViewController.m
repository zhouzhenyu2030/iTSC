//
//  FirstViewController.m
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import "BriefViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"




@implementation BriefViewController

    @synthesize Label_AccountID;
    
    @synthesize Label_HisDate;
    @synthesize Label_RecordTime;
    
    @synthesize Label_AssetTheo;
    @synthesize Label_Asset;
    @synthesize Label_AssetLastPrice;
    @synthesize Label_RiskLevel;
    @synthesize Label_TotalCash;
    @synthesize Label_CurrMargin;

    @synthesize Label_TradeMktPNL;
    @synthesize Label_YdMktPNL;
    @synthesize Label_TotalMktPNL;
    
    @synthesize Label_YdTheoPNL;
    @synthesize Label_TradeTheoPNL;
    @synthesize Label_TotalTheoPNL;
 
    @synthesize Label_TOR;
    @synthesize Label_TradeQty;
    @synthesize Label_OrderInsertQty;
    @synthesize Label_OrderInsertCnt;
    @synthesize Label_QtyPerOrder;

    @synthesize Switch_AutoRefresh;

    @synthesize Label_RefreshCount;



 



///////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    i = 0;
    Switch_AutoRefresh.on = [TscConfig isBriefAutoRefresh];
    
    if(myTimer==nil)
    {
        myTimer  =  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }
}



//定时器处理函数
bool isTimerProcessing=false;
-(void)timerFired
{
    if([TscConfig isInBackground] == true) return;
    if([TscConfig isGlobalAutoRefresh] == false) return;
    
    if(isTimerProcessing)        return;
    
    isTimerProcessing=true;
    [self QueryAndDisplay];
    isTimerProcessing=false;
    
    i+=1;
    Label_RefreshCount.text=[NSString stringWithFormat:@"%d", i];
}


//开启定时器
-(void) StartTimer
{
    if(myTimer!=nil)
    {
        
        [myTimer setFireDate:[NSDate distantPast]];
    }
}

//关闭定时器
-(void) StopTimer
{
    if(myTimer!=nil)
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
-(IBAction)AutoRefresh:(id)sender
{
    [self SetTimerState];
    [TscConfig setBriefAutoRefresh:([Switch_AutoRefresh isOn])];
}





///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//查询按钮
- (IBAction)MyButtonClick:(UIButton *)sender
{
    i = 0;
    [self QueryAndDisplay];
}


//查询
- (void)QueryAndDisplay
{

    NSLog(@"FirstViewController: start!");
    
    
    [DBHelper Init];
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"FirstViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"FirstViewController: SELECT: start!");
    
    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"hisasset" condition:@"AccountID=1202"];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
        
        
        NSUInteger count = tasks.count;//减少调用次数
        //for( int i=0; i<count; i++){
            NSLog(@"%@", [tasks objectAtIndex:count-1]);
        //}
    //for(id obj in tasks){
     //       NSLog(@"%@",obj);
    //}
        
        
    //显示
    NSDictionary  *_field=[tasks objectAtIndex:count-1];
        
    Label_AccountID.text = [NSString stringWithFormat:@"%d", [_field[@"AccountID"] intValue]];
        
    Label_HisDate.text = _field[@"HisDate"];
    Label_RecordTime.text = _field[@"RecordTime"];

    Label_Asset.text = [StringHelper sPositiveFormat:_field[@"Asset"] pointNumber:2];
    Label_AssetTheo.text = [StringHelper sPositiveFormat:_field[@"AssetTheo"] pointNumber:2];
    Label_AssetLastPrice.text = [StringHelper sPositiveFormat:_field[@"AssetLastPrice"] pointNumber:2];


    [self SetPNLLabel:Label_TradeMktPNL Field:_field FieldName:@"TradeMktPNL"];
    [self SetPNLLabel:Label_YdMktPNL Field:_field FieldName:@"YdMktPNL"];
    [self SetPNLLabel:Label_TotalMktPNL Field:_field FieldName:@"TotalMktPNL"];

    [self SetPNLLabel:Label_TradeTheoPNL Field:_field FieldName:@"TradeTheoPNL"];
    [self SetPNLLabel:Label_YdTheoPNL Field:_field FieldName:@"YdTheoPNL"];
    [self SetPNLLabel:Label_TotalTheoPNL Field:_field FieldName:@"TotalTheoPNL"];


    Label_TradeQty.text = [StringHelper sPositiveFormat:_field[@"TradeQty"] pointNumber:0];
    Label_OrderInsertQty.text = [StringHelper sPositiveFormat:_field[@"OrderInsertQty"] pointNumber:0];
    Label_OrderInsertCnt.text = [StringHelper sPositiveFormat:_field[@"OrderInsertCnt"] pointNumber:0];
    
    double _Value=0;
    int _TradeQty=[_field[@"TradeQty"] intValue];
    int _OrderInsertQty=[_field[@"OrderInsertQty"] intValue];
    
    if(_OrderInsertQty!=0)
        _Value=1.0*_TradeQty/_OrderInsertQty*100;
    Label_TOR.text = [NSString stringWithFormat:@"%0.2f", _Value];

    
    int _OrderInsertCnt=[_field[@"OrderInsertCnt"] intValue];
    if(_OrderInsertCnt!=0)
        _Value=1.0*_OrderInsertQty/_OrderInsertCnt;
    Label_QtyPerOrder.text = [NSString stringWithFormat:@"%0.2f", _Value];

    
    
    
    Label_RiskLevel.text = [NSString stringWithFormat:@"%0.2f", [_field[@"RiskLevel"] floatValue]*100];
    
    Label_TotalCash.text = [StringHelper sPositiveFormat:_field[@"TotalCash"] pointNumber:2];
    Label_CurrMargin.text =[StringHelper sPositiveFormat:_field[@"CurrMargin"] pointNumber:2];



}




///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) SetPNLLabel:(UILabel*)vLabel Field:(NSDictionary*)vField FieldName:(NSString*) vFieldName
{
    
   vLabel.text = [StringHelper sPositiveFormat:vField[vFieldName] pointNumber:2];
    
    if([vField[vFieldName] floatValue]==0)
    {
        vLabel.textColor=UIColor.blackColor;
    }
    else
    {
        if([vField[vFieldName] floatValue]>0)
            vLabel.textColor=UIColor.blueColor;
        else
            vLabel.textColor=UIColor.redColor;
    }
}
    
@end
