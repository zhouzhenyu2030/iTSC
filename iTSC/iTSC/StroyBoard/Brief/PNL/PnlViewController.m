//
//  PnlViewController.m
//  iTSC
//
//  Created by tss on 2019/1/21.
//  Copyright © 2019年 tss. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "PnlViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"


@implementation PnlViewController


@synthesize IBOutletTableView;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 设置LogStr,zTableView
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) SetLogStr
{
    zLogStr = @"PNLViewController";
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

    //Clear
    if(vInitAll)
        [UIHelper ClearTabelViewCellText:zTableView];
    
    //Record
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    
    //Market PNL
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Trade PNL (Market):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Yd PNL (Market):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"Total PNL (Market):" DetialText:@"-"];

    //Theo PNL
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Trade PNL (Theo):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Yd PNL (Theo):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"Total PNL (Theo):" DetialText:@"-"];

    //Excersize PNL
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Excersize PNL:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Close PNL (Theo):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"Close PNL (Market):" DetialText:@"-"];
    
    //Market PNL
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Market Value:" DetialText:@"-"];
    

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
    
    zCondStr=[zCondStr stringByAppendingString:@" ( ItemKey='PNL' )"];

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
    
    //------------------------ Market ------------------------
    if([zItemType isEqualToString:@"YPNL_Mkt"])
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Yd PNL (Market):" FieldName:@"ItemValue" SetColor:true];
    if([zItemType isEqualToString:@"TradePNL_Mkt"])
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Trade PNL (Market):" FieldName:@"ItemValue" SetColor:true];
    if([zItemType isEqualToString:@"TotalPNL_Mkt"])
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Total PNL (Market):" FieldName:@"ItemValue" SetColor:true];

    //------------------------ Theo ------------------------
    if([zItemType isEqualToString:@"YPNL_Theo"])
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Yd PNL (Theo):" FieldName:@"ItemValue" SetColor:true];
    if([zItemKey isEqualToString:@"TradePNL_Theo"])
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Trade PNL (Theo):" FieldName:@"ItemValue" SetColor:true];
    if([zItemType isEqualToString:@"TotalPNL_Theo"])
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Total PNL (Theo):" FieldName:@"ItemValue" SetColor:true];

    //------------------------ Excersize ------------------------
    if([zItemType isEqualToString:@"ExecPNL"])
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Excersize PNL:" FieldName:@"ItemValue" SetColor:true];
    if([zItemType isEqualToString:@"CloseTheoryPNL"])
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Close PNL (Theo):" FieldName:@"ItemValue" SetColor:true];
    if([zItemType isEqualToString:@"CloseMarketPNL"])
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Close PNL (Market):" FieldName:@"ItemValue" SetColor:true];

    //------------------------ Market Value ------------------------
    if([zItemType isEqualToString:@"MarketValue_Mkt"])
        [UIHelper DisplayCell:zTableView Field:zField TitleName:@"Market Value:" FieldName:@"ItemValue" SetColor:false];
    
}




@end
