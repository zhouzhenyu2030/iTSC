//
//  NetHelper.m
//  iTSC
//
//  Created by tss on 2019/9/24.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <netdb.h>   //dns
#import <arpa/inet.h>
#import <unistd.h>
#import <netinet/tcp.h>
#import <sys/time.h>    //select


#import "TscConfig.h"
#import "NetHelper.h"
#import "TscConnections.h"

@implementation NetHelper

static int _sockfd;
static TscConnection _con;
static NSString* _hostname;
static struct hostent* _hostent;
static char _ip[32];
static struct sockaddr_in addr_server;
static int _ret;

#define SUCCESS 1
#define FAIL -1


///////////////////////////////// TestServerReachability /////////////////////////////////
+(int)TestServerReachability
{

    //TscConnections
    _con = [TscConnections getCurrentConnection];
    NSLog(@"DBHelper: TestServerReachability: TscConnection = %@", _con.Name);
    
    //_hostname
    if(_con.isUsingDNS)
    {
        _hostname=[TscDNSs getCurrnetDNSString];
    }
    else
    {
        _hostname=_con.IP;
    }
    NSLog(@"NetHelper: TestServerReachability: connect: %@:%d", _hostname, _con.Port);

    
    //getIPFromHostName
    _ret = [self getIPFromHostName:_hostname];
    if(_ret < 0)
        return _ret;
 
 
    
    //注册套接字目的地址
    addr_server.sin_len = sizeof(struct sockaddr_in);
    addr_server.sin_family = AF_INET;
    addr_server.sin_port = htons(_con.Port);
    _ret = inet_pton(AF_INET, _ip, &addr_server.sin_addr);
 
    if(_ret != 1)
    {
        //显示server设定
        inet_ntop(AF_INET, &addr_server.sin_addr, _ip, 32);
        NSLog(@"NetHelper: TestServerReachability: inet_pton: ret=%d, ip=%s:%d", _ret, _ip, ntohs(addr_server.sin_port));
        return -6666;
    }
    
    
    //初始化套接字
    _sockfd = socket(AF_INET, SOCK_STREAM, 0);  //SOCK_DGRAM
    NSLog(@"NetHelper: TestServerReachability: _sockfd = %d", _sockfd);
    if(_sockfd < 0)
    {
        close(_sockfd);
        return -5555;
    }
    
    //_try_connect
    NSLog(@"NetHelper: TestServerReachability: testing...");
    //_ret = [self _try_connect];
    //NSLog(@"NetHelper: TestServerReachability: _try_connect: _ret = %d", _ret);
    _ret = connect(_sockfd, (struct sockaddr*)&addr_server, addr_server.sin_len);
    NSLog(@"NetHelper: TestServerReachability: connect: _ret = %d", _ret);
    
    //close
    close(_sockfd);
    NSLog(@"NetHelper: TestServerReachability: connect: close: _sockfd = %d", _sockfd);
    
    return _ret;
}



+(int)_try_connect
{
    //设置非阻塞模式
    
    int flags;
    flags = fcntl(_sockfd, F_GETFL, 0);
    if (flags == -1)
    {
        return -3001;
    }
    flags |= O_NONBLOCK;
    if (fcntl(_sockfd, F_SETFL, flags) == -1)
    {
        return -3002;
    }
     
    //NSLog(@"NetHelper: TestServerReachability: socket_set_non_blocking error.");
 
    
    
    //connect
    _ret = connect(_sockfd, (struct sockaddr*)&addr_server, addr_server.sin_len);
    NSLog(@"NetHelper: TestServerReachability: connect=%d",_ret);
    
    if(_ret<0)
    {
        //return _ret;
    }
    
    //
    //if (errno != EINPROGRESS && errno != EWOULDBLOCK)
    //    return -3003;
    
    //timeout
    int _secs=(int)[TscConfig ConnectionTimeOutSeconds];
    NSLog(@"NetHelper: TestServerReachability: ConnectionTimeOutSeconds=%d",_secs);
    
    struct timeval tv;
    tv.tv_sec = _secs;
    tv.tv_usec = 0;
    
    //select
    fd_set wset;
    FD_ZERO(&wset);
    FD_SET(_sockfd, &wset);
    
    int n = select(_sockfd + 1, NULL, &wset, NULL, &tv);
    if (n < 0)
    {    /* select出错 */
        return -3004;
    }
    else
    {
        if (n == 0)
        {
            /* 超时 */
            return -3005;
        }
    }
    return n;
}




