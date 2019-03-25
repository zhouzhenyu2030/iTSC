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

#import "TscDNSs.h"




typedef struct
{
    NSString *Name;
    NSString *IP;
    int Port;
    NSString* UserName;
    NSString* UserPassword;
    NSString* dbName;
    NSString* AccountID;
    bool isUsingDNS;
} TscConnection;



@interface TscConnections : NSObject



+(void) Init;


//Connection
+(NSInteger) Count;

+(NSMutableDictionary*) getConnectionArray;
+(NSArray*) getConnectionKeys;
+(TscConnection) getConnection:(NSString*) vName;
+(TscConnection) getCurrentConnection;


+(NSString*) CurrentConnectionKey;
+(NSString*) SetCurrentConnection:(NSString*) ConnectionKey;

@end


#endif /* TscConnection_h */
