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
#import <arpa/inet.h>
#import <unistd.h>
#import <netinet/tcp.h>

#import "NetHelper.h"
#import "TscConnections.h"

@implementation NetHelper

static int _sockfd;
static TscConnection _con;
static NSString* _address;


///////////////////////////////// TestServerReachability /////////////////////////////////
+(int)TestServerReachability
{
    //初始化套接字
    if(_sockfd == 0)
        _sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    NSLog(@"NetHelper: TestServerReachability: _sockfd = %d", _sockfd);
    
    
    //TscConnections
    _con = [TscConnections getCurrentConnection];
    NSLog(@"DBHelper: TestServerReachability: TscConnection = %@", _con.Name);
    
    //address
    if(_con.isUsingDNS)
    {
        _address=[TscDNSs getCurrnetDNSString];
    }
    else
    {
        _address=_con.IP;
    }
    NSLog(@"NetHelper: TestServerReachability: connect: %s:%d", _address.UTF8String, _con.Port);

    //注册套接字目的地址
    struct sockaddr_in addr_server;
    addr_server.sin_len = sizeof(struct sockaddr_in);
    addr_server.sin_family = AF_INET;
    addr_server.sin_port = htons(_con.Port);
    inet_pton(AF_INET, _address.UTF8String, &addr_server.sin_addr);
    
    //connet
    NSLog(@"NetHelper: TestServerReachability: connecting");
    int _ret = connect(_sockfd, (struct sockaddr*)&addr_server, addr_server.sin_len);
    NSLog(@"NetHelper: TestServerReachability: connect: _ret = %d", _ret);
    if ( _ret == 0)
    {
        shutdown(_sockfd,0);
        NSLog(@"NetHelper: TestServerReachability: connect: shutdown: _sockfd = %d", _sockfd);
    }
    
    return _ret;
}



///////////////////////////////// getConnectResultMsg /////////////////////////////////
+(NSString*)getConnectResultMsg:(int)vResult
{
    NSString* msg=[NSString stringWithFormat:@"Connect: \n%@:%d\n", _address, _con.Port];
    switch (vResult)
    {
        case 0:
            msg=[msg stringByAppendingFormat:@"Success. %d", (int)vResult];
            break;
        default:
            msg=[msg stringByAppendingFormat: @"Error. %d", (int)vResult];
            break;
    }
    return msg;
}


///////////////////////////////// TestConnect /////////////////////////////////
+(bool)TestConnect:(NSString*)vDNSName
{
    NSLog(@"NetHelper: TestConnect. %@", vDNSName);
    [TscDNSs SetCurrentDNS:vDNSName];
    return [self TestServerReachability];
}

///////////////////////////////// SetAvailableDNS /////////////////////////////////
+(bool)SetAvailableDNS
{
    //当前DNS
    if([self TestServerReachability]==0)
        return true;
    
    //循环判断DNS
    NSArray *DNSNames = [TscDNSs getDNSNames];
    for (NSString *d in DNSNames)
    {
        if([self TestConnect:d]==0)
        {
            return true;
        }
    }
    
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
    [TscConnections SetCurrentConnection:(@"none")];
    [TscDNSs SetCurrentDNS:(@"none")];
    
    return false;
}

@end
