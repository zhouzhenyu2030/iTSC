//
//  ThreadHelper.m
//  iTSC
//
//  Created by tss on 2019/9/25.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pthread.h>

#import "TscConfig.h"
#import "TscConnections.h"
#import "DBHelper.h"
#import "NetHelper.h"
#import "ThreadHelper.h"





@implementation ThreadHelper

static pthread_t _thread = nil;

static bool _isThreadCanRun = false;
static bool _isThreadSuspend = false;
static bool _isDNSSet = false;

static int _ThreadLoopCnt;

static NSLock *_thread_locker = nil;



+(int)ThreadLoopCnt
{
    return _ThreadLoopCnt;
}



+(void) Start
{
    _ThreadLoopCnt = 0;
    _isThreadCanRun = true;
    _isThreadSuspend = false;
    _isDNSSet = false;
    pthread_create(&_thread, NULL, _thread_task_test_dns, NULL);
    pthread_detach(_thread);
}



void* _thread_task_test_dns(void *param)
{
    _isDNSSet = true;
    
    [NetHelper TestServerReachability];
    
    pthread_create(&_thread, NULL, _thread_task_db_connection_test, NULL);
    pthread_detach(_thread);
    
     return NULL;
}



void* _thread_task_db_connection_test(void *param)
{
    //while
    while(_isThreadCanRun)
    {
        sleep(1);
        
        if(_isThreadSuspend)
            continue;
        

        [DBHelper CheckConnect];
        _ThreadLoopCnt++;
    }
    
    
    //DB Disconnect
    [DBHelper Disconnect1];

    return NULL;
}



+(void) Stop
{
    _isThreadCanRun = false;
}



//////////////////////// Suspend & Resume ////////////////////////
+(void)Suspend
{
    _isThreadSuspend = true;
}

+(void)Resume
{
    _isThreadSuspend = false;
}



//////////////////////// Lock & UnLock ////////////////////////
+(void)Lock
{
    [_thread_locker lock];
}
+(void)UnLock
{
    [_thread_locker unlock];
}



@end









/*
 void SetAvailableDNS()
 {
 //当前DNS
 if([NetHelper TestServerReachability]==0)
 return;
 
 //循环判断DNS
 NSArray *DNSNames = [TscDNSs getDNSNames];
 for (NSString *d in DNSNames)
 {
 NSLog(@"NetHelper: TestConnect. %@", d);
 [TscDNSs SetCurrentDNS:d];
 if([self TestServerReachability]==0)
 {
 return true;
 }
 }
 



//连接不使用DNS的Connection
 NSArray *ConnectionKeys = [TscConnections getConnectionKeys];
 for (NSString *c in ConnectionKeys)
 {
 if([TscConnections getConnection:(c)].isUsingDNS == false)
 {
 [TscConnections SetCurrentConnection:c];
 if([self Connect])
 return true;
 }
 }
 


//如果都连不通，设置为none
//[TscConnections SetCurrentConnection:(@"none")];
//[TscDNSs SetCurrentDNS:(@"none")];
//[TscConfig setGlobalAutoRefresh:false];


}
*/
