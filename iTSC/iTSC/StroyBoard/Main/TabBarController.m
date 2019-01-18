//
//  TabBarController.m
//  iTSC
//
//  Created by tss on 2019/1/18.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _AddViewController:@"Brief" ViewControllerName:@"BriefMain"];
    [self _AddViewController:@"Help" ViewControllerName:@"HelpMain"];
    [self _AddViewController:@"Control" ViewControllerName:@"ControlMain"];
    [self _AddViewController:@"Config" ViewControllerName:@"ConfigMain"];

}


-(void) _AddViewController:(NSString*)vStoryboardName ViewControllerName:(NSString*) vViewControllerName
{
    UIStoryboard *_sb;
    UIViewController *_vc;
    //首先找到对应的storyboard
    _sb=[UIStoryboard storyboardWithName:vStoryboardName bundle:nil];
    if(_sb!=nil)
    {
        //NSLog(@"TabBarController: HisAsset.storyboard=nil");
        //根据storyboard和controller的storeId找到控制器
        _vc=[_sb instantiateViewControllerWithIdentifier:vViewControllerName];
        if(_vc!=nil)
        {
            //NSLog(@"TabBarControllerz: vc=nil");
            [self addChildViewController:(_vc)];
        }
    }
}

@end
