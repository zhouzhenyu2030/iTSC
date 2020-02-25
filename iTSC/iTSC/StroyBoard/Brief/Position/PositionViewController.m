//
//  PositionViewController.m
//  iTSC
//
//  Created by tss on 2019/1/21.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PositionViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"


@implementation PositionViewController

@synthesize IBOutletTableView;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 设置LogStr,zTableView
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) SetLogStr
{
    zLogStr = @"PositionViewController";
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
    
    
    //Today
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:1 Row:0 TitleText:@"Position (Yd):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:1 Row:1 TitleText:@"Long Position (Yd):" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:1 Row:2 TitleText:@"Short Position (Yd):" DetialText:@"-"];

    //Yestorday
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:2 Row:0 TitleText:@"Position:" DetialText:@"-" Color:UIColor.blueColor];
    [UIHelper SetTabelViewCellText:zTableView Section:2 Row:1 TitleText:@"Long Position:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:2 Row:2 TitleText:@"Short Position:" DetialText:@"-"];

    //Frozen
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:3 Row:0 TitleText:@"Frozen:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:3 Row:1 TitleText:@"Available:" DetialText:@"-"];
   
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
    
    zCondStr=[zCondStr stringByAppendingString:@" ( ItemKey='Position' )"];
  
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
    

    //------------------------ Yd ------------------------
    if([zItemType isEqualToString:@"YdPosition"])
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Position (Yd):" FieldName:@"ItemValue"];
    if([zItemType isEqualToString:@"YdLongPosition"])
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Long Position (Yd):" FieldName:@"ItemValue"];
    if([zItemType isEqualToString:@"YdShortPosition"])
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Short Position (Yd):" FieldName:@"ItemValue"];
        
    //------------------------ Td ------------------------
    if([zItemType isEqualToString:@"Position"])
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Position:" FieldName:@"ItemValue"];
    if([zItemType isEqualToString:@"LongPosition"])
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Long Position:" FieldName:@"ItemValue"];
    if([zItemType isEqualToString:@"ShortPosition"])
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Short Position:" FieldName:@"ItemValue"];
        
    //------------------------ Frozen ------------------------
    if([zItemType isEqualToString:@"Frozen"])
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Frozen:" FieldName:@"ItemValue"];
    if([zItemType isEqualToString:@"Available"])
        [UIHelper DisplayIntCell:zTableView Field:zField TitleName:@"Available:" FieldName:@"ItemValue"];
    
}


@end
