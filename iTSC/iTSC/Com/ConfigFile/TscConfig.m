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
    
    _isShowAllTime = [_UserDefaults boolForKey:@"isShowAllTime"];
    [[UIApplication sharedApplication] setIdleTimerDisabled:_isShowAllTime];
 
    _isGlobalAutoRefresh = [_UserDefaults boolForKey:@"isGlobalAutoRefresh"];
    
    _RefreshSeconds = [_UserDefaults integerForKey:@"RefreshSeconds"];
    if(_RefreshSeconds<1) _RefreshSeconds=2;
    
    _isAssetAutoRefresh = [_UserDefaults boolForKey:@"isAssetAutoRefresh"];
    _isGreekAutoRefresh = [_UserDefaults boolForKey:@"isGreekAutoRefresh"];
    _isTradeSumAutoRefresh = [_UserDefaults boolForKey:@"isTradeSumAutoRefresh"];
    _isPositionAutoRefresh = [_UserDefaults boolForKey:@"isPositionAutoRefresh"];
    _isPnlAutoRefresh = [_UserDefaults boolForKey:@"isPnlAutoRefresh"];

    
    //HisAsset
    [self InitHisAssetStartDate];
    _strHisAssetDisplayFieldName = [_UserDefaults stringForKey:@"HisAssetDisplayFieldName"];
    
}


//setDefault
+(void) setDefault
{
    _isInBackground = false;

    _isShowAllTime = true;

    _isGlobalAutoRefresh = false;
    _RefreshSeconds = 2;
    
    _isAssetAutoRefresh = false;
    _isGreekAutoRefresh = false;
    _isPnlAutoRefresh = false;
    _isTradeSumAutoRefresh = false;
    _isPositionAutoRefresh = false;
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
    _isShowAllTime = vValue;
    [_UserDefaults setBool:(vValue) forKey:(@"isShowAllTime")];
    [[UIApplication sharedApplication] setIdleTimerDisabled:vValue];
}
+(void) RefreshCurrentShowAllTime
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:_isShowAllTime];
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

//RefreshSeconds
static NSInteger _RefreshSeconds;
+(NSInteger) RefreshSeconds
{
    return _RefreshSeconds;
}
+(void) setRefreshSeconds:(NSInteger) vValue
{
    _RefreshSeconds = vValue;
    [_UserDefaults setInteger:(vValue) forKey:(@"RefreshSeconds")];
}


//AssetAutoRefresh
static Boolean _isAssetAutoRefresh;
+(Boolean) isAssetAutoRefresh
{
    return _isAssetAutoRefresh;
}
+(void) setAssetAutoRefresh:(Boolean) vValue
{
    _isAssetAutoRefresh = vValue;
    [_UserDefaults setBool:(vValue) forKey:(@"isAssetAutoRefresh")];
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


//PNL AutoRefresh
static Boolean _isPnlAutoRefresh;
+(Boolean) isPnlAutoRefresh
{
    return _isPnlAutoRefresh;
}
+(void) setPnlAutoRefresh:(Boolean) vValue
{
    _isPnlAutoRefresh = vValue;
    [_UserDefaults setBool:(vValue) forKey:(@"isPnlAutoRefresh")];
}


//TradeSumAutoRefresh
static Boolean _isTradeSumAutoRefresh;
+(Boolean) isTradeSumAutoRefresh
{
    return _isTradeSumAutoRefresh;
}
+(void) setTradeSumAutoRefresh:(Boolean) vValue
{
    _isTradeSumAutoRefresh = vValue;
    [_UserDefaults setBool:(vValue) forKey:(@"isTradeSumAutoRefresh")];
}



//Position AutoRefresh
static Boolean _isPositionAutoRefresh;
+(Boolean) isPositionAutoRefresh
{
    return _isPositionAutoRefresh;
}
+(void) setPositionAutoRefresh:(Boolean) vValue
{
    _isPositionAutoRefresh = vValue;
    [_UserDefaults setBool:(vValue) forKey:(@"isPositionAutoRefresh")];
}



//HisAssetStartDate
static NSDate* _HisAssetStartDate;
NSDateFormatter *_dateFormatter;
NSString *_strDate;
+(void)InitHisAssetStartDate
{
    //dateFormatter
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //读取日期
    _strDate=[_UserDefaults stringForKey:@"HisAssetStartDate"];
    _HisAssetStartDate=[_dateFormatter dateFromString:_strDate];
    if(_HisAssetStartDate==nil)
        _HisAssetStartDate=[NSDate date];
    
    //设置_strDate
    _strDate = [_dateFormatter stringFromDate:_HisAssetStartDate];
}
+(NSDate*) HisAssetStartDate
{
    return _HisAssetStartDate;
}
+(NSString*) strHisAssetStartDate
{
    return _strDate;
}
+(void) setHisAssetStartDate:(NSDate*) vValue
{
    _HisAssetStartDate = vValue;
    _strDate = [_dateFormatter stringFromDate:_HisAssetStartDate];
    [_UserDefaults setObject:_strDate forKey:(@"HisAssetStartDate")];
}




//HisAssetDisplayFieldName
static NSString* _strHisAssetDisplayFieldName;
+(NSString*) strHisAssetDisplayFieldName
{
    return _strHisAssetDisplayFieldName;
}
+(void) setHisAssetDisplayFieldName:(NSString*) vValue
{
    _strHisAssetDisplayFieldName = vValue;
    [_UserDefaults setObject:(vValue) forKey:(@"HisAssetDisplayFieldName")];
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

