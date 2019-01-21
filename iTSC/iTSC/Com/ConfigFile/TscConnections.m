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


static NSMutableDictionary *Connections;
static NSString *_CurrentConnectionKey;
static NSUserDefaults *_UserDefaults;


@implementation TscConnections


NSValue *value = nil;


//init
+(void) Init
{
    _UserDefaults = [NSUserDefaults standardUserDefaults];
    
    Connections = [[NSMutableDictionary alloc]init];
    
    [self initDefault];
    [self saveConnections];
    
    _CurrentConnectionKey = [self SetCurrentConnection:[_UserDefaults stringForKey:@"CurrentConnectionKey"]];
}

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



//default
+(void) initDefault
{
    TscConnection _con;
    
    
    _con.Name=@"148";
    _con.IP=@"101.226.255.148";
    _con.Port=30003;
    _con.UserName=@"opt";
    _con.UserPassword=@"Hr@2017yy";
    _con.dbName=@"tss";
    _con.AccountID = @"AccountID=1202";
    value = [NSValue valueWithBytes:&_con objCType:@encode(TscConnection)];
    [Connections setObject:value forKey:_con.Name];
    
    _con.Name=@"158";
    _con.IP=@"zhouzhenyu.imwork.net";
    _con.Port=15833;
    _con.UserName=@"root";
    _con.UserPassword=@"z";
    _con.dbName=@"tss";
    _con.AccountID = @"AccountID=11";
    value = [NSValue valueWithBytes:&_con objCType:@encode(TscConnection)];
    [Connections setObject:value forKey:_con.Name];
    
    _con.Name=@"138";
    _con.IP=@"zhouzhenyu.imwork.net";
    _con.Port=13833;
    _con.UserName=@"root";
    _con.UserPassword=@"z";
    _con.dbName=@"tss";
    _con.AccountID = @"AccountID=11";
    value = [NSValue valueWithBytes:&_con objCType:@encode(TscConnection)];
    [Connections setObject:value forKey:_con.Name];
    
    _con.Name=@"128";
    _con.IP=@"192.168.1.128";
    _con.Port=3306;
    _con.UserName=@"root";
    _con.UserPassword=@"z";
    _con.dbName=@"tss";
    _con.AccountID = @"AccountID=11";
    value = [NSValue valueWithBytes:&_con objCType:@encode(TscConnection)];
    [Connections setObject:value forKey:_con.Name];
    
    _con.Name=@"168";
    _con.IP=@"zhouzhenyu.imwork.net";
    _con.Port=16833;
    _con.UserName=@"root";
    _con.UserPassword=@"z";
    _con.dbName=@"tss";
    _con.AccountID = @"AccountID=11";
    value = [NSValue valueWithBytes:&_con objCType:@encode(TscConnection)];
    [Connections setObject:value forKey:_con.Name];
    
    
    for(id key in Connections)
    {
        value = [Connections objectForKey:key];
        [value getValue:&_con];
        NSLog(@"key: %@,value: %@",key,value);
    }
    
    
    _CurrentConnectionKey = @"148";
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
