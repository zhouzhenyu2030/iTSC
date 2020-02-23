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

@synthesize IBOutletTableView;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 设置LogStr,zTableView
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) SetLogStr
{
    zLogStr = @"StatusViewController";
}
-(void) SetTableView
{
    zTableView = IBOutletTableView;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// InitTableViewCells
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) InitTableViewCells:(BOOL)vInitAll
{
    
    if(vInitAll)
        [UIHelper ClearTabelViewCellText:zTableView];
    
    UITableViewCell *cell;
    
    UIFont* _font = [UIFont boldSystemFontOfSize:12];
    
    [UIHelper SetTabelViewCellText:zTableView Section:0 Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    [UIHelper SetTabelViewCellText:zTableView Section:0 Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    

    //order
    [UIHelper SetTabelViewCellText:zTableView Section:1 Row:0 TitleText:@"OOM Cnt:" DetialText:@"-" Font:_font];
    //[UIHelper SetTabelViewCellText:TableView Section:1 Row:1 TitleText:@"Vega:" DetialText:@"-" Font:_font];
    //[UIHelper SetTabelViewCellText:TableView Section:1 Row:2 TitleText:@"Theta:" DetialText:@"-" Font:_font];

    
    //trade
    [UIHelper SetTabelViewCellText:zTableView Section:2 Row:0 TitleText:@"Open Trade Qty:" DetialText:@"-" Font:_font];
    //[UIHelper SetTabelViewCellText:TableView Section:2 Row:1 TitleText:@"Charm:" DetialText:@"-"];
    //[UIHelper SetTabelViewCellText:TableView Section:2 Row:2 TitleText:@"Vanna:" DetialText:@"-"];
    //[UIHelper SetTabelViewCellText:TableView Section:2 Row:3 TitleText:@"Volga:" DetialText:@"-" Font:_font];
    //[UIHelper SetTabelViewCellText:TableView Section:2 Row:4 TitleText:@"Veta:" DetialText:@"-"];
    //[UIHelper SetTabelViewCellText:TableView Section:2 Row:5 TitleText:@"Thema:" DetialText:@"-" Font:_font];
    
    
    //Posion
    [UIHelper SetTabelViewCellText:zTableView Section:3 Row:0 TitleText:@"Long Position:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:3 Row:1 TitleText:@"Short Position:" DetialText:@"-"];

    
    //Mds
    [UIHelper SetTabelViewCellText:zTableView Section:4 Row:0 TitleText:@"Md Overall Voume:" DetialText:@"-"];


    if(vInitAll)
    {
        cell = [UIHelper SetTabelViewCellText:zTableView Section:5 Row:0 TitleText:@"RefreshCount:" DetialText:@"-"];
        RefreshCountCell = cell;
    }
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//查询，在此获取数据
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) SetQureyCondition
{
    NSString* _condstr = @"(";
    
    //MD
    _condstr=[_condstr stringByAppendingString:@" ( ItemKey='MD' )"];

    //Position
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='Position' )"];

    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='TradeSum' and (ItemType='TradeQty' or ItemType='OpenTradeQty') )"];
    
    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='Status' and (ItemType='OOMCnt') )"];

    _condstr=[_condstr stringByAppendingString:@" or ( ItemKey='MDS' and (ItemType='Volume' or ItemType='Value') )"];

    

    //OverAll
    _condstr=[_condstr stringByAppendingString:@" ) and EntityType='A'"];
    
    
    
}

- (bool)QueryData
{

    //Log
    NSLog(@"%@: SELECT: start!", zLogStr);
    
    //DB Query
    queryContext=[DBHelper GetContext];
    if(queryContext==nil)
    {
        NSLog(@"%@: Init: queryContext==nil!", zLogStr);
        return false;
    }
    
    //SELECT


     
     
     query = [OHMySQLQueryRequestFactory SELECT:@"runtimeinfo" condition:_condstr];
     queryerror = nil;
     tasks = [queryContext executeQueryRequestAndFetchResult:query error:&queryerror];
     
}




- (void)QueryAndDisplay
{
    //RefreshCount
    RefreshCountCell.detailTextLabel.text=[NSString stringWithFormat:@"%d", RefreshCnt];
    

    //
    [self QueryData];

    //
    NSLog(@"StatusViewController: SELECT: over! record cnt=%ld", tasks.count);

    
    //清除原显示
    [self InitTableViewCells:false];
    
    NSUInteger count = tasks.count;
    if(count <= 0)
        return;
    
 

    //--------------------------- 显示 -------------------------
    NSDictionary  *_field;
    NSString* _keyname;
    NSString* _typename;
    
    for( int i=0; i<count; i++)
    {
        _field=[tasks objectAtIndex:i];
        NSLog(@"record#=%d, %@", i, _field);
        

        _keyname = _field[@"ItemKey"];
        _typename = _field[@"ItemType"];
        
 
        //Trade
        if([_typename isEqualToString:@"OOMCnt"])
        {
            [UIHelper DisplayIntCell:zTableView Field:_field TitleName:@"OOM Cnt:" FieldName:@"ItemValue"];
            continue;
        }

        //Trade
        if([_typename isEqualToString:@"OpenTradeQty"])
        {
            [UIHelper DisplayIntCell:zTableView Field:_field TitleName:@"Open Trade Qty:" FieldName:@"ItemValue"];
            continue;
        }
        

        //Position
        if([_typename isEqualToString:@"LongPosition"])
        {
            [UIHelper DisplayIntCell:zTableView Field:_field TitleName:@"Long Position:" FieldName:@"ItemValue"];
            continue;
        }
        if([_typename isEqualToString:@"Short Position"])
        {
            [UIHelper DisplayIntCell:zTableView Field:_field TitleName:@"Short Position:" FieldName:@"ItemValue"];
            continue;
        }
        
        //MDS
        if([_keyname isEqualToString:@"MDS"])
        {
            if([_typename isEqualToString:@"Volume"])
            {
                [UIHelper DisplayIntCell:zTableView Field:_field TitleName:@"Md Overall Voume:" FieldName:@"ItemValue"];
                continue;
            }
        }
        
        
  
        
        //MD
        if([_keyname isEqualToString:@"MD"])
        {
            if([_typename isEqualToString:@"Date"])
            {
                [UIHelper SetTabelViewCellDetailText:zTableView TitleText: @"MD Date:" DetialText:_field[@"ItemValue"]];
                continue;
            }
            if([_typename isEqualToString:@"Time"])
            {
                [UIHelper SetTabelViewCellDetailText:zTableView TitleText: @"MD Time:" DetialText:_field[@"ItemValue"]];
                continue;
            }
        }
        

    } //for over
    
    
    
    _field = [tasks objectAtIndex:0];
    [UIHelper SetTabelViewCellDetailText:zTableView TitleText: @"RecordDate:" DetialText:_field[@"RecordDate"]];
    [UIHelper SetTabelViewCellDetailText:zTableView TitleText: @"RecordTime:" DetialText:[_field[@"RecordTime"] substringToIndex:8]];
    

    NSLog(@"StatusViewController: SELECT: over!");

    [zTableView reloadData];

    NSLog(@"AssetViewController: RefreshCnt=%d", RefreshCnt);

}



@end


