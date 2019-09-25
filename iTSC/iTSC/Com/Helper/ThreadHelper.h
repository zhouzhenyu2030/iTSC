//
//  ThreadHelper.h
//  iTSC
//
//  Created by tss on 2019/9/25.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef ThreadHelper_h
#define ThreadHelper_h


@interface ThreadHelper:NSObject


+(void) Start;
+(void) Stop;

+(void)Suspend;
+(void)Resume;

+(void)Lock;
+(void)UnLock;


+(int)ThreadLoopCnt;

@end



#endif /* ThreadHelper_h */
