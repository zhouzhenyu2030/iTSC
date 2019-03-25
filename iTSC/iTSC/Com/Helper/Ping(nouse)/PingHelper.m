//
//  PingHelper.m
//  iTSC
//
//  Created by tss on 2019/3/25.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <netinet/in.h>



#import "PingHelper.h"

@implementation PingHelper

//static SimplePing *_pinger;
//static MySimplePingDelegate *_pingHelper;
NSTimer* sendTimer ;



//ping
-(bool) Ping:(NSString*)vDNSString
{
    NSLog(@"PingHelper: Ping: DNSString=%@", vDNSString);
    //return true;
    

    
    // 1. 利用 HostName 创建 SimplePing
    //SimplePing* __pinger=[[SimplePing alloc] initWithHostName:vDNSString];//@"www.apple.com"]; //"8.8.8.8"
    //self._pinger = __pinger;
    self._pinger = [[SimplePing alloc] initWithHostName:vDNSString];//@"www.apple.com"];
    
    
    // 2. 指定 IP 地址类型
    //if (isIpv4 && !isIpv6) {
    self._pinger.addressStyle = SimplePingAddressStyleICMPv4;  //SimplePingAddressStyleAny;//
    //}else if (isIpv6 && !isIpv4) {
    //    pinger.addressStyle = SimplePingAddressStyleICMPv6;
    //}
    
    // 3. 设置 delegate,用于接收回调信息
    //MySimplePingDelegate *_MySimplePingDelegate=[[MySimplePingDelegate alloc] init];
    //self._pingHelper=_MySimplePingDelegate;
    
    self._pingHelper = [[MySimplePingDelegate alloc] init];
    self._pingHelper.isPinging = true;
    self._pingHelper.isPingFailed = false;
    self._pinger.delegate = self._pingHelper;
 
    // 4. 开始 ping
    [self._pinger start];
    
    //
    [self Wait];
    /*
     //Timer
     if(sendTimer==nil)
     {
     sendTimer =[NSTimer new];
     NSLog(@"PingHelper: sendTimer inited.");
     }
     */
    
    NSLog(@"PingHelper: Ping: is pinging.");
    return true;
}

//isPinging
-(bool) isPinging
{
    return self._pingHelper.isPinging;
}

//isPingFailed
-(bool) isPingFailed
{
    return self._pingHelper.isPingFailed;
}

//Wait
-(void)Wait
{
    while(self._pingHelper.isPinging)
    {
        sleep(1);
        //NSLog(@"PingHelper: Wait: hostName=%@, hostAddress=%@.", _pinger.hostName, _pinger.hostAddress);
    }
}

//stop
-(void) stop
{
    NSLog(@"PingHelper: stop.");
    if(self._pinger!=nil)
    {
        [self._pinger stop];
        self._pinger = nil;
    }
    
    if(sendTimer!=nil)
    {
        [sendTimer invalidate];
        sendTimer = nil;
    }
    
    self._pingHelper.isPinging = false;
}



//sendPing
-(void) sendPing
{
    [self._pinger sendPingWithData:nil];
}














/*
 
 - (NSString *)internetStatusOriginal {
 SCNetworkReachabilityRef reachability = NULL;
 SCNetworkConnectionFlags connectionFlags = 0;
 if (!reachability) {
 BOOL ignoresAdHocWifi = NO;
 struct sockaddr_in ipAddress;
 bzero(&ipAddress, sizeof(ipAddress));
 ipAddress.sin_len = sizeof(ipAddress);
 ipAddress.sin_family = AF_INET;
 ipAddress.sin_addr.s_addr = htonl(ignoresAdHocWifi ? INADDR_ANY : IN_LINKLOCALNETNUM);
 reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *)&ipAddress);
 }
 
 //设置监听网络改变
 SCNetworkReachabilityContext context = {0, (__bridge void*)self,NULL,NULL,NULL};
 if (SCNetworkReachabilitySetCallback(reachability, reachabilityCallBack, &context)) {
 if (SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), kCFRunLoopCommonModes)) {
 NSLog(@"绑定成功！！");
 }
 }
 //判断网络连接情况
 BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(reachability, &connectionFlags);
 if (!didRetrieveFlags) {
 NSLog(@"Error. Could not recover network reachability flags");
 }
 if ((connectionFlags & kSCNetworkFlagsReachable) != 0) {
 return @"网络可达";
 }
 else if ((connectionFlags & kSCNetworkFlagsConnectionRequired) != 0)
 {
 return @"需要连接";
 }
 else
 {
 return @"网络不可达";
 }
 }
 
 - (void)checkNetWorkTrans {
 AFNetworkReachabilityManager *managerAF = [AFNetworkReachabilityManager sharedManager];
 [managerAF startMonitoring];
 [managerAF setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
 switch (status) {
 case AFNetworkReachabilityStatusUnknown:
 NSLog(@"未知的网络类型");
 break;
 case AFNetworkReachabilityStatusReachableViaWiFi:
 NSLog(@"通过WIFI上网");
 break;
 case AFNetworkReachabilityStatusReachableViaWWAN:
 NSLog(@"通过3G/4G上网");
 break;
 case AFNetworkReachabilityStatusNotReachable:
 NSLog(@"当前网络不可达");
 break;
 }
 }];
 }
 
 -(NSString *)internetStatus {
 
 Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
 NetworkStatus internetStatus = [reachability currentReachabilityStatus];
 NSString *net = @"WIFI";
 switch (internetStatus) {
 case ReachableViaWiFi:
 net = @"WIFI";
 break;
 
 case ReachableViaWWAN:
 net = @"蜂窝数据";
 //net = [self getNetType ];   //判断具体类型
 break;
 
 case NotReachable:
 net = @"当前无网路连接";
 
 default:
 break;
 }
 
 return net;
 }
 
 
*/


@end
