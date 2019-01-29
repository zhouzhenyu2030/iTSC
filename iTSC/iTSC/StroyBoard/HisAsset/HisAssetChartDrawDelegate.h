//
//  HisAssetChartDrawDelegate.h
//  iTSC
//
//  Created by tss on 2019/1/29.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//NS_ASSUME_NONNULL_BEGIN



@protocol HisAssetChartDrawDelegate <NSObject>

@required
//必须实现的方法
- (void)initLineChartDataWithXvalueArr:(NSMutableArray*)xValueArr YvalueArr:(NSMutableArray*)yValueArr;

@end



//NS_ASSUME_NONNULL_END
