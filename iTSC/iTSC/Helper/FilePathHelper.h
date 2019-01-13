//
//  FilePathHelper.h
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef FilePathHelper_h
#define FilePathHelper_h

@interface FilePathHelper:NSObject
{
    
@public
    NSString *homePath;
    NSString *tmpPath;
    
}


@property(copy) NSString *homePath;
@property(copy) NSString *tmpPath;


- (void)FilePathHelper;
- (void)Init;



@end


#endif /* FilePathHelper_h */
