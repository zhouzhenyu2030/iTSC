//
//  PositionViewController.h
//  iTSC
//
//  Created by tss on 2019/1/21.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef PositionViewController_h
#define PositionViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PositionViewController: UITableViewController
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


#endif /* PositionViewController_h */
