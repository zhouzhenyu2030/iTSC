//
//  GreeksViewController.h
//  iTSC
//
//  Created by tss on 2019/1/19.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef GreeksViewController_h
#define GreeksViewController_h

#import <UIKit/UIKit.h>


@interface GreeksViewController : UITableViewController
{
    NSInteger RefreshTimerElpasedSeconds;
    int RefreshCnt;
    UISwitch *Switch_AutoRefresh;
    UITableViewCell *RefreshSwitchCell;
    UITableViewCell *RefreshCountCell;
    UIRefreshControl *refreshControl;
    NSTimer* myTimer;
    bool isTimerProcessing;
}

@property (strong, nonatomic) IBOutlet UITableView *TableView;


@end


#endif /* GreeksViewController_h */
