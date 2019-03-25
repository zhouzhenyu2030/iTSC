//
//  MySimplePingDelegate.h
//  iTSC
//
//  Created by tss on 2019/3/25.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef MySimplePingDelegate_h
#define MySimplePingDelegate_h
#import <Foundation/Foundation.h>
#import "SimplePing.h"


@interface MySimplePingDelegate : NSObject<SimplePingDelegate>

@property (nonatomic, assign) BOOL isPinging;
@property (nonatomic, assign) BOOL isPingFailed;



@end


#endif /* MySimplePingDelegate_h */
