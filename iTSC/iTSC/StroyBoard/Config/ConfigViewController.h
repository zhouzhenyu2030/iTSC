//
//  ConfigViewController.h
//  iTSC
//
//  Created by tss on 2019/1/16.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef ConfigViewController_h
#define ConfigViewController_h

#import <UIKit/UIKit.h>



@interface ConfigViewController : UITableViewController
{
    NSIndexPath *lastIndexPath;
    
    NSInteger ConnectionConfigSection, FirstConnectionRow, LastConnectionRow;
    NSInteger RefreshSecondsSection, RefreshSecondsRow;
    NSInteger ReconnectDBSection, ReconnectDBRow;
    NSInteger ClearRunTimeInfoTalbeSection, ClearRunTimeInfoTalbeRow;
    
    
    UISwitch *Switch_ShowAllTime;
    UISwitch *Switch_GlobalAutoRefresh;

    UITableViewCell *Cell_Switch_ShowAllTime;
    UITableViewCell *Cell_Switch_GlobalAutoRefresh;
}



@property (strong, nonatomic) IBOutlet UITableView *TableView;


@end

#endif /* ConfigViewController_h */
