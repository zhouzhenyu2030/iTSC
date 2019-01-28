//
//  HisAssetChartViewController.h
//  iTSC
//
//  Created by tss on 2019/1/28.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef HisAssetChartViewController_h
#define HisAssetChartViewController_h


#import <UIKit/UIKit.h>
@import Charts;


@interface HisAssetChartViewController : UIViewController
{
    NSUserDefaults *_UserDefaults;
    
    
    
    NSInteger RefreshTimerElpasedSeconds;
    UIRefreshControl *refreshControl;
    NSTimer* myTimer;
    bool isTimerProcessing;
    NSInteger RefreshCnt;
    UITableViewCell *RefreshCountCell;
    
    
    NSDateFormatter *dateFormatter;
    NSString *strDate;
    
    LineChartView* _linechartView;
    NSInteger ScreenWidth;
    NSInteger ScreenHeight;
    
    NSMutableArray* xValueArr;
    NSMutableArray* yValueArr;
    
    double _scale;
}



@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;

- (IBAction)ButtonClick:(id)sender;


@end

#endif /* HisAssetChartViewController_h */
