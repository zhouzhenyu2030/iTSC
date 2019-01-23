//
//  Asset.h
//  iTSC
//
//  Created by tss on 2019/1/20.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef Asset_h
#define Asset_h

#import <UIKit/UIKit.h>

@interface AssetViewController: UITableViewController
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


#endif /* Asset_h */
