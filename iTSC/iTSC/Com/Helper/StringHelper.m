//
//  StringHelper.m
//  iTSC
//
//  Created by tss on 2019/1/12.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StringHelper.h"

@implementation StringHelper


//
+(NSString *)fPositiveFormat:(float)vValue pointNumber:(NSInteger) pointNumber
{
    switch (pointNumber)
    {
        case 0:
        {
            if(vValue == 0)
            {
                return @"0";
            }
            if (vValue < 1000 && vValue > -1000 )
            {
                return  [NSString stringWithFormat:@"%.0f", vValue];
            };
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setPositiveFormat:@",###;"];
            return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:vValue]];
        }
            break;
            
        default:
        {
            NSString* _sFormat;
            NSString* _sSuffix=@"";
            for(int i=0; i<pointNumber; i++)
            {
                _sSuffix=[_sSuffix stringByAppendingString:@"0"];
            }
            
            //0
            if(vValue == 0)
            {
                return [@"0." stringByAppendingString:_sSuffix] ;
            }
            
            //
            if (vValue < 1000 && vValue > -1000 )
            {
                _sFormat=@"%.";
                _sFormat=[_sFormat stringByAppendingString: [NSString stringWithFormat: @"%d", (int)pointNumber]];
                _sFormat=[_sFormat stringByAppendingString:@"f"];
                return  [NSString stringWithFormat:_sFormat, vValue];   //@"%.2f"
            };
            
            //
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            _sFormat=@",###.";
            for(int i=0; i<pointNumber; i++)
            {
                _sFormat=[_sFormat stringByAppendingString:@"0"];
            }
            _sFormat=[_sFormat stringByAppendingString:@";"];
            [numberFormatter setPositiveFormat:_sFormat];
            return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:vValue]];
        }
            break;
    }
    
}

+(NSString *)sPositiveFormat:(NSString*)text pointNumber:(NSInteger) pointNumber
{
    if(text==nil)
        return @"nil";
    return [self fPositiveFormat:text.floatValue pointNumber:pointNumber];
}




@end
