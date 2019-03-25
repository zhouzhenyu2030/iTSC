//
//  ConfigViewController.m
//  iTSC
//
//  Created by tss on 2019/1/16.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>



#import "ConfigViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"
#import "TscConnections.h"


@implementation ConfigViewController

@synthesize TableView;



//viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    [self InitTableViewCells];
    [self AppendSwitch];

}


//InitTableViewCells
-(void) InitTableViewCells
{
    [UIHelper ClearTabelViewCellText:TableView];
    
    UITableViewCell *cell;
    int i;
    
    int _SectionIndex = 0;
    cell = [UIHelper SetTabelViewCellText:TableView Section:_SectionIndex Row:0 TitleText:@"屏幕常亮:" DetialText:@""];
    Cell_Switch_ShowAllTime = cell;
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:_SectionIndex Row:1 TitleText:@"自动刷新:" DetialText:@""];
    Cell_Switch_GlobalAutoRefresh = cell;
    
    
    
    /////////////////////////////////////// 显示DNS ////////////////////////////////////////
    _SectionIndex++;
    //cell=[UIHelper SetTabelViewCellText:TableView Section:_SectionIndex Row:0 TitleText:@"DNS" DetialText:[TscDNSs getCurrentDNSName]];
    //cell.accessoryType = UITableViewCellAccessoryNone;
    DNSSection = _SectionIndex;
    NSArray *DNSNames = [TscDNSs getDNSNames];
    i = 0;
    //显示Connection
    FirstDNSRow = [NSIndexPath indexPathForRow:0 inSection:DNSSection].row;
    for (NSString *c in DNSNames)
    {
        cell = [UIHelper SetTabelViewCellText:TableView Section:(int)DNSSection Row:i TitleText:c DetialText:@""];
        if([c isEqualToString:[TscDNSs getCurrentDNSName]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            lastDNSIndexPath = [NSIndexPath indexPathForRow:i inSection:DNSSection];
        }
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        i++;
    }
    LastDNSRow = [NSIndexPath indexPathForRow:i-1 inSection:DNSSection].row;
  
    
    
    //////////////////////////////////////// Connection Confit ////////////////////////////////////////
    _SectionIndex++;
    ConnectionConfigSection = _SectionIndex;
    NSArray *ConnectionKeys = [TscConnections getConnectionKeys];
    i = 0;
    //显示Connection
    FirstConnectionRow = [NSIndexPath indexPathForRow:0 inSection:ConnectionConfigSection].row;
    for (NSString *c in ConnectionKeys)
    {
        NSLog(@"%@",c);
        cell = [UIHelper SetTabelViewCellText:TableView Section:(int)ConnectionConfigSection Row:i TitleText:c DetialText:@""];
        if([c isEqualToString:[TscConnections CurrentConnectionKey]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            lastConnectionIndexPath = [NSIndexPath indexPathForRow:i inSection:ConnectionConfigSection];
        }
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        i++;
    }
    LastConnectionRow = [NSIndexPath indexPathForRow:i-1 inSection:ConnectionConfigSection].row;
  
    //添加Connection
    [UIHelper SetTabelViewCellText:TableView Section:(int)ConnectionConfigSection Row:i TitleText:@"添加 Connection" DetialText:@""];
    
  
    //隐藏多余行
    NSIndexPath *indexPath;
    //   NSInteger rows = [TableView numberOfRowsInSection:ConnectionConfigSection];
    //  for(int j=i; j<(int)rows; j++)
    //  {
    //      indexPath=[NSIndexPath indexPathForRow:j inSection:ConnectionConfigSection];
    //      cell = [TableView cellForRowAtIndexPath:indexPath];
    //     //[cell setHidden:true];
    //     [cell delete:(self)];
    //}
    
    //删除多余行
    while([TableView numberOfRowsInSection:ConnectionConfigSection]>i+1)
    {
        indexPath=[NSIndexPath indexPathForRow:i+1 inSection:ConnectionConfigSection];
        cell = [TableView cellForRowAtIndexPath:indexPath];
        [cell delete:(TableView)];
    }
    
    
    
    //////////////////////////////////////// DB Config (Refresh/Reconnect/Clear) ////////////////////////////////////////
    _SectionIndex++;
    RefreshSecondsSection=_SectionIndex; RefreshSecondsRow=0;
    [UIHelper SetTabelViewCellText:TableView Section:(int)RefreshSecondsSection Row:(int)RefreshSecondsRow TitleText:@"Refresh Seconds:" DetialText:[NSString stringWithFormat:@"%d", (int)[TscConfig RefreshSeconds]]];
    
    ReconnectDBSection=_SectionIndex; ReconnectDBRow=1;
    cell=[UIHelper SetTabelViewCellText:TableView Section:(int)ReconnectDBSection Row:(int)ReconnectDBRow TitleText:@"Reconnect DB" DetialText:@""];
    cell.textLabel.textColor = UIColor.blueColor;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    ClearRunTimeInfoTalbeSection=_SectionIndex; ClearRunTimeInfoTalbeRow=2;
    cell=[UIHelper SetTabelViewCellText:TableView Section:(int)ClearRunTimeInfoTalbeSection Row:(int)ClearRunTimeInfoTalbeRow TitleText:@"Clear RunTimeInfo Table" DetialText:@""];
    cell.textLabel.textColor = UIColor.blueColor;
    cell.accessoryType = UITableViewCellAccessoryNone;
 
    
    //////////////////////////////////////// SetTime ////////////////////////////////////////
    _SectionIndex++;
    SetTimeSection=_SectionIndex; SetTimeRow=0;
    cell=[UIHelper SetTabelViewCellText:TableView Section:(int)SetTimeSection Row:(int)SetTimeRow TitleText:@"Set Tss Server Time to Now" DetialText:@""];
    cell.textLabel.textColor = UIColor.blueColor;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    //////////////////////////////////////// Help ////////////////////////////////////////
    _SectionIndex++;
    HelpSection=_SectionIndex; HelpRow=0;
    [UIHelper SetTabelViewCellText:TableView Section:(int)HelpSection Row:(int)HelpRow TitleText:@"Help" DetialText:@""];
    
}


//AppendSwitch
-(void) AppendSwitch
{
    UISwitch *_switch;
    
    //ShowAllTime
    _switch = [[UISwitch alloc] init];
    [_switch addTarget:self action:@selector(Switch_ShowAllTime_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    Cell_Switch_ShowAllTime.accessoryView = _switch;
    Switch_ShowAllTime = _switch;
    Switch_ShowAllTime.on = [TscConfig isShowAllTime];
    
    //GlobalAutoRefresh
    _switch = [[UISwitch alloc] init];
    [_switch addTarget:self action:@selector(Switch_GlobalAutoRefresh_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    Cell_Switch_GlobalAutoRefresh.accessoryView = _switch;
    Switch_GlobalAutoRefresh = _switch;
    Switch_GlobalAutoRefresh.on = [TscConfig isGlobalAutoRefresh];
    
}


//Switch_ValueChanged
- (void)Switch_ShowAllTime_ValueChanged:(id)sender
{
    [TscConfig setShowAllTime:[(UISwitch*)sender isOn]];
}

- (void)Switch_GlobalAutoRefresh_ValueChanged:(id)sender
{
    [TscConfig setGlobalAutoRefresh:[(UISwitch*)sender isOn]];
}



////////////////////////////////////////// didSelectRowAtIndexPath //////////////////////////////////////////
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //RefreshSeconds
    if([indexPath section] == RefreshSecondsSection && [indexPath row] == RefreshSecondsRow)
    {
        [self SetRefreshSeconds];
        [UIHelper SetTabelViewCellText:TableView Section:(int)RefreshSecondsSection Row:(int)RefreshSecondsRow TitleText:@"Refresh Seconds:" DetialText:[NSString stringWithFormat:@"%d", (int)[TscConfig RefreshSeconds]]];
    }
 
    //ReconnectDB
    if([indexPath section] == ReconnectDBSection && [indexPath row] == ReconnectDBRow)
    {
        [DBHelper Reconnect];
        UIAlertController * alertController=[UIHelper ShowMessage:@"Reconnect DB" Message:@"Reconnect DB is over."];
        [self presentViewController:alertController animated:YES completion:nil];
    }
  
    //DNS 设定
    if([indexPath section] == DNSSection)
    {
        if([indexPath row]>=FirstDNSRow && [indexPath row]<=LastDNSRow)
        {
            [TscDNSs SetCurrentDNS:[TableView cellForRowAtIndexPath:indexPath].textLabel.text];
            if([DBHelper Reconnect]==false)
            {
                UIAlertController * alertController=[UIHelper ShowMessage:@"DNS Set." Message:@"DB Connect failed."];
                [self presentViewController:alertController animated:YES completion:nil];
            }

            if (indexPath != lastDNSIndexPath)
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [tableView cellForRowAtIndexPath:lastDNSIndexPath].accessoryType = UITableViewCellAccessoryNone;
            }
            lastDNSIndexPath = indexPath;
        }
    }

    
    //connection 设定
    if([indexPath section] == ConnectionConfigSection)
    {
        if([indexPath row]>=FirstConnectionRow && [indexPath row]<=LastConnectionRow)
        {
            if (indexPath != lastConnectionIndexPath)
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [tableView cellForRowAtIndexPath:lastConnectionIndexPath].accessoryType = UITableViewCellAccessoryNone;
            }
            [TscConnections SetCurrentConnection:[TableView cellForRowAtIndexPath:indexPath].textLabel.text];
            lastConnectionIndexPath = indexPath;
        }
    }
    
    //ClearRunTimeInfoTable
    if([indexPath section] == ClearRunTimeInfoTalbeSection && [indexPath row] == ClearRunTimeInfoTalbeRow)
    {
        NSString* _msg;
        if([self ClearRunTimeInfoTalbe] == true)
            _msg=@"Clear RunTimeInfo Talbe is ok.";
        else
            _msg=@"Clear RunTimeInfo Talbe is failed.";
        UIAlertController * alertController=[UIHelper ShowMessage:@"Cleart Table" Message:_msg];
        [self presentViewController:alertController animated:YES completion:nil];
    }

    //设定Server时间
    if([indexPath section] == SetTimeSection && [indexPath row] == SetTimeRow)
    {
        NSString* _ret = [self Function_SetTime];
        NSString* _msg;
        if([_ret length ] != 0)
            _msg=[@"SetTime is ok." stringByAppendingString:_ret];
        else
            _msg=[@"SetTime is failed." stringByAppendingString:_ret];
        UIAlertController * alertController=[UIHelper ShowMessage:@"SetTime" Message:_msg];
        [self presentViewController:alertController animated:YES completion:nil];
    }

    
    //help
    if([indexPath section] == HelpSection && [indexPath row] == HelpRow)
    {
        UIViewController *_helpvc =[[UIStoryboard storyboardWithName:@"Help" bundle:nil]  instantiateViewControllerWithIdentifier:@"HelpMain"]; //设置跳转页面
        [self.navigationController pushViewController:_helpvc animated:YES]; //设置跳转方式
    }

    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//SetRefreshSeconds
-(void) SetRefreshSeconds
{
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Refresh Seconds"
                                                                             message:@"Input Refresh Seconds:"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    //TextField
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull myTextField) {
    }];
    UITextField *_TextField = alertController.textFields.firstObject;
    _TextField.text=[NSString stringWithFormat:@"%d", (int)[TscConfig RefreshSeconds]];
    
    // 2.创建并添加按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                               {
                                   NSLog(@"OK Action:%@", _TextField.text);
                                   NSInteger _value=_TextField.text.integerValue;
                                   if(_value<=0) _value=2;
                                   [TscConfig setRefreshSeconds:_value];
                               }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
    }];
    
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];

    
    // 3.呈现UIAlertContorller
    [self presentViewController:alertController animated:YES completion:nil];
    
}



