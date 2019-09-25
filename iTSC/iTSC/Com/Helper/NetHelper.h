//
//  NetHelper.h
//  iTSC
//
//  Created by tss on 2019/9/24.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef NetHelper_h
#define NetHelper_h

@interface NetHelper:NSObject


+(int) getIPFromHostName:(NSString*)vHostName;

+(int)TestServerReachability;
+(NSString*)getConnectResultMsg:(int)vResult;


+(int)_block_connect;
+(int)_nonblock_connect;

@end

#endif /* NetHelper_h */
