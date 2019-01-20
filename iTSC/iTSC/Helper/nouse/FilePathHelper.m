//
//  FilePathHelper.m
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilePathHelper.h"




@implementation FilePathHelper

@synthesize homePath;
@synthesize tmpPath;

- (void)FilePathHelper
{
    
}

- (void)Init
{
    //NSLog(@"Hello, World! \n");
    
    //获取家目录
    homePath = NSHomeDirectory();
    //获取tmp目录
    tmpPath= NSTemporaryDirectory();
    //拼接
    //NSString *documents = [homeDocumentPath stringByAppendingPathComponent:@"Documents"];}
    
}
    
@end



