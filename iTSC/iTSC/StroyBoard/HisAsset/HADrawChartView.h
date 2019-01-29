//
//  HisAssetChartViewController.h
//  iTSC
//
//  Created by tss on 2019/1/28.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef HisAssetChartView_h
#define HisAssetChartView_h


#import <UIKit/UIKit.h>
@import Charts;


@interface HADrawChartView : UIView
{
    LineChartView* _linechartView;
    
    NSInteger ScreenWidth;
    NSInteger ScreenHeight;
    
    double _scale;
}

-(void)Init;
- (void)initLineChartDataWithXvalueArr:(NSMutableArray*)xValueArr YvalueArr:(NSMutableArray*)yValueArr;


@end

#endif /* HisAssetChartView_h */
