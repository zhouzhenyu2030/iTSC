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



//property
//@property (weak, nonatomic) OHMySQLQueryContext *queryContext;
//{
   //OHMySQLQueryContext *queryContext;
//}


//function
+(void)Init;
+(OHMySQLQueryContext *)GetContext;
+(void)Disconnect;


-(NSString *)databasePath;
-(void)getdata;




@end




#endif /* DB_h */
