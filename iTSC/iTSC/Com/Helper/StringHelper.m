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
            
            if(vValue == 0)
            {
                return @"0.00";
            }
            if (vValue < 1000 && vValue > -1000 )
            {
                return  [NSString stringWithFormat:@"%.2f", vValue];
            };
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setPositiveFormat:@",###.00;"];
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
