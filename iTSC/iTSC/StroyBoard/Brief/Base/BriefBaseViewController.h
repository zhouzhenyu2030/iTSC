//
//  BriefBaseViewController.h
//  iTSC
//
//  Created by tss on 2020/2/22.
//  Copyright © 2020 tss. All rights reserved.
//

#ifndef BriefBaseViewController_h
#define BriefBaseViewController_h

#import <UIKit/UIKit.h>


@interface BriefBaseViewController: UITableViewController
{
    NSString* zLogStr;
    
    UITableView *zTableView;
    
    NSInteger RefreshTimerElpasedSeconds;
    int RefreshCnt;
    UISwitch *Switch_AutoRefresh;
    UITableViewCell *RefreshCountCell;
    UIRefreshControl *refreshControl;
    NSTimer* myTimer;
    bool isTimerProcessing;
    
    NSString* zCondStr;
    NSString* zTableName;
    NSArray *tasks;
}




//action
-(void) SetLogStr;
-(void) SetTableView;
-(void) InitTableViewCells:(BOOL)vInitAll;
-(void) SetQureyCondition;
-(void) QueryAndDisplay;

@end

#endif /* BriefBaseViewController_h */
