//
//  TscDNSs.h
//  iTSC
//
//  Created by tss on 2019/3/25.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef TscDNSs_h
#define TscDNSs_h

#import <UIKit/UIKit.h>

typedef struct
{
    NSString *Name;
    NSString *DNSString;
} TscDNS;


@interface TscDNSs : NSObject

- (instancetype)init NS_UNAVAILABLE;
+(void) Init;



//DNS
+(NSMutableDictionary*) getDNSArray;

+(NSArray*) getDNSNames;
+(NSString*) getCurrentDNSName;

+(NSString*) getCurrnetDNSString;
+(NSString*) getDNSString:(NSString*) vDNSName;

+(void) SetCurrentDNS:(NSString*) vDNSName;


@end

#endif /* TscDNSs_h */
