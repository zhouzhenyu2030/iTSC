//
//  StatusViewControler.h
//  iTSC
//
//  Created by tss on 2020/2/22.
//  Copyright © 2020 tss. All rights reserved.
//

#ifndef StatusViewControler_h
#define StatusViewControler_h

#import <UIKit/UIKit.h>

@interface StatusViewController: UITableViewController
{
        NSInteger RefreshTimerElpasedSeconds;
        int RefreshCnt;
        UISwitch *Switch_AutoRefresh;
    //    UITableViewCell *RefreshSwitchCell;
        UITableViewCell *RefreshCountCell;
        UIRefreshControl *refreshControl;
        NSTimer* myTimer;
        bool isTimerProcessing;
}



//property
@property (strong, nonatomic) IBOutlet UITableView *TableView;

//action

@end


#endif /* StatusViewControler_h */
