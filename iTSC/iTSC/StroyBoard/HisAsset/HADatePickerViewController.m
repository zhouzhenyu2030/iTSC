//
//  HADatePickerViewController.m
//  iTSC
//
//  Created by tss on 2019/1/29.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"
#import "TscConnections.h"
#import "TscConst.h"

#import "HADatePickerViewController.h"

@implementation HADatePickerViewController


@synthesize DatePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[DatePicker setDate:[TscConfig HisAssetStartDate] animated:YES];
    [DatePicker setMaximumDate:[NSDate date]];
    
}


- (IBAction)ValueChanged:(id)sender
{
    [TscConfig setHisAssetStartDate:DatePicker.date];
}




@end
