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
    

    +(NSString *)sPositiveFormat:(NSString*)text pointNumber:(NSInteger) pointNumber
    {
        switch (pointNumber)
        {
            case 0:
            {
                if(!text || [text intValue] == 0)
                {
                    return @"0";
                }
                if (text.intValue < 1000 && text.intValue > -1000 )
                {
                    return  [NSString stringWithFormat:@"%d",text.intValue];
                };
                
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setPositiveFormat:@",###;"];
                return [numberFormatter stringFromNumber:[NSNumber numberWithInt:[text intValue]]];
            }
                break;
                
            default:
            {
                
                if(!text || [text floatValue] == 0)
                {
                    return @"0.00";
                }
                if (text.floatValue < 1000 && text.floatValue > -1000 )
                {
                    return  [NSString stringWithFormat:@"%.2f",text.floatValue];
                };
                
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setPositiveFormat:@",###.00;"];
                return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
            }
                break;
        }
        //
    }




@end
