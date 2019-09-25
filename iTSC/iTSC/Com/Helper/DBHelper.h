//
//  DB.h
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef DB_h
#define DB_h

#import "OHMySQL.h"





@interface DBHelper:NSObject




//function


+(NSString*) CurrentConnectionKey;

+(void)Init;


+(bool)Connect1;

+(void)CheckConnect;

+(void)SetToDisconnect;
+(void)Disconnect1;

+(OHMySQLQueryContext *)GetContext;


+(bool)BeginQuery;
+(void)EndQuery;


+(void)Lock;
+(void)UnLock;





//-(NSString *)databasePath;
//-(void)getdata;


//property
//@property (weak, nonatomic) OHMySQLQueryContext *queryContext;
//{
//OHMySQLQueryContext *queryContext;
//}

//+(bool)TestConnect:(NSString*)vDNSString;
//+(OHResultErrorType)PingSQL:(bool)visInit;
//+(NSString*)getPingResultMsg:(OHResultErrorType)vPingResult;


@end




#endif /* DB_h */
