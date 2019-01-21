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
+(void)Connect
{
    //NSLog(@"DBHelper: Connect: start.");
    if(_isConnected == true)
    {
        NSLog(@"DBHelper: Connect: isConnected == true!");
        return;
    }
    
    
    TscConnection _con = [TscConnections getCurrentConnection];
    //TscConnection _con = [TscConnections getConnection:@"148"];
    NSLog(@"DBHelper: Connect: TscConnection = %@", _con.Name);
    
    
    //user
    _user = [[OHMySQLUser alloc] initWithUserName:_con.UserName
                                         password:_con.UserPassword
                                       serverName:_con.IP
                                           dbName:_con.dbName
                                             port:_con.Port
                                           socket:nil];
    
    if(_user==nil)
    {
        NSLog(@"DBHelper: Connect: _user==nil!");
        return;
    }
    
    NSLog(@"DBHelper: Connect: _user is Created!");

    //coordinator
    _coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:_user];
    if(_coordinator==nil)
    {
        NSLog(@"DBHelper: Connect: _coordinator==nil!");
        return;
    }
    NSLog(@"DBHelper: Connect: _coordinator is Created!");
    
    
    //connect
    [_coordinator connect];
    NSLog(@"DBHelper: Connect: _coordinator is connecting!");
    if([_coordinator isConnected] == false)
    {
        NSLog(@"DBHelper: Connect: _coordinator isConnected == false!");
        return;
    }
    NSLog(@"DBHelper: Connect: connected.");
    
    
    //pingMySQL
    OHResultErrorType _ret = [_coordinator pingMySQL];
    if(_ret!=OHResultErrorTypeNone)
    {
        NSLog(@"DBHelper: Connect: _coordinator pingMySQL error! _ret=%d", (int)_ret);
        return;
    }
    
    //Query Context
    _queryContext = [OHMySQLQueryContext new];
    _queryContext.storeCoordinator = _coordinator;
    
    NSLog(@"DBHelper: Connect: Context is created.");
    
    if(_queryContext==nil)
    {
        NSLog(@"DBHelper: Connect: queryContext==nil!");
        return;
    }
    
    
    //isConnected
    _isConnected = true;
    
}

//Reconnect
+(void) Reconnect
{
    if(_isConnected)
        [self Disconnect];
    _queryContext = nil;
    _isConnected = false;
    [self Connect];
}


//Disconnect
+(void)Disconnect
{
    [_coordinator disconnect];
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

