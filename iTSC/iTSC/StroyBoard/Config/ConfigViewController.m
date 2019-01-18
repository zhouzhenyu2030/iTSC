//
//  ConfigViewController.m
//  iTSC
//
//  Created by tss on 2019/1/16.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>



#import "ConfigViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"


@implementation ConfigViewController

@synthesize Switch_ShowAllTime;
@synthesize Switch_GlobalAutoRefresh;


//action
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Switch_ShowAllTime.on = [TscConfig isShowAllTime];
    Switch_GlobalAutoRefresh.on = [TscConfig isGlobalAutoRefresh];

}


- (IBAction)Switch_ShowAllTime_ValueChanged:(id)sender
{
    [TscConfig setShowAllTime:[(UISwitch*)sender isOn]];
}

- (IBAction)Switch_GlobalAutoRefresh_ValueChanged:(id)sender
{
    [TscConfig setGlobalAutoRefresh:[(UISwitch*)sender isOn]];
}



@end
