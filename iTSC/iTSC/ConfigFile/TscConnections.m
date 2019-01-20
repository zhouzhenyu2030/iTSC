//
//  TscConnections.m
//  iTSC
//
//  Created by tss on 2019/1/19.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TscConnections.h"



@implementation TscConnections


NSMutableDictionary *Connections;
NSValue *value = nil;


//init
+(void) Init
{
    Connections = [[NSMutableDictionary alloc]init];   
    [self setDefault];
    [self save];
}


//get
+(TscConnection) getConnection:(NSString*) vName
{
    TscConnection _con;
    value = [Connections objectForKey:vName];
    [value getValue:&_con];
    NSLog(@"key: %@,value: %@",vName,value);
    return _con;
}



//default
+(void) setDefault
{
    TscConnection _con;
    
    
    _con.Name=@"148";
    _con.IP=@"101.226.255.148";
    _con.Port=30003;
    _con.UserName=@"opt";
    _con.UserPassword=@"Hr@2017yy";
    _con.dbName=@"tss";
    value = [NSValue valueWithBytes:&_con objCType:@encode(TscConnection)];
    [Connections setObject:value forKey:_con.Name];
    
    _con.Name=@"158";
    _con.IP=@"zhouzhenyu.imwork.net";
    _con.Port=15833;
    _con.UserName=@"root";
    _con.UserPassword=@"z";
    _con.dbName=@"tss";
    value = [NSValue valueWithBytes:&_con objCType:@encode(TscConnection)];
    [Connections setObject:value forKey:_con.Name];
    
    for(id key in Connections)
    {
        value = [Connections objectForKey:key];
        [value getValue:&_con];
        NSLog(@"key: %@,value: %@",key,value);
    }
    
}



//save
+(void) save
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

//load
+(void) load
{

    //NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:(nonnull NSString *)]];
    //NSDictionary *dictionary =  [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(nullable NSString *) ofType:(nullable NSString *)]];
    
    //NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:(nonnull NSString *)]];
    //NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(nullable NSString *) ofType:(nullable NSString *)]];
    
}





/*
 +(void) Init
 {
 //Connections  =  [[NSMutableArray alloc]initWithCapacity:1];
 
 TscConnection aaa; //= [[ClassTscConnection alloc] init]; //[ClassTscConnection new];
 //NSArray *dataList = [NSArray array];
 //[dataList addObject:aaa];
 
 NSMutableArray *array = [NSMutableArray array];
 NSValue *value = nil;
 
 
 aaa.Name=@"111";
 value = [NSValue valueWithBytes:&aaa objCType:@encode(TscConnection)];
 [array addObject:value];
 
 aaa.Name=@"222";
 value = [NSValue valueWithBytes:&aaa objCType:@encode(TscConnection)];
 [array addObject:value];
 
 
 //读取
 for (NSValue *value in array)
 {
 TscConnection s ;
 [value getValue:&s];
 NSLog(@"%@",s.Name);
 }
 
 }
 */




@end
