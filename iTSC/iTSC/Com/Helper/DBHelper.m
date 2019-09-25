//
//  DBHelper.m
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHelper.h"
#import "UIHelper.h"
#import "TscConnections.h"
#import "NetHelper.h"
#import "TscConfig.h"

//static
static bool _isConnected;
static bool _isWillDisconnect;
static OHMySQLUser *_user;
static OHMySQLStoreCoordinator *_coordinator;
static OHMySQLQueryContext *_queryContext;

static NSLock *_db_locker = nil;
static bool _isThreadProcessing;

static bool _isWillQuery;
static NSString* _CurrentConnectionKey;

@implementation DBHelper



+(NSString*) CurrentConnectionKey
{
    if(_isConnected)
        return _CurrentConnectionKey;
    else
        return [_CurrentConnectionKey stringByAppendingString:@" (disconnected)"];
}


//////////////////////// Init ////////////////////////
+(void)Init
{
    _db_locker = [[NSLock alloc] init];
    _isThreadProcessing = false;
    
    _isWillDisconnect = false;
    _isConnected = false;
    
    _user = [OHMySQLUser alloc];
    _coordinator = [OHMySQLStoreCoordinator alloc];
    _queryContext = [OHMySQLQueryContext new];
    _queryContext.storeCoordinator = _coordinator;
    
    _isWillQuery = false;
    _CurrentConnectionKey = @"";
}



//////////////////////// GetContext ////////////////////////
+(OHMySQLQueryContext *)GetContext
{
    //isGlobalAutoRefresh
    if([TscConfig isGlobalAutoRefresh] == false)
    {
        NSLog(@"DBHelper: GetContext: isGlobalAutoRefresh = false.");
        return nil;
    }
    
    //是否有断开原连接申请
    if(_isWillDisconnect == true)
    {
        [_coordinator disconnect];
        _isWillDisconnect = false;
        _isConnected = false;
        NSLog(@"DBHelper: GetContext: _coordinator _isWillDisconnect = true.");
        return nil;
    }

    //连接是否正常
    if([_coordinator isConnected] == false)
    {
        _isConnected = false;
        NSLog(@"DBHelper: GetContext: _coordinator isConnected = false.");
        return nil;
    }
    

    _isConnected = true;
    return _queryContext;
    
}
+(bool)BeginQuery
{
    //_isWillQuery = true;
    if(_isThreadProcessing == true)
    {
        NSLog(@"DBHelper: BeginQuery: _isThreadProcessing = true.");
        return false;
    }
    
    NSLog(@"DBHelper: BeginQuery: lock.");
    [self Lock];
    return true;
}
+(void)EndQuery
{
    NSLog(@"DBHelper: EndQuery.");
    //_isWillQuery = false;
    [self UnLock];
}







//////////////////////// CheckConnect ////////////////////////
+(void)CheckConnect
{
    //isGlobalAutoRefresh
    if([TscConfig isGlobalAutoRefresh] == false)
    {
        _isThreadProcessing = false;
        NSLog(@"BHelper: CheckConnect: isGlobalAutoRefresh = false.");
        return;
    }
    
    //检查连接是否正常
    if(_isConnected == true)
    {
        _isThreadProcessing = false;
        NSLog(@"DBHelper: CheckConnect: _isConnected = true.");
        return;
    }
    
    //是否有查询请求
    if(_isWillQuery == true)
    {
        _isThreadProcessing = false;
        return;
    }
    
    //建立连接
    _isThreadProcessing = true;
    [DBHelper Lock];
    //connect
    bool isOK = [self Connect1];
    if( isOK == true)
    {
        //连接成功
        _isConnected = true;
        NSLog(@"DBHelper: CheckConnect: Connect = true.");
    }
    else
    {
        //连接失败
        _isConnected = false;
        NSLog(@"DBHelper: CheckConnect: Connect = false.");
    }
    [DBHelper UnLock];
    _isThreadProcessing = false;
}



