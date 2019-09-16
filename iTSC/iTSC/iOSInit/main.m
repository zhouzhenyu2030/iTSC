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

int main(int argc, char * argv[]) {
    
  
    @autoreleasepool
    {
        [TscConfig Init];
        [TscDNSs Init];
        [TscConnections Init];
        
        //[DBHelper SetAvailableDNS];
        
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
