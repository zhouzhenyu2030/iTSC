//
//  AvgEdgeViewController.h
//  iTSC
//
//  Created by tss on 2019/2/27.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef AvgEdgeViewController_h
#define AvgEdgeViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AvgEdgeViewController: UITableViewController
{
    NSInteger RefreshTimerElpasedSeconds;
    int RefreshCnt;
    UITableViewCell *RefreshCountCell;
    NSTimer* myTimer;
    bool isTimerProcessing;
}

//property
@property (strong, nonatomic) IBOutlet UITableView *TableView;



@end


#endif /* AvgEdgeViewController_h */
