//
//  TscDNS.m
//  iTSC
//
//  Created by tss on 2019/3/25.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TscDNSs.h"





@implementation TscDNSs


//
static NSUserDefaults *_DNS_UserDefaults;
NSValue *_dns_value = nil;

//DNS
static NSMutableDictionary *DNSs;
static NSString *_CurrentDNSName;
static TscDNS _DefautlDNS;


///////////////////////////////////// init /////////////////////////////////////

+(void) Init
{
    _DNS_UserDefaults = [NSUserDefaults standardUserDefaults];
    
 
    DNSs= [[NSMutableDictionary alloc]init];
    [self initDNSs];
}




///////////////////////////////////// initDefault ///////////////////////////////////
+(void) initDNSs
{
    
    //DNS
    TscDNS _dns;
    

    _dns.Name=@"cqgts.com";
    _dns.DNSString=@"cqgts.com";
    _dns_value = [NSValue valueWithBytes:&_dns objCType:@encode(TscDNS)];
    [DNSs setObject:_dns_value forKey:_dns.Name];
    
    _DefautlDNS = _dns;
    
    
    _dns.Name=@"cqgfn.com";
    _dns.DNSString=@"cqgfn.com";
    _dns_value = [NSValue valueWithBytes:&_dns objCType:@encode(TscDNS)];
    [DNSs setObject:_dns_value forKey:_dns.Name];
    
    
    
    _dns.Name=@"myds";
    _dns.DNSString=@"cqg.myds.me";
    _dns_value = [NSValue valueWithBytes:&_dns objCType:@encode(TscDNS)];
    [DNSs setObject:_dns_value forKey:_dns.Name];
    
    _dns.Name=@"f3322";
    _dns.DNSString=@"cqgts.f3322.net";
    _dns_value = [NSValue valueWithBytes:&_dns objCType:@encode(TscDNS)];
    [DNSs setObject:_dns_value forKey:_dns.Name];
    
  
    
    
    
    
    //_UserDefaults
    [self SetCurrentDNS:[_DNS_UserDefaults stringForKey:@"CurrentDNSName"]];
    

}


///////////////////////////////////// get DNS Array ///////////////////////////////////
+(NSMutableDictionary*) getDNSArray
{
    return DNSs;
}

////////////////////////////////////// get DNS Names ///////////////////////////////////
+(NSArray*) getDNSNames
{
    //将所有的key放进数组
    NSArray *allKeyArray = [DNSs allKeys];
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
   
    //返回结果
    return afterSortKeyArray;
}




///////////////////////////////////// getDNS ///////////////////////////////////
+(TscDNS) getDNS:(NSString*) vName
{
    TscDNS _dns;
    _dns_value = [DNSs objectForKey:vName];
    if(_dns_value!=nil)
    {
        [_dns_value getValue:&_dns];
        NSLog(@"TscConnections: getDNS: Found. vName=%@, DNS= %@",vName, _dns.DNSString);
    }
    else
    {
        _dns=_DefautlDNS;
        NSLog(@"TscConnections: getDNS: not Found, return Defautl. vName=%@, DNS= %@",vName, _dns.DNSString);
    }
    
    return _dns;
}


///////////////////////////////////// getCurrentDNSName ///////////////////////////////////
+(NSString*) getCurrentDNSName
{
    return _CurrentDNSName;
}




///////////////////////////////////// getDNSString ///////////////////////////////////
+(NSString*) getDNSString:(NSString*) vDNSName
{
    TscDNS _dns;
    _dns_value = [DNSs objectForKey:vDNSName];
    if(_dns_value == nil)
        return nil;
    
    [_dns_value getValue:&_dns];
    NSLog(@"TscConnections: getDNS: Found. vName=%@, DNS= %@",_dns.Name, _dns.DNSString);

    return _dns.DNSString;
}


///////////////////////////////////// getCurrnetDNSString ///////////////////////////////////
+(NSString*) getCurrnetDNSString
{
    TscDNS _dns;
    _dns_value = [DNSs objectForKey:_CurrentDNSName];
    if(_dns_value!=nil)
    {
        [_dns_value getValue:&_dns];
        NSLog(@"TscConnections: getDNS: Found. vName=%@, DNS= %@",_CurrentDNSName, _dns.DNSString);
    }
    else
    {
        _dns=_DefautlDNS;
        NSLog(@"TscConnections: getDNS: not Found, return Defautl. vName=%@, DNS= %@",_CurrentDNSName, _dns.DNSString);
    }
    
    return _dns.DNSString;
}









///////////////////////////////////// SetCurrentDNS ///////////////////////////////////
+(void) SetCurrentDNS:(NSString*) vDNSName
{
    if(vDNSName == nil)
    {
       _CurrentDNSName = @"cqgts.com";
    }
    else
    {
        if([vDNSName isEqualToString:_CurrentDNSName] == false)
        {
            TscDNS _dns = [self getDNS:vDNSName];
            _CurrentDNSName = _dns.Name;
        }
    }
    
    [_DNS_UserDefaults setValue:_CurrentDNSName forKey:(@"CurrentDNSName")];
}



@end
