//
//  PingHelper.h
//  iTSC
//
//  Created by tss on 2019/3/25.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef PingHelper_h
#define PingHelper_h

#import <Foundation/Foundation.h>
#import "SimplePing.h"
#import "MySimplePingDelegate.h"
#import <SystemConfiguration/SCNetworkReachability.h>


@interface PingHelper : NSObject
//{
//    SimplePing *_pinger;
 //   MySimplePingDelegate *_pingHelper;
//}

@property (nonatomic, strong) SimplePing *_pinger;
@property (nonatomic, strong) MySimplePingDelegate *_pingHelper;


-(bool) Ping:(NSString*)vDNSString;
-(void) Wait;
-(bool) isPinging;
-(bool) isPingFailed;
-(void) stop;


@end

#endif /* PingHelper_h */
