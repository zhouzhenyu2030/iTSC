//
//  TscConfig.h
//  iTSC
//
//  Created by tss on 2019/1/16.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef TscConst_h
#define TscConst_h

#import <UIKit/UIKit.h>
#import "HADrawChartView.h"
#import "HADrawChartViewController.h"

@interface TscConst : NSObject


+(HADrawChartViewController*) HADrawChartViewController;
+(void) setHADrawChartViewController:(HADrawChartViewController*) vValue;


+(HADrawChartView*) HADrawChartView;
+(void) setHADrawChartView:(HADrawChartView*) vValue;



@end

#endif /* TscConfig_h */
