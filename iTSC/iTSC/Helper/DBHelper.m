//
//  DBHelper.m
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHelper.h"



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
+(void)Init
{
    NSLog(@"DBHelper: Init: start.");
    
    
    if(_isConnected==true)
    {
        NSLog(@"DBHelper: Init: isConnected == true!");
        return;
    }
    
    
    //user
    _user = [[OHMySQLUser alloc] initWithUserName:@"opt"
                                        password:@"Hr@2017yy"
                                      serverName:@"101.226.255.148"
                                          dbName:@"tss"
                                            port:30003
                                          socket:nil];
    if(_user==nil)
    {
        NSLog(@"DBHelper: Init: _user==nil!");
        return;
    }
    

    //coordinator
    _coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:_user];
    if(_coordinator==nil)
    {
        NSLog(@"DBHelper: Init: _user==nil!");
        return;
    }
    [_coordinator connect];
    
    NSLog(@"DBHelper: Init: connected.");
    
    
    //Query Context
    _queryContext = [OHMySQLQueryContext new];
    _queryContext.storeCoordinator = _coordinator;
    
    NSLog(@"DBHelper: Init: Context is created.");
    
    if(_queryContext==nil)
    {
        NSLog(@"DBHelper: Init: queryContext==nil!");
        return;
    }
    
    
    //isConnected
    _isConnected=true;
    
}



//GetContext
+(OHMySQLQueryContext *)GetContext
{
    return _queryContext;
}


//Disconnect
+(void)Disconnect
{
    [_coordinator disconnect];
    NSLog(@"DBHelper: Init: Disconnected.");
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