//////////////////////// Connect ////////////////////////
+(bool)Connect1
{
    //getCurrentConnection
    TscConnection _con = [TscConnections getCurrentConnection];
    NSLog(@"DBHelper: Connect: TscConnection = %@", _con.Name);
    _CurrentConnectionKey = _con.Name;
    
    
    //getCurrnetDNSString
    NSString* _address;
    if(_con.isUsingDNS)
    {
        _address=[TscDNSs getCurrnetDNSString];
    }
    else
    {
        _address=_con.IP;
    }
    
    
    //user
    _user = [_user initWithUserName:_con.UserName
                           password:_con.UserPassword
                         serverName:_address
                             dbName:_con.dbName
                               port:_con.Port
                             socket:nil];
    
    
    //coordinator
    _coordinator = [_coordinator initWithUser:_user];
    
    
    //_coordinator connect
    NSLog(@"DBHelper: Connect: _coordinator is connecting...");
    
    [_coordinator connect];
    
    if([_coordinator isConnected] == false)
    {
        NSLog(@"DBHelper: Connect: _coordinator isConnected = false!");
        _isConnected = false;
        return false;
    }
    
    _isConnected = true;
    NSLog(@"DBHelper: Connect: connected.");
    
    return true;
    
}




//////////////////////// Disconnect ////////////////////////
+(void)Disconnect1
{
    _isConnected = false;
    [_coordinator disconnect];
    NSLog(@"DBHelper: Disconnect.");
}


//////////////////////// SetToDisconnect ////////////////////////
+(void)SetToDisconnect
{
    _isConnected = false;
    _isWillDisconnect = true;
    NSLog(@"DBHelper: SetToDisconnect.");
}


//////////////////////// Lock & UnLock ////////////////////////
+(void)Lock
{
    [_db_locker lock];
}
+(void)UnLock
{
    [_db_locker unlock];
}


@end






/*
 //////////////////////// Reconnect ////////////////////////
 +(bool) Reconnect
 {
 [self Disconnect];
 return [self Connect];
 }

 

 
 
 
 
 
 //返回数据库路径，保存到Cache目录下
 -(NSString *)databasePath
 {
 NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
 
 return [path stringByAppendingPathComponent:@"contacts.db"];
 }
 
 
 
 
 
 
 
 -(void)getdata
 {
 
 //数据库对象
 sqlite3 *contactDB;
 const char *path = [[self databasePath] UTF8String];
 
 if (sqlite3_open(path, &contactDB) == SQLITE_OK)
 {
 char *errMsg;
 const char *sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS(ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT,PHONE TEXT)";
 //执行语句
 if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
 {
 //创建表失败
 }
 }
 else
 {
 //打开数据库失败
 }
 sqlite3_close(contactDB);
 
 }
 
 
 //Ping no use
 +(OHResultErrorType)PingSQL:(bool)visInit
 {
 //需_coordinator connect，不合用
 //
 if(visInit)
 {
 //SetCoordinator
 _coordinator = nil;
 _queryContext = nil;
 if([self SetCoordinator]==false)
 return -8888;
 }
 if(_coordinator == nil)
 {
 return -9999;
 }
 
 //ping
 return [_coordinator pingMySQL];
 }
 
 //getPingResultMsg no use
 +(NSString*)getPingResultMsg:(OHResultErrorType)vPingResult
 {
 NSString* msg=[NSString stringWithFormat: @"Ping Error. %d ", (int)vPingResult];
 switch (vPingResult)
 {
 case -8888:
 msg=[msg stringByAppendingString:@"coordinator init error."];
 break;
 case -9999:
 msg=[msg stringByAppendingString:@"coordinator=nil!"];
 break;
 case OHResultErrorTypeNone:
 msg=@"Ping is Success.";
 break;
 case OHResultErrorTypeSync:
 msg=[msg stringByAppendingString:@"Commands were executed in an improper order."];
 break;
 case OHResultErrorTypeGone:
 msg=[msg stringByAppendingString:@"The MySQL server has gone away."];
 break;
 case OHResultErrorTypeLost:
 msg=[msg stringByAppendingString:@"The connection to the server was lost during the query."];
 break;
 case OHResultErrorTypeUnknown:
 msg=[msg stringByAppendingString:@"An unknown error occurred."];
 break;
 default:
 msg=[msg stringByAppendingString:@"Unknown."];
 break;
 }
 return msg;
 }
 
 
 
 //TestConnect
 +(bool)TestConnect:(NSString*)vDNSName
 {
 NSLog(@"DBHelper: TestConnect.");
 _isConnected = false;
 [TscDNSs SetCurrentDNS:vDNSName];
 return [self Connect];
 }
 
 
 
 */
