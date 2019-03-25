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
    
    _dns.Name=@"imwork";
    _dns.DNSString=@"zhouzhenyu.imwork.net";
    _dns_value = [NSValue valueWithBytes:&_dns objCType:@encode(TscDNS)];
    [DNSs setObject:_dns_value forKey:_dns.Name];
    
    _dns.Name=@"kmdns";
    _dns.DNSString=@"zhouzhenyu2005.kmdns.net";
    _dns_value = [NSValue valueWithBytes:&_dns objCType:@encode(TscDNS)];
    [DNSs setObject:_dns_value forKey:_dns.Name];
    
    _dns.Name=@"f2233";
    _dns.DNSString=@"zhouzhenyu.f2233.net";
    _dns_value = [NSValue valueWithBytes:&_dns objCType:@encode(TscDNS)];
    [DNSs setObject:_dns_value forKey:_dns.Name];
    
    
    //_UserDefaults
    _CurrentDNSName = [self SetCurrentDNS:[_DNS_UserDefaults stringForKey:@"CurrentDNSName"]];
    

}


///////////////////////////////////// get DNS Array ///////////////////////////////////
+(NSMutableDictionary*) getDNSArray
{
    return DNSs;
}

////////////////////////////////////// get DNS Names ///////////////////////////////////
+(NSArray*) getDNSNames
{
    return [DNSs allKeys];
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
        _dns.Name=@"imwork";
        _dns.DNSString=@"zhouzhenyu.imwork.net";
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
    NSLog(@"TscConnections: getDNS: Found. vName=%@, DNS= %@",_CurrentDNSName, _dns.DNSString);

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
        _dns.Name=@"imwork";
        _dns.DNSString=@"zhouzhenyu.imwork.net";
        NSLog(@"TscConnections: getDNS: not Found, return Defautl. vName=%@, DNS= %@",_CurrentDNSName, _dns.DNSString);
    }
    
    return _dns.DNSString;
}









///////////////////////////////////// SetCurrentDNS ///////////////////////////////////
+(NSString*) SetCurrentDNS:(NSString*) vDNSName
{
    if(vDNSName != nil)
    {
        if([vDNSName isEqualToString:_CurrentDNSName] == false)
        {
            TscDNS _dns = [self getDNS:vDNSName];
            _CurrentDNSName = _dns.Name;
            [_DNS_UserDefaults setValue:_CurrentDNSName forKey:(@"CurrentDNSName")];
        }
    }
    
    return _CurrentDNSName;
}



@end
