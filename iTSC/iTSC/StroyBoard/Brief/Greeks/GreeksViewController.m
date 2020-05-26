//
//  GreeksViewController.m
//  iTSC
//
//  Created by tss on 2019/1/19.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GreeksViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"
#import "TscConnections.h"


@implementation GreeksViewController

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
    UIFont* _font = [UIFont boldSystemFontOfSize:12];

    //Clear
    if(vInitAll)
        [UIHelper ClearTabelViewCellText:zTableView];
    
    //Record
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"RecordDate:" DetialText:@"-/-/-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"RecordTime:" DetialText:@"-:-:-"];
    

    //Risk 1
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Delta:" DetialText:@"-" Font:_font];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Vega:" DetialText:@"-" Font:_font];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"Theta:" DetialText:@"-" Font:_font];

    
    //Risk 2
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Gamma:" DetialText:@"-" Font:_font];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Charm:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"Vanna:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:3 TitleText:@"Volga:" DetialText:@"-" Font:_font];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:4 TitleText:@"Veta:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:5 TitleText:@"Thema:" DetialText:@"-" Font:_font];
    
    //Risk 3
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"Color:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"Speed:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"Zomma:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:3 TitleText:@"Ultima:" DetialText:@"-"];
    
    //Wing Risk
    _iSN++;
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:0 TitleText:@"SRR:" DetialText:@"-" Font:_font];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:1 TitleText:@"SLR:" DetialText:@"-" Font:_font];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:2 TitleText:@"PCR:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:3 TitleText:@"CCR:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:4 TitleText:@"WDR:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:5 TitleText:@"WVR:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:6 TitleText:@"WTR:" DetialText:@"-"];
    [UIHelper SetTabelViewCellText:zTableView Section:_iSN Row:7 TitleText:@"WGR:" DetialText:@"-"];


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
    
    zCondStr=[zCondStr stringByAppendingString:@" ( ItemKey='Risk' )"];
  
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
    

    //------------------------ Risk ------------------------
    if([zItemKey isEqualToString:@"Risk"])
    {
        NSString* titlename = [zItemType substringFromIndex:5]; titlename = [titlename stringByAppendingString:@":"];
        if([titlename isEqualToString:@"Tata:"]) titlename = @"Thema:";
        
        [UIHelper DisplayCell:zTableView Field:zField TitleName:titlename FieldName:@"ItemValue" SetColor:true];
        
        return;
    }
    
}



@end
