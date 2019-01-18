//
//  SamplePageViewController.m
//  TWPageViewController
//
//  Created by zhiyun.huang on 7/18/16.
//  Copyright © 2016 EAH. All rights reserved.
//

#import "SamplePageViewController.h"
#import "TableViewController.h"

@interface SamplePageViewController  () <TWPageViewControllerDelegate,TWPageViewControllerDataSource>

@end



@implementation SamplePageViewController


//viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate = self;
}


//numberOfControllersInPageViewController
- (NSInteger) numberOfControllersInPageViewController:( TWPageViewController * _Nonnull)pageViewController {
    return 10;
}


//viewControllerForIndex
- (UIViewController *)pageViewController:( TWPageViewController * _Nonnull)pageViewController viewControllerForIndex:(NSInteger)index {
    
    return nil;
    /*
    if(index==1)
    {
        UIViewController *ctrl = [[UIStoryboard storyboardWithName:@"Scroll" bundle:nil] instantiateViewControllerWithIdentifier:@"ScrollTestVC"];
        
        return ctrl;
        ;
    }
    else
    {
    TableViewController *ctrl = [pageViewController dequeueReusableControllerWithClassName:@"TableViewController" atIndex:index];
    
    if(!ctrl) {
        
        ctrl = [[UIStoryboard storyboardWithName:@"Scroll" bundle:nil] instantiateViewControllerWithIdentifier:@"TableViewController"];
    }
    
    ctrl.text = [NSString stringWithFormat:@"inner index:%ld",(long)index];

    ctrl.view.backgroundColor = [UIColor colorWithRed:(float)(random() %  10)/10.f green:(float)(random() %  10)/10.f blue:(float)(random() %  10)/10.f alpha:1.0];

        return ctrl;
    }
    */
}

- (void)pageViewController:(TWPageViewController * _Nonnull)pageViewController willShowController:(UIViewController * _Nonnull) controller atIndex:(NSInteger)index {
    
    NSLog(@"willShowController at index:%ld",(long)index);
    
}

@end
