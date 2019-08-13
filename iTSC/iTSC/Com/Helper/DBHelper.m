//
//  DBHelper.m
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHelper.h"
#import "TscConnections.h"



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
+(bool)Connect
{
    //NSLog(@"DBHelper: Connect: start.");
    if(_isConnected == true)
    {
        NSLog(@"DBHelper: Connect: isConnected == true!");
        return true;
    }
    
    //Init
    _coordinator = nil;
    _queryContext = nil;
    
    TscConnection _con = [TscConnections getCurrentConnection];
    NSLog(@"DBHelper: TestConnect: TscConnection = %@", _con.Name);
    
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
    _user = [[OHMySQLUser alloc] initWithUserName:_con.UserName
                                         password:_con.UserPassword
                                       serverName:_address
                                           dbName:_con.dbName
                                             port:_con.Port
                                           socket:nil];
    
    if(_user == nil)
    {
        NSLog(@"DBHelper: TestConnect: _user==nil!");
        return false;
    }
    
    NSLog(@"DBHelper: TestConnect: _user is Created!");
    
    //coordinator
    _coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:_user];
    if(_coordinator==nil)
    {
        NSLog(@"DBHelper: TestConnect: _coordinator==nil!");
        return false;
    }
    NSLog(@"DBHelper: TestConnect: _coordinator is Created!");
    
    
    //connect
    [_coordinator connect];
    NSLog(@"DBHelper: TestConnect: _coordinator is connecting!");
    if([_coordinator isConnected] == false)
    {
        NSLog(@"DBHelper: TestConnect: _coordinator isConnected == false!");
        return false;
    }
    NSLog(@"DBHelper: TestConnect: connected.");
    
    
    //pingMySQL
    OHResultErrorType _ret = [_coordinator pingMySQL];
    if(_ret!=OHResultErrorTypeNone)
    {
        NSLog(@"DBHelper: TestConnect: _coordinator pingMySQL error! _ret=%d", (int)_ret);
        return false;
    }
    
    //Query Context
    _queryContext = [OHMySQLQueryContext new];
    _queryContext.storeCoordinator = _coordinator;
    
    NSLog(@"DBHelper: TestConnect: Context is created.");
    
    if(_queryContext==nil)
    {
        NSLog(@"DBHelper: TestConnect: queryContext==nil!");
        return false;
    }
    
    
    //isConnected
    _isConnected = true;
    
    return true;
    
}

//TestConnect
+(bool)TestConnect:(NSString*)vDNSName
{
    _isConnected = false;
    [TscDNSs SetCurrentDNS:vDNSName];
    return [self Connect];
}

//SetAvailableDNS
+(bool)SetAvailableDNS
{

    _isConnected = false;
    
    //_con
    TscConnection _con = [TscConnections getCurrentConnection];
    
    
    //Connection不使用DNS
    if(_con.isUsingDNS == false)
    {
        return [self Connect];
    }
    
    //当前DNS
    if([self Connect])
        return true;
    

    
    //Array
    NSArray *DNSNames = [TscDNSs getDNSNames];
    NSArray *ConnectionKeys = [TscConnections getConnectionKeys];
    
    //循环判断DNS
    for (NSString *d in DNSNames)
    {
        //[TscConnections SetCurrentConnection:(@"168")];
        if([self TestConnect:d])
        {
            return true;
        }
        
        
        //循环判断Connection会退出，可能是超时
        /*for (NSString *c in ConnectionKeys)
        {
            if([TscConnections getConnection:(c)].isUsingDNS == true)
            {
                [TscConnections SetCurrentConnection:(c)];
                if([self TestConnect:d])
                {
                    return true;
                }
            }
        }*/
    }
    
    //连接不使用DNS的Connection
    for (NSString *c in ConnectionKeys)
    {
        if([TscConnections getConnection:(c)].isUsingDNS == false)
        {
            [TscConnections SetCurrentConnection:c];
            if([self Connect])
                return true;
        }
    }
    
    //如果都连不通，设置为148
    [TscConnections SetCurrentConnection:(@"148")];
    [TscDNSs SetCurrentDNS:(@"f3322")];
    
    return false;
}

//Reconnect
+(bool) Reconnect
{
    if(_isConnected)
        [self Disconnect];
    _queryContext = nil;
    _isConnected = false;
    return [self Connect];
}


//Disconnect
+(void)Disconnect
{
    [_coordinator disconnect];
    _queryContext = nil;
    _isConnected = false;
    NSLog(@"DBHelper: Init: Disconnected.");
}


//GetContext
+(OHMySQLQueryContext *)GetContext
{
    return _queryContext;
}





//返回数据库路径，保存到Cache目录下
-(NSString *)databasePath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    return [path stringByAppendingPathComponent:@"contacts.db"];
}







-(void)getdata
{
    /*
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
*/
}



@end

