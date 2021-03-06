//
//  SecondViewController.h
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlViewController : UITableViewController
{
    NSInteger RefreshTimerElpasedSeconds;
    UIRefreshControl *refreshControl;
    NSTimer* myTimer;
    bool isTimerProcessing;
    NSInteger RefreshCnt;
    UITableViewCell *RefreshCountCell;
    UITableViewCell *ThreadLoopCntCell;
    
    
    //GlobalStart
    UISwitch *Switch_AT_DBStart;
    UISwitch *Switch_AH_DBStart;

    UITableViewCell *Cell_AT_DBStart;
    UITableViewCell *Cell_AH_DBStart;
    UITableViewCell *Cell_DBGlobalStart_Value;
    
    NSInteger ParaValue;
    Boolean isATStarted;
    Boolean isAHStarted;

    
    //AClose
    UISwitch *Switch_AC_Start;
    UISwitch *Switch_AC_StartConfirm;
    UITableViewCell *Cell_AC_Start;
    UITableViewCell *Cell_AC_StartConfirm;

    




}




@property (strong, nonatomic) IBOutlet UITableView *TableView;


- (void)GenParaValue;


@end

