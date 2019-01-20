//
//  StringHelper.h
//  iTSC
//
//  Created by tss on 2019/1/12.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef StringHelper_h
#define StringHelper_h

@interface StringHelper:NSObject


    +(NSString *)fPositiveFormat:(float)vVlue pointNumber:(NSInteger) pointNumber;

    +(NSString *)sPositiveFormat:(NSString*)text pointNumber:(NSInteger) pointNumber;


@end

#endif /* StringHelper_h */
