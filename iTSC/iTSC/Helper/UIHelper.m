//
//  UIHelper.m
//  iTSC
//
//  Created by tss on 2019/1/20.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIHelper.h"

@implementation UIHelper


//设置TableViewCellDetailText
+(void) ClearTabelViewCellText:(UITableView*)vTableView
{
    NSInteger sections = vTableView.numberOfSections;
    if(sections<=0)
        return;
    
    NSInteger rows;
    NSIndexPath *indexPath;
    UITableViewCell *cell;
    
    for(int i=0; i<sections; i++)
    {
        rows = [vTableView numberOfRowsInSection:i];
        for(int j=0; j<rows; j++)
        {
            indexPath=[NSIndexPath indexPathForRow:j inSection:i];
            cell = [vTableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = @"";
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.text = @"";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        }
    }
}


//设置TableViewCell
+(UITableViewCell*) SetTabelViewCellText:(UITableView*)vTableView Section:(int)vSectionIndex Row:(int)vRowIndex TitleText:(NSString*) vTitleText DetialText:(NSString*) vDetailText
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:vRowIndex inSection:vSectionIndex];
    UITableViewCell *cell = [vTableView cellForRowAtIndexPath:indexPath];
    //UITableViewCellStyleValue1
    
    if(vTitleText != nil)
        cell.textLabel.text = vTitleText;
    if(vDetailText != nil)
        cell.detailTextLabel.text = vDetailText;
    
    return cell;
}


//设置TableViewCellDetailText
+(void) SetTabelViewCellDetailText:(UITableView*)vTableView TitleText:(NSString*) vTitleText DetialText:(NSString*) vDetailText
{
    if(vTitleText == nil || vDetailText == nil)
        return;
   
    NSInteger sections = vTableView.numberOfSections;
    if(sections<=0)
        return;
    
    NSInteger rows;
    NSIndexPath *indexPath;
    UITableViewCell *cell;
    
    for(int i=0; i<sections; i++)
    {
        rows = [vTableView numberOfRowsInSection:i];
        for(int j=0; j<rows; j++)
        {
            indexPath=[NSIndexPath indexPathForRow:j inSection:i];
            cell = [vTableView cellForRowAtIndexPath:indexPath];
            if([cell.textLabel.text isEqualToString:vTitleText])
            {
                cell.detailTextLabel.text = vDetailText;
                return;
            }
        }
    }
}


@end
