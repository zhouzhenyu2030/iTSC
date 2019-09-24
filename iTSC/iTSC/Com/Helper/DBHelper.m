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


//static
static Boolean _isConnected = false;
static OHMySQLUser *_user;
static OHMySQLStoreCoordinator *_coordinator;
static OHMySQLQueryContext *_queryContext;



@implementation DBHelper


/////////////////////////// property /////////////////////////
//@synthesize user;
//@synthesize coordinator;
//@synthesize queryContext;


///////////////////////// function /////////////////////////



//////////////////////// SetCoordinator ////////////////////////
+(bool)SetCoordinator
{
    TscConnection _con = [TscConnections getCurrentConnection];
    NSLog(@"DBHelper: SetCoordinator: TscConnection = %@", _con.Name);
    
    //DNS
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
    if(_user==nil)
    {
        _user = [OHMySQLUser alloc];
    }
    
    _user=[_user initWithUserName:_con.UserName
                                         password:_con.UserPassword
                                       serverName:_address
                                           dbName:_con.dbName
                                             port:_con.Port
                                           socket:nil];

    if(_user == nil)
    {
        NSLog(@"DBHelper: SetCoordinator: _user==nil!");
        return false;
    }
    NSLog(@"DBHelper: SetCoordinator: _user is Created!");
    
    
    //coordinator
    if(_coordinator == nil)
    {
        _coordinator = [OHMySQLStoreCoordinator alloc];
    }
    _coordinator = [_coordinator initWithUser:_user];
    if(_coordinator == nil)
    {
        NSLog(@"DBHelper: SetCoordinator: _coordinator==nil!");
        return false;
    }
    NSLog(@"DBHelper: SetCoordinator: _coordinator is Created!");
    
    
    return true;
    
}

//////////////////////// Connect ////////////////////////
+(bool)Connect
{
    //NSLog(@"DBHelper: Connect: start.");
    if([_coordinator isConnected])
    {
        NSLog(@"DBHelper: Connect: isConnected == true!");
        return true;
    }

 
    //SetCoordinator
    if([self SetCoordinator] == false)
    {
        NSLog(@"DBHelper: Connect: SetCoordinator: false.");
        return false;
    }
    
    
    //connect
    NSLog(@"DBHelper: Connect: _coordinator is connecting!");
    [_coordinator connect];
    if([_coordinator isConnected] == false)
    {
        NSLog(@"DBHelper: Connect: _coordinator isConnected == false!");
        return false;
    }
    NSLog(@"DBHelper: Connect: connected.");
    
    //Query Context
    _queryContext = [OHMySQLQueryContext new];
    _queryContext.storeCoordinator = _coordinator;
    
    NSLog(@"DBHelper: Connect: Context is created.");
    
    if(_queryContext==nil)
    {
        NSLog(@"DBHelper: TestConnect: queryContext==nil!");
        return false;
    }
    
    
    //isConnected
    _isConnected = true;
    
    return true;
    
}




//////////////////////// Reconnect ////////////////////////
+(bool) Reconnect
{
    if(_isConnected)
        [self Disconnect];
    _queryContext = nil;
    _isConnected = false;
    return [self Connect];
}


//////////////////////// Disconnect ////////////////////////
+(void)Disconnect
{
    [_coordinator disconnect];
    _queryContext = nil;
    _isConnected = false;
    NSLog(@"DBHelper: Init: Disconnected.");
}


//////////////////////// GetContext ////////////////////////
+(OHMySQLQueryContext *)GetContext
{
    if([_coordinator isConnected] == true)
        return _queryContext;

    if([NetHelper TestServerReachability] == false)
        return nil;

    if([self Connect] == true)
        return _queryContext;
    
    return nil;
}








/*

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

@end

