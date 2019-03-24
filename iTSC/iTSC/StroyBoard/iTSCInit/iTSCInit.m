//
//  iTSCInit.m
//  iTSC
//
//  Created by tss on 2019/3/24.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "iTSCInit.h"

@implementation iTscInitViewController



- (IBAction)ButtonOk:(id)sender
{
    NSLog(@"iTscInitViewController: ButtonOk is touched.");
    UIViewController *_helpvc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"MainBorad"]; //设置跳转页面
    [self.navigationController pushViewController:_helpvc animated:YES]; //设置跳转方式
}


@end
