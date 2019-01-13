//
//  DBHelper.m
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHelper.h"

@implementation DBHelper





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

