//
//  TscConfig.m
//  iTSC
//
//  Created by tss on 2019/1/16.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TscConfig.h"



@implementation TscConfig


////////////////////////////////////////////////////////////
NSUserDefaults *_UserDefaults;




////////////////////////////////////////////////////////////
//Init
+(void) Init
{
    [self setDefault];
    
    _UserDefaults = [NSUserDefaults standardUserDefaults];
    
    _isShowAllTime=[_UserDefaults boolForKey:@"isShowAllTime"];
    [[UIApplication sharedApplication] setIdleTimerDisabled:_isShowAllTime];
    
    _isGlobalAutoRefresh=[_UserDefaults boolForKey:@"isGlobalAutoRefresh"];
    _isBriefAutoRefresh=[_UserDefaults boolForKey:@"isBriefAutoRefresh"];
    _isGreekAutoRefresh=[_UserDefaults boolForKey:@"isGreekAutoRefresh"];
    
}


//setDefault
+(void) setDefault
{
    _isInBackground=false;
    _isShowAllTime = true;
    _isGlobalAutoRefresh = false;
    _isBriefAutoRefresh = false;
    _isGreekAutoRefresh = false;
}

//InBackground
static Boolean _isInBackground;
+(Boolean) isInBackground
{
    return _isInBackground;
}
+(void) setInBackground:(Boolean) vValue
{
    _isInBackground=vValue;
}


//ShowAllTime
static Boolean _isShowAllTime;
+(Boolean) isShowAllTime
{
    return _isShowAllTime;
}
+(void) setShowAllTime:(Boolean) vValue
{
    _isShowAllTime=vValue;
    [_UserDefaults setBool:(vValue) forKey:(@"isShowAllTime")];
    [[UIApplication sharedApplication] setIdleTimerDisabled:vValue];
}


//AutoRefresh
static Boolean _isGlobalAutoRefresh;
+(Boolean) isGlobalAutoRefresh
{
    return _isGlobalAutoRefresh;
}
+(void) setGlobalAutoRefresh:(Boolean) vValue
{
    _isGlobalAutoRefresh=vValue;
    [_UserDefaults setBool:(vValue) forKey:(@"isGlobalAutoRefresh")];
}

//BriefAutoRefresh
static Boolean _isBriefAutoRefresh;
+(Boolean) isBriefAutoRefresh
{
    return _isBriefAutoRefresh;
}
+(void) setBriefAutoRefresh:(Boolean) vValue
{
    _isBriefAutoRefresh = vValue;
    [_UserDefaults setBool:(vValue) forKey:(@"isBriefAutoRefresh")];
}


//GreekAutoRefresh
static Boolean _isGreekAutoRefresh;
+(Boolean) isGreekAutoRefresh
{
    return _isGreekAutoRefresh;
}
+(void) setGreekAutoRefresh:(Boolean) vValue
{
    _isGreekAutoRefresh = vValue;
    [_UserDefaults setBool:(vValue) forKey:(@"isGreekAutoRefresh")];
}


@end





/*
 
 //保存值(key值同名的时候会覆盖的)
 [defaults setObject:@"用户名" forKey:kUsernameKey];
 //立即保存
 [defaults synchronize];
 //取值
 NSString *username = [defaults objectForKey:kUsernameKey];
 
 
 
 [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
 
 //保存NSInteger
 [defaults setInteger:(NSInteger) forKey:(nonnull NSString *)];
 
 //保存NSURL
 [defaults setURL:(nullable NSURL *) forKey:(nonnull NSString *)];
 //保存float
 [defaults setFloat:(float) forKey:(nonnull NSString *)];
 //保存double
 [defaults setDouble:(double) forKey:(nonnull NSString *)];
 
 
 //取值
 [defaults integerForKey:(nonnull NSString *)];
 [defaults boolForKey:(nonnull NSString *)];
 [defaults URLForKey:(nonnull NSString *)];
 [defaults floatForKey:(nonnull NSString *)];
 [defaults doubleForKey:(nonnull NSString *)];
 
 //删除指定key的数据
 [defaults removeObjectForKey:(nonnull NSString *)];
 
 */
