//
//  TradeSumViewController.m
//  iTSC
//
//  Created by tss on 2019/1/20.
//  Copyright © 2019年 tss. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "TradeSumsViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"


@implementation TradeSumsViewController

@synthesize IBOutletTableView;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 设置LogStr,zTableView
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) SetLogStr
{
    zLogStr = @"GreeksViewController";
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
    int _iSN = 0;
    UITableViewCell *cell;

    if(vInitAll)
        [UIHelper ClearTabelViewCellText:zTableView];

    
    //Record
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    
    //Order
     _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Order Trade Ratio (%):" DetialText:@"-" Color:UIColor.purpleColor];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Order Insert Cnt:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"Order Insert Qty:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:3 TitleText:@"Order Delete Cnt:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:4 TitleText:@"Order Rsp Cnt:" DetialText:@"-"];

    //Trade
     _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"TPR:" DetialText:@"-" Color:UIColor.magentaColor];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Trade Edge:" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"Trade Qty:" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:3 TitleText:@"Edge Per Order:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:4 TitleText:@"Trade Fee:" DetialText:@"-"];
    
    //Oepn
     _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Open Trade Qty:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Buy Open Trade:" DetialText:@"-"];

    
    //AT
     _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Trade Edge (AT):" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Trade Qty (AT):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"Edge Per Order (AT):" DetialText:@"-"];

    //AH
     _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Trade Edge (AH):" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Trade Qty (AH):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"Edge Per Order (AH):" DetialText:@"-"];

    //RefreshCount
     _iSN++;
    if(vInitAll)
    {
        cell = [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"RefreshCount:" DetialText:@"-"];
        RefreshCountCell = cell;
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//查询条件
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) SetQureyCondition
{
    //zTableName
    zTableName = @"runtimeinfo";

    //zCondStr
    zCondStr = @"(";
    
    zCondStr=[zCondStr stringByAppendingString:@" ( ItemKey='TradeSum' )"];
  
    //OverAll
    zCondStr=[zCondStr stringByAppendingString:@" ) and EntityType='A'"];
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//显示item
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)DisplayItem
{
    //------------------------ Log ------------------------
    //NSLog(@"%@: DisplayItem: start!", zLogStr);
    
    
    //------------------------ Order ------------------------
    if([zItemType isEqualToString:@"OrderTradeRatio"])
    {
        float _fValue = [zItemValue floatValue] * 100;
        zItemValue = [StringHelper fPositiveFormat:_fValue pointNumber:2];
        zItemValue = [zItemValue stringByAppendingString:@"%"];
        [UIHelper SetTabelViewCellDetailText:zTableView TitleText: @"Order Trade Ratio (%):" DetialText:zItemValue];
        return;
    }
    if([zItemType isEqualToString:@"OrderInsertCnt"])
    {
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Order Insert Cnt:" FieldName:@"ItemValue"];
        return;
    }
    if([zItemType isEqualToString:@"OrderInsertQty"])
    {
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Order Insert Qty:" FieldName:@"ItemValue"];
        return;
    }
    if([zItemType isEqualToString:@"OrderDeleteCnt"])
    {
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Order Delete Cnt:" FieldName:@"ItemValue"];
        return;
    }
    if([zItemType isEqualToString:@"OrderRspCnt"])
    {
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Order Rsp Cnt:" FieldName:@"ItemValue"];
        return;
    }

     //------------------------ Trade ------------------------
    if([zItemType isEqualToString:@"TradePosRatio"])
    {
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"TPR:" FieldName:@"ItemValue" SetColor:false];
        return;
    }
    if([zItemType isEqualToString:@"TradeQty"])
    {
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Trade Qty:" FieldName:@"ItemValue"];
        return;
    }
    if([zItemType isEqualToString:@"TradeFee"])
    {
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Trade Fee:" FieldName:@"ItemValue" SetColor:false];
        return;
    }
    if([zItemType isEqualToString:@"TradeEdge"])
    {
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Trade Edge:" FieldName:@"ItemValue" SetColor:true];
        return;
    }
    if([zItemType isEqualToString:@"EPO"])
    {
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Edge Per Order:" FieldName:@"ItemValue" SetColor:false];
        return;
     }
    
    //------------------------ Open ------------------------
    if([zItemType isEqualToString:@"BuyOpenTrade"])
    {
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Buy Open Trade:" FieldName:@"ItemValue"];
        return;
    }
    if([zItemType isEqualToString:@"OpenTradeQty"])
    {
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Open Trade Qty:" FieldName:@"ItemValue"];
        return;
    }



    //------------------------ AT ------------------------
    if([zItemType isEqualToString:@"ATTradeEdge"])
    {
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Trade Edge (AT):" FieldName:@"ItemValue" SetColor:true];
        return;
    }
    if([zItemType isEqualToString:@"ATTradeQty"])
    {
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Trade Qty (AT):" FieldName:@"ItemValue"];
        return;
    }
    if([zItemType isEqualToString:@"ATEPO"])
    {
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Edge Per Order (AT):" FieldName:@"ItemValue" SetColor:false];
        return;
    }

    
    //------------------------ AH ------------------------
    if([zItemType isEqualToString:@"AHTradeEdge"])
    {
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Trade Edge (AH):" FieldName:@"ItemValue" SetColor:true];
        return;
    }
    if([zItemType isEqualToString:@"AHTradeQty"])
    {
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Trade Qty (AH):" FieldName:@"ItemValue"];
        return;
    }
    if([zItemType isEqualToString:@"AHEPO"])
    {
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Edge Per Order (AH):" FieldName:@"ItemValue" SetColor:false];
        return;
    }

    
}





@end

