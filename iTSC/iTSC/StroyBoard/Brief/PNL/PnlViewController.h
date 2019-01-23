//
//  PnlViewController.h
//  iTSC
//
//  Created by tss on 2019/1/21.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef PnlViewController_h
#define PnlViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PnlViewController: UITableViewController
{
    NSInteger RefreshTimerElpasedSeconds;
    int RefreshCnt;
    UISwitch *Switch_AutoRefresh;
    UITableViewCell *RefreshCountCell;
    UITableViewCell *RefreshSwitchCell;
    UIRefreshControl *refreshControl;
    NSTimer* myTimer;
    bool isTimerProcessing;
}



//property
@property (strong, nonatomic) IBOutlet UITableView *TableView;

@end


#endif /* PnlViewController_h */
