//
//  main.m
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TscConfig.h"
#import "TscConnections.h"
#import "DBHelper.h"
#import "NetHelper.h"

int main(int argc, char * argv[])
{
    
  
    @autoreleasepool
    {
        //设置不被SIGPIPE信号中断，物理链路损坏时才不会导致程序直接被Terminate
        //在网络异常的时候如果程序收到SIGPIRE是会直接被退出的。
        struct sigaction sa;
        sa.sa_handler = SIG_IGN;
        sigaction( SIGPIPE, &sa, 0 );
        

        [TscConfig Init];
        [TscDNSs Init];
        [TscConnections Init];
        

        [NetHelper SetAvailableDNS];

        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}






//PingHelper* _h=[[PingHelper alloc] init];

//[_h Ping:[TscDNSs getCurrnetDNSString]];
//[_h Wait];
//while(true)
//{
//    sleep(1);
//NSLog(@"PingHelper: Wait: hostName=%@, hostAddress=%@.", _pinger.hostName, _pinger.hostAddress);
//}
//return 0;
