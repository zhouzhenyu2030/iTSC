//
//  TradeSumViewController.h
//  iTSC
//
//  Created by tss on 2019/1/20.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef TradeSumViewController_h
#define TradeSumViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TradeSumsViewController: UITableViewController
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

//action

@end

#endif /* TradeSumViewController_h */
