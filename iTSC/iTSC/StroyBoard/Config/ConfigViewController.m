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
    
    
    //////////////////////////////////////// Connection ////////////////////////////////////////
    _SectionIndex=1;
    NSArray *ConnectionKeys = [TscConnections getConnectionKeys];
    int i = 0;
    //显示Connection
    FirstConnectionRow = [NSIndexPath indexPathForRow:0 inSection:_SectionIndex].row;
    for (NSString *c in ConnectionKeys)
    {
        NSLog(@"%@",c);
        cell = [UIHelper SetTabelViewCellText:TableView Section:_SectionIndex Row:i TitleText:c DetialText:@""];
        if([c isEqualToString:[TscConnections CurrentConnectionKey]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            lastIndexPath = [NSIndexPath indexPathForRow:i inSection:_SectionIndex];
        }
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
        i++;
    }
    LastConnectionRow = [NSIndexPath indexPathForRow:i-1 inSection:_SectionIndex].row;

    //添加Connection
    cell = [UIHelper SetTabelViewCellText:TableView Section:_SectionIndex Row:i TitleText:@"添加 Connection" DetialText:@""];
    //cell.accessoryType = UITableViewCellAccessoryNone;
    
    //隐藏多余行
    NSIndexPath *indexPath;
    NSInteger rows = [TableView numberOfRowsInSection:_SectionIndex];
    for(int j=i+1; j<(int)rows; j++)
    {
        indexPath=[NSIndexPath indexPathForRow:j inSection:_SectionIndex];
        cell = [TableView cellForRowAtIndexPath:indexPath];
        [cell setHidden:true];
    }


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
    //connection
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


 
 
@end
