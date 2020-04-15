//
//  TscConnections.m
//  iTSC
//
//  Created by tss on 2019/1/19.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBHelper.h"
#import "TscConnections.h"



@implementation TscConnections


//
static NSUserDefaults *_con_UserDefaults;
NSValue *_con_value = nil;

//Connection
static NSMutableDictionary *Connections;
static NSString *_CurrentConnectionKey;



///////////////////////////////////// init /////////////////////////////////////
+(void) Init
{
    _con_UserDefaults = [NSUserDefaults standardUserDefaults];
    

    Connections = [[NSMutableDictionary alloc]init];
    [self initConnections];
    //[self saveConnections];
 
}




///////////////////////////////////// initConnections ///////////////////////////////////
+(void) _set_con : (NSString*) vName isUsingDNS:(BOOL) visUsingDNS IP:(NSString*) vIP Port:(int) vPort PassWord:(NSString*) vPassWord
{
    TscConnection _con;

    _con.Name= vName;
    _con.isUsingDNS= visUsingDNS;
    _con.IP= vIP;
    _con.Port= vPort;
    _con.UserPassword = vPassWord;

    _con.UserName=@"root";
    _con.dbName=@"tss";
    _con.AccountID = @"AccountID=0";

    _con_value = [NSValue valueWithBytes:&_con objCType:@encode(TscConnection)];
    [Connections setObject:_con_value forKey:_con.Name];
}
+(void) initConnections
{
    NSString *_dnsString=[TscDNSs getCurrnetDNSString];
    
    //[self _set_con:@"195-2" isUsingDNS:true IP:_dnsString Port:30623];
    //[self _set_con:@"195-3" isUsingDNS:true IP:_dnsString Port:30633];
    [self _set_con:@"6-128" isUsingDNS:true IP:_dnsString Port:21283 PassWord:@"cqg@2030z"];
    [self _set_con:@"6-2" isUsingDNS:true IP:_dnsString Port:20623 PassWord:@"z"];
    [self _set_con:@"6-3" isUsingDNS:true IP:_dnsString Port:20633 PassWord:@"z"];
    [self _set_con:@"6-6" isUsingDNS:true IP:_dnsString Port:20663 PassWord:@"cqg@2030z"];
    [self _set_con:@"6-8" isUsingDNS:true IP:_dnsString Port:20683 PassWord:@"z"];
    [self _set_con:@"6-9" isUsingDNS:true IP:_dnsString Port:20693 PassWord:@"z"];
    [self _set_con:@"6-10" isUsingDNS:true IP:_dnsString Port:26103 PassWord:@"cqg@2030z"];
    [self _set_con:@"6-11" isUsingDNS:true IP:_dnsString Port:26113 PassWord:@"cqg@2030z"];
    [self _set_con:@"6-12" isUsingDNS:true IP:_dnsString Port:26123 PassWord:@"cqg@2030z"];

    //
    _CurrentConnectionKey = [self SetCurrentConnection:[_con_UserDefaults stringForKey:@"CurrentConnectionKey"]];

}





/////////////////////////////////// Connection ///////////////////////////////////
//Count
+(NSInteger) Count
{
    return Connections.count;
}

//get
+(TscConnection) getConnection:(NSString*) vName
{
    TscConnection _con;
    _con_value = [Connections objectForKey:vName];
    [_con_value getValue:&_con];
    //NSLog(@"key: %@,value: %@", vName, _con_value);
    return _con;
}
+(TscConnection) getCurrentConnection
{
    return [self getConnection:_CurrentConnectionKey];
}


//getConnectionArray
+(NSMutableDictionary*) getConnectionArray
{
    return Connections;
}

//getConnectionKeys
+(NSArray*) getConnectionKeys
{
    //将所有的key放进数组
    NSArray *allKeyArray = [Connections allKeys];
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
        /**
         In the compare: methods, the range argument specifies the
         subrange, rather than the whole, of the receiver to use in the
         comparison. The range is not applied to the search string.  For
         example, [@"AB" compare:@"ABC" options:0 range:NSMakeRange(0,1)]
         compares "A" to "ABC", not "A" to "A", and will return
         NSOrderedAscending. It is an error to specify a range that is
         outside of the receiver's bounds, and an exception may be raised.
         
         - (NSComparisonResult)compare:(NSString *)string;
         
         compare方法的比较原理为,依次比较当前字符串的第一个字母:
         如果不同,按照输出排序结果
         如果相同,依次比较当前字符串的下一个字母(这里是第二个)
         以此类推
         
         排序结果
         NSComparisonResult resuest = [obj1 compare:obj2];为从小到大,即升序;
         NSComparisonResult resuest = [obj2 compare:obj1];为从大到小,即降序;
         
         注意:compare方法是区分大小写的,即按照ASCII排序
         */
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    
    return afterSortKeyArray;
}


//排序 未使用 供参考
+(void)sortedDictionary:(NSDictionary *)dict{
    
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
        /**
         In the compare: methods, the range argument specifies the
         subrange, rather than the whole, of the receiver to use in the
         comparison. The range is not applied to the search string.  For
         example, [@"AB" compare:@"ABC" options:0 range:NSMakeRange(0,1)]
         compares "A" to "ABC", not "A" to "A", and will return
         NSOrderedAscending. It is an error to specify a range that is
         outside of the receiver's bounds, and an exception may be raised.
         
         - (NSComparisonResult)compare:(NSString *)string;
         
         compare方法的比较原理为,依次比较当前字符串的第一个字母:
         如果不同,按照输出排序结果
         如果相同,依次比较当前字符串的下一个字母(这里是第二个)
         以此类推
         
         排序结果
         NSComparisonResult resuest = [obj1 compare:obj2];为从小到大,即升序;
         NSComparisonResult resuest = [obj2 compare:obj1];为从大到小,即降序;
         
         注意:compare方法是区分大小写的,即按照ASCII排序
         */
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    NSLog(@"afterSortKeyArray:%@",afterSortKeyArray);
    
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
    NSLog(@"valueArray:%@",valueArray);
}

//saveConnections
+(void) saveConnections
{
    //把字典写入到plist文件，比如文件path为：~/Documents/data.plist
    NSString* path = @"~/Documents/data.plist";
    [Connections writeToFile:path atomically:YES];
    //把数组写入到plist文件中
    //[array writeToFile:path atomically:YES];
    
    //NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:(nonnull NSString *)]];
    //NSDictionary *dictionary =  [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(nullable NSString *) ofType:(nullable NSString *)]];
    
    //NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:(nonnull NSString *)]];
    //NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(nullable NSString *) ofType:(nullable NSString *)]];

}

//loadConnections
+(void) loadConnections
{
    //CurrentConnectionKey;
    //NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:(nonnull NSString *)]];
    //NSDictionary *dictionary =  [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(nullable NSString *) ofType:(nullable NSString *)]];
    
    //NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:(nonnull NSString *)]];
    //NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(nullable NSString *) ofType:(nullable NSString *)]];
    
}


//CurrentConnection
+(NSString*) CurrentConnectionKey
{
    return _CurrentConnectionKey;
}
+(NSString*) SetCurrentConnection:(NSString*) vConnectionKey
{
    if(vConnectionKey != nil)
    {
        if([vConnectionKey isEqualToString:_CurrentConnectionKey] == false)
        {
            TscConnection _con = [self getConnection:vConnectionKey];
            _CurrentConnectionKey = _con.Name;
            [_con_UserDefaults setValue:_CurrentConnectionKey forKey:(@"CurrentConnectionKey")];
            //[DBHelper Reconnect:false];
        }
    }
    
    return _CurrentConnectionKey;
}





@end
