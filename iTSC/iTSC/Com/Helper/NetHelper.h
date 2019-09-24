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

+(int)TestServerReachability;
+(NSString*)getConnectResultMsg:(int)vResult;

+(bool)SetAvailableDNS;


@end

#endif /* NetHelper_h */