//ClearRunTimeInfoTalbe
-(bool) ClearRunTimeInfoTalbe
{
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"ClearRunTimeInfoTalbe: Init: queryContext==nil!");
        return false;
    }
    
    NSLog(@"ClearRunTimeInfoTalbe: DELETE: start!");
    
    //DELETE
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory DELETE:@"runtimeinfo" condition:@""];
    NSError *error = nil;
    //NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    if(error!=nil)
        return false;
    return true;
}


//ClearRunTimeInfoTalbe
-(NSString*) Function_SetTime
{
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"Function_SetTime: Init: queryContext==nil!");
        return @"";
    }
    
    NSLog(@"Function_SetTime: UPDATE: start!");
    
    //读取系统时间
    NSDateFormatter *_dateFormatter;
    NSString *_strTime;

    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _strTime=[_dateFormatter stringFromDate:[NSDate date]];
    _strTime=[_strTime substringFromIndex:11];
    NSLog(@"time=%@", _strTime);
    
    
    //Set Dictionary
    NSDictionary<NSString *,id>* dicSet = [NSDictionary dictionaryWithObject:_strTime forKey:@"ParaValue"];

    
    //Update
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory UPDATE:@"globalpara" set:dicSet condition:@"ParaID0='SYS' and ParaID1='SetTime'"];
    NSError *error = nil;
    [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    if(error!=nil)
        return @"";
    return _strTime;
}

@end
