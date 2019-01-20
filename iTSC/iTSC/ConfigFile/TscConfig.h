//
//  TscConfig.h
//  iTSC
//
//  Created by tss on 2019/1/16.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef TscConfig_h
#define TscConfig_h



@interface TscConfig : NSObject

+(void) Init;


+(Boolean) isInBackground;
+(void) setInBackground:(Boolean) vValue;


+(Boolean) isShowAllTime;
+(void) setShowAllTime:(Boolean) vValue;



+(Boolean) isGlobalAutoRefresh;
+(void) setGlobalAutoRefresh:(Boolean) vValue;

+(Boolean) isAssetAutoRefresh;
+(void) setAssetAutoRefresh:(Boolean) vValue;

+(Boolean) isGreekAutoRefresh;
+(void) setGreekAutoRefresh:(Boolean) vValue;

+(Boolean) isTradeSumAutoRefresh;
+(void) setTradeSumAutoRefresh:(Boolean) vValue;



@end

#endif /* TscConfig_h */
