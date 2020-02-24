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
    
    int _iSN = 0;
    
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    
    //Status
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Basis Error Cnt:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"WingFit Error Cnt:" DetialText:@"-"];

    //Order
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"OOM Cnt:" DetialText:@"-" Font:_font];

    
    //Trade
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Trade Qty:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Open Trade Qty:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"Buy Open Trade Qty:" DetialText:@"-"];
    
    
    //Posion
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Position:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Long Position:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"Short Position:" DetialText:@"-"];

    
    //Mds
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Md Overall Voume:" DetialText:@"-"];


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
    //zTableName
    zTableName = @"runtimeinfo";


    //zCondStr
    zCondStr = @"(";
    
    zCondStr=[zCondStr stringByAppendingString:@" ( ItemKey='MD' )"];
    zCondStr=[zCondStr stringByAppendingString:@" or ( ItemKey='Position' )"];
    zCondStr=[zCondStr stringByAppendingString:@" or ( ItemKey='TradeSum' )"];
    zCondStr=[zCondStr stringByAppendingString:@" or ( ItemKey='Status')"];
    zCondStr=[zCondStr stringByAppendingString:@" or ( ItemKey='MDS' )"];

    //OverAll
    zCondStr=[zCondStr stringByAppendingString:@" ) and EntityType='A'"];
    
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//显示
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)DisplayItem
{
    //------------------------ Log ------------------------
     NSLog(@"%@: DisplayItem: start!", zLogStr);
    
    //------------------------ Order ------------------------
    if([zItemType isEqualToString:@"OOMCnt"])
    {
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"OOM Cnt:" FieldName:@"ItemValue"];
        return;
    }

    //------------------------ Trade ------------------------
    if([zItemKey isEqualToString:@"TradeSum"])
    {
        if([zItemType isEqualToString:@"TradeQty"])
        {
            [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Trade Qty:" FieldName:@"ItemValue"];
            return;
        }
        if([zItemType isEqualToString:@"OpenTradeQty"])
        {
            [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Open Trade Qty:" FieldName:@"ItemValue"];
            return;
        }
        if([zItemType isEqualToString:@"BuyOpenTrade"])
        {
            [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Buy Open Trade Qty:" FieldName:@"ItemValue"];
            return;
        }
    }
        
    
    //------------------------ Position ------------------------
    if([zItemKey isEqualToString:@"Position"])
    {
        if([zItemType isEqualToString:@"LongPosition"])
        {
            [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Long Position:" FieldName:@"ItemValue"];
            return;
        }
        if([zItemType isEqualToString:@"ShortPosition"])
        {
            [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Short Position:" FieldName:@"ItemValue"];
            return;
        }
        if([zItemType isEqualToString:@"Position"])
        {
            [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Position:" FieldName:@"ItemValue"];
            return;
        }
    }
    
    //------------------------ MDS ------------------------
    if([zItemKey isEqualToString:@"MDS"])
    {
        if([zItemType isEqualToString:@"Volume"])
        {
            [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Md Overall Voume:" FieldName:@"ItemValue"];
            return;
        }
    }
        
}



@end


