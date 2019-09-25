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
    NSIndexPath *lastDNSIndexPath, *lastConnectionIndexPath;
    
    NSInteger DNSSection, FirstDNSRow, LastDNSRow;

    NSInteger ConnectionConfigSection, FirstConnectionRow, LastConnectionRow;
    
    NSInteger RefreshSecondsSection, RefreshSecondsRow;
    NSInteger ConnectionTimeOutSecondsSection, ConnectionTimeOutSecondsRow;
    NSInteger TestDBReachabilitySection, TestDBReachabilityRow;
    NSInteger ReconnectDBSection, ReconnectDBRow;
    NSInteger ClearRunTimeInfoTalbeSection, ClearRunTimeInfoTalbeRow;
    NSInteger SetTimeSection, SetTimeRow;
    NSInteger HelpSection, HelpRow;

    
    UISwitch *Switch_ShowAllTime;
    UISwitch *Switch_GlobalAutoRefresh;

    UITableViewCell *Cell_Switch_ShowAllTime;
    UITableViewCell *Cell_Switch_GlobalAutoRefresh;
    
    

}



@property (strong, nonatomic) IBOutlet UITableView *TableView;

-(void)_CheckConnection;

@end

#endif /* ConfigViewController_h */
