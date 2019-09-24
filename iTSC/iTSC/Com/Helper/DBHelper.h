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

+(bool)SetCoordinator;
+(bool)Connect;
+(bool)Reconnect;
+(void)Disconnect;

+(OHMySQLQueryContext *)GetContext;



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
