//
//  TscConnection.h
//  iTSC
//
//  Created by tss on 2019/1/19.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef TscConnection_h
#define TscConnection_h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
@interface ClassTscConnection : NSObject
{
    @public
    NSString *Name;
    NSString *IP;
    int Port;
    NSString* UserName;
    NSString* UserPassword;
}
@end
*/

typedef struct
{
    NSString *Name;
    NSString *IP;
    int Port;
    NSString* UserName;
    NSString* UserPassword;
    NSString* dbName;
} TscConnection;



@interface TscConnections : NSObject
//{
    //@public
    //NSMutableArray* Connections;
//}

+(void) Init;
+(TscConnection) getConnection:(NSString*) vName;

@end


#endif /* TscConnection_h */
