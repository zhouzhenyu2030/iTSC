//
//  TscConfig.m
//  iTSC
//
//  Created by tss on 2019/1/16.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TscConst.h"



@implementation TscConst



//HisAssetDrawChartViewController
static HADrawChartViewController* _HADrawChartViewController;
+(HADrawChartViewController*) HADrawChartViewController
{
    return _HADrawChartViewController;
}
+(void) setHADrawChartViewController:(HADrawChartViewController*) vValue
{
    _HADrawChartViewController=vValue;
}



static HADrawChartView* _HADrawChartView;
+(HADrawChartView*) HADrawChartView
{
    return _HADrawChartView;
}
+(void) setHADrawChartView:(HADrawChartView*) vValue
{
    _HADrawChartView=vValue;
}


@end


