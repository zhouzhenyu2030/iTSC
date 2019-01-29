//
//  HisAssetQueryViewController.h
//  iTSC
//
//  Created by tss on 2019/1/29.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef HisAssetQueryViewController_h
#define HisAssetQueryViewController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface HisAssetQueryViewController : UIViewController
{

    NSUserDefaults *_UserDefaults;
    
    NSInteger RefreshTimerElpasedSeconds;
    UIRefreshControl *refreshControl;
    NSTimer* myTimer;
    bool isTimerProcessing;
    NSInteger RefreshCnt;
    UITableViewCell *RefreshCountCell;
    
    
    NSMutableArray* xValueArr;
    NSMutableArray* yValueArr;
    
    
}


    - (IBAction)ButtonClick:(id)sender;



@end

#endif /* HisAssetQueryViewController_h */
