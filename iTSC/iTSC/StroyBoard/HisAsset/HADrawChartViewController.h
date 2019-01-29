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


@interface HADrawChartViewController : UIViewController
{
    LineChartView* _linechartView;
    
    NSInteger ScreenWidth;
    NSInteger ScreenHeight;
    
    double _scale;
}


- (void)initLineChartDataWithXvalueArr:(NSMutableArray*)xValueArr YvalueArr:(NSMutableArray*)yValueArr;


@end

#endif /* HisAssetChartViewController_h */
