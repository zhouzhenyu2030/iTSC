//
//  TscConnections.m
//  iTSC
//
//  Created by tss on 2019/1/19.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBHelper.h"
#import "TscConnections.h"


//
static NSUserDefaults *_UserDefaults;
NSValue *value = nil;

//DNS
static NSMutableDictionary *DNSs;
static NSString *_CurrentDNSName;

//Connection
static NSMutableDictionary *Connections;
static NSString *_CurrentConnectionKey;




@implementation TscConnections




///////////////////////////////////// init /////////////////////////////////////
+(void) Init
{
    _UserDefaults = [NSUserDefaults standardUserDefaults];
    
    DNSs= [[NSMutableDictionary alloc]init];
    Connections = [[NSMutableDictionary alloc]init];
    
    [self initDefault];
    //[self saveConnections];
    
    _CurrentDNSName = [self SetCurrentDNS:[_UserDefaults stringForKey:@"CurrentDNSName"]];
    
    _CurrentConnectionKey = [self SetCurrentConnection:[_UserDefaults stringForKey:@"CurrentConnectionKey"]];
}




///////////////////////////////////// initDefault ///////////////////////////////////
+(void) initDefault
{
    
    //DNS
    TscDNS _dns;
    
    _dns.Name=@"imwork";
    _dns.DNS=@"zhouzhenyu.imwork.net";
    value = [NSValue valueWithBytes:&_dns objCType:@encode(TscDNS)];
    [DNSs setObject:value forKey:_dns.Name];
    
    _dns.Name=@"kmdns";
    _dns.DNS=@"zhouzhenyu2005.kmdns.net";
    value = [NSValue valueWithBytes:&_dns objCType:@encode(TscDNS)];
    [DNSs setObject:value forKey:_dns.Name];
    
    
    
    //Connection
    TscConnection _con;
    
    _con.Name=@"138";
    _con.IP=@"zhouzhenyu2005.kmdns.net";
    _con.Port=13833;
    _con.UserName=@"root";
    _con.UserPassword=@"z";
    _con.dbName=@"tss";
    _con.AccountID = @"AccountID=0";
    value = [NSValue valueWithBytes:&_con objCType:@encode(TscConnection)];
    [Connections setObject:value forKey:_con.Name];
    
    
    _con.Name=@"158";
    _con.IP=@"zhouzhenyu2005.kmdns.net";
    _con.Port=15833;
    _con.UserName=@"root";
    _con.UserPassword=@"z";
    _con.dbName=@"tss";
    _con.AccountID = @"AccountID=0";
    value = [NSValue valueWithBytes:&_con objCType:@encode(TscConnection)];
    [Connections setObject:value forKey:_con.Name];
    
    
    _con.Name=@"168";
    _con.IP=@"zhouzhenyu2005.kmdns.net";
    _con.Port=16833;
    _con.UserName=@"root";
    _con.UserPassword=@"z";
    _con.dbName=@"tss";
    _con.AccountID = @"AccountID=0";
    value = [NSValue valueWithBytes:&_con objCType:@encode(TscConnection)];
    [Connections setObject:value forKey:_con.Name];
    
    
    
    _con.Name=@"148";
    _con.IP=@"101.226.255.148";
    _con.Port=30003;
    _con.UserName=@"opt";
    _con.UserPassword=@"Hr@2017yy";
    _con.dbName=@"tss";
    _con.AccountID = @"AccountID=1202";
    value = [NSValue valueWithBytes:&_con objCType:@encode(TscConnection)];
    [Connections setObject:value forKey:_con.Name];
    
    
    
    for(id key in Connections)
    {
        value = [Connections objectForKey:key];
        [value getValue:&_con];
        NSLog(@"TscConnections: initDefault: key: %@",key);
    }
    
    
    _CurrentConnectionKey = @"158";
}




///////////////////////////////////// DNS ///////////////////////////////////
+(NSString*) CurrentDNSName
{
    return _CurrentDNSName;
}

+(TscDNS) getDNS:(NSString*) vName
{
    TscDNS _dns;
    value = [DNSs objectForKey:vName];
    if(value!=nil)
    {
        [value getValue:&_dns];
        NSLog(@"TscConnections: getDNS: Found. vName=%@, DNS= %@",vName, _dns.DNS);
    }
    else
    {
        _dns.Name=@"imwork";
        _dns.DNS=@"zhouzhenyu.imwork.net";
        NSLog(@"TscConnections: getDNS: not Found, return Defautl. vName=%@, DNS= %@",vName, _dns.DNS);
    }
 
    return _dns;
}

+(NSString*) SetCurrentDNS:(NSString*) vDNSName
{
    if(vDNSName != nil)
    {
        if([vDNSName isEqualToString:_CurrentDNSName] == false)
        {
            TscDNS _dns = [self getDNS:vDNSName];
            _CurrentDNSName = _dns.Name;
            [_UserDefaults setValue:_CurrentDNSName forKey:(@"CurrentDNSName")];
        }
    }
    
    return _CurrentDNSName;
}




/////////////////////////////////// Connection ///////////////////////////////////
//Count
+(NSInteger) Count
{
    return Connections.count;
}

//get
+(TscConnection) getConnection:(NSString*) vName
{
    TscConnection _con;
    value = [Connections objectForKey:vName];
    [value getValue:&_con];
    NSLog(@"key: %@,value: %@",vName,value);
    return _con;
}
+(TscConnection) getCurrentConnection
{
    return [self getConnection:_CurrentConnectionKey];
}


//getConnectionArray
+(NSMutableDictionary*) getConnectionArray
{
    return Connections;
}

//getConnectionKeys
+(NSArray*) getConnectionKeys
{
    return [Connections allKeys];
}



//saveConnections
+(void) saveConnections
{
    //把字典写入到plist文件，比如文件path为：~/Documents/data.plist
    NSString* path = @"~/Documents/data.plist";
    [Connections writeToFile:path atomically:YES];
    //把数组写入到plist文件中
    //[array writeToFile:path atomically:YES];
    
    //NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:(nonnull NSString *)]];
    //NSDictionary *dictionary =  [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(nullable NSString *) ofType:(nullable NSString *)]];
    
    //NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:(nonnull NSString *)]];
    //NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(nullable NSString *) ofType:(nullable NSString *)]];

}

//loadConnections
+(void) loadConnections
{
    //CurrentConnectionKey;
    //NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:(nonnull NSString *)]];
    //NSDictionary *dictionary =  [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(nullable NSString *) ofType:(nullable NSString *)]];
    
    //NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:(nonnull NSString *)]];
    //NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(nullable NSString *) ofType:(nullable NSString *)]];
    
}


//CurrentConnection
+(NSString*) CurrentConnectionKey
{
    return _CurrentConnectionKey;
}
+(NSString*) SetCurrentConnection:(NSString*) vConnectionKey
{
    if(vConnectionKey != nil)
    {
        if([vConnectionKey isEqualToString:_CurrentConnectionKey] == false)
        {
            TscConnection _con = [self getConnection:vConnectionKey];
            _CurrentConnectionKey = _con.Name;
            [_UserDefaults setValue:_CurrentConnectionKey forKey:(@"CurrentConnectionKey")];
            [DBHelper Reconnect];
        }
    }
    
    return _CurrentConnectionKey;
}





@end
