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
    
    int _SectionIndex = 0;
    cell = [UIHelper SetTabelViewCellText:TableView Section:_SectionIndex Row:0 TitleText:@"屏幕常亮:" DetialText:@""];
    Cell_Switch_ShowAllTime = cell;
    
    cell = [UIHelper SetTabelViewCellText:TableView Section:_SectionIndex Row:1 TitleText:@"自动刷新:" DetialText:@""];
    Cell_Switch_GlobalAutoRefresh = cell;
    
    
    //////////////////////////////////////// Connection Confit ////////////////////////////////////////
    ConnectionConfigSection=1;
    NSArray *ConnectionKeys = [TscConnections getConnectionKeys];
    int i = 0;
    //显示Connection
    FirstConnectionRow = [NSIndexPath indexPathForRow:0 inSection:ConnectionConfigSection].row;
    for (NSString *c in ConnectionKeys)
    {
        NSLog(@"%@",c);
        cell = [UIHelper SetTabelViewCellText:TableView Section:(int)ConnectionConfigSection Row:i TitleText:c DetialText:@""];
        if([c isEqualToString:[TscConnections CurrentConnectionKey]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            lastIndexPath = [NSIndexPath indexPathForRow:i inSection:ConnectionConfigSection];
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
    NSInteger rows = [TableView numberOfRowsInSection:ConnectionConfigSection];
    for(int j=i+1; j<(int)rows; j++)
    {
        indexPath=[NSIndexPath indexPathForRow:j inSection:ConnectionConfigSection];
        cell = [TableView cellForRowAtIndexPath:indexPath];
        [cell setHidden:true];
    }
    
    
    
    
    //////////////////////////////////////// Connection Confit ////////////////////////////////////////
    RefreshSecondsSection=2; RefreshSecondsRow=0;
    [UIHelper SetTabelViewCellText:TableView Section:(int)RefreshSecondsSection Row:(int)RefreshSecondsRow TitleText:@"Refresh Seconds:" DetialText:[NSString stringWithFormat:@"%d", (int)[TscConfig RefreshSeconds]]];
    
    ReconnectDBSection=2; ReconnectDBRow=1;
    cell=[UIHelper SetTabelViewCellText:TableView Section:(int)ReconnectDBSection Row:(int)ReconnectDBRow TitleText:@"Reconnect DB" DetialText:@""];
    cell.textLabel.textColor = UIColor.blueColor;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
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



//didSelectRowAtIndexPath
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
    
    //connection set
    if([indexPath section] == ConnectionConfigSection)
    {
        if([indexPath row]>=FirstConnectionRow && [indexPath row]<=LastConnectionRow)
        {
            if (indexPath != lastIndexPath)
            {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                [tableView cellForRowAtIndexPath:lastIndexPath].accessoryType = UITableViewCellAccessoryNone;
            }
            [TscConnections SetCurrentConnection:[TableView cellForRowAtIndexPath:indexPath].textLabel.text];
            lastIndexPath = indexPath;
        }
    }
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


//SetRefreshSeconds
-(void) SetRefreshSeconds
{
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert Title"
                                                                             message:@"The message is ..."
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



@end
