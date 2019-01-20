//
//  main.m
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TscConfig.h"
#import "TscConnections.h"

int main(int argc, char * argv[]) {
    
    [TscConfig Init];
    [TscConnections Init];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