///////////////////////////////// getConnectResultMsg /////////////////////////////////
+(NSString*)getConnectResultMsg:(int)vResult
{
    NSString* msg=[NSString stringWithFormat:@"Connect: \n%@(%s):%d\n", _hostname, _ip, _con.Port];
    switch (vResult)
    {
        case 0:
            msg=[msg stringByAppendingFormat:@"Success. %d", (int)vResult];
            break;
        default:
            msg=[msg stringByAppendingFormat: @"Fail. %d", (int)vResult];
            break;
    }
    return msg;
}


///////////////////////////////// SetAvailableDNS /////////////////////////////////
+(int) getIPFromHostName:(NSString*)vHostName
{
    //vHostName convert to char*
    const char * _chostname = [vHostName UTF8String];
    //NSLog(@"NetHelper: getIPFromHostName: vHostName=%@: _chostname=%s", vHostName, _chostname);
    
    //gethostbyname
    _hostent = gethostbyname(_chostname);
    if(_hostent == nil)
    {
        NSLog(@"NetHelper: getIPFromHostName: gethostbyname: _hostent=nil, ret=-9999");
        return -9999;
    }
    if(_hostent->h_addr_list == nil)
    {
        NSLog(@"NetHelper: getIPFromHostName: gethostbyname: _hostent->h_addr_list=nil, ret=-8888");
        return -8888;
    }
    
    //获取 IP 地址
    memset(_ip, 0, 32);
    inet_ntop(_hostent->h_addrtype, *_hostent->h_addr_list, _ip, sizeof(_ip));
 
    if(strlen(_ip)==0)
    {
        NSLog(@"NetHelper: getIPFromHostName: inet_ntop: _ip length=0, ret=-7777");
        return -7777;
    }
    else
    {
    //    NSLog(@"NetHelper: getIPFromHostName: inet_ntop: hostname=%@, ip=%s", vHostName, _ip);
    }
    
    return 0;
}


///////////////////////////////// SetAvailableDNS /////////////////////////////////
+(bool)SetAvailableDNS
{
    //当前DNS
    if([self TestServerReachability]==0)
        return true;
    
    //循环判断DNS
    /*
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
    */
    
    
    
    //连接不使用DNS的Connection
    /*
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
    */
    
    
    //如果都连不通，设置为none
    //[TscConnections SetCurrentConnection:(@"none")];
    //[TscDNSs SetCurrentDNS:(@"none")];
    [TscConfig setGlobalAutoRefresh:false];
    
    
    return false;
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    +(void) aaa
    {
        //no use
        //设置tcp超时
        int _secs=(int)[TscConfig ConnectionTimeOutSeconds];
        struct timeval timeo = {_secs, 0};   //{0,200000};//你想设置的超时时间 {tv_sec, tv_usec}
        int err = setsockopt(_sockfd, SOL_SOCKET, SO_RCVTIMEO, &timeo, sizeof(timeo));
        if (err)
        {
            NSLog(@"SO_RCVTIMEO: 设置超时失败");
        }
        err = setsockopt(_sockfd, SOL_SOCKET, SO_SNDTIMEO, &timeo, sizeof(timeo));
        if (err)
        {
            NSLog(@"SO_SNDTIMEO: 设置超时失败");
        }
        NSLog(@"NetHelper: TestServerReachability: ConnectionTimeOutSeconds=%d",_secs);
    }

    
    
@end
