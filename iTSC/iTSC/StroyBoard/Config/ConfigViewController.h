//
//  ConfigViewController.h
//  iTSC
//
//  Created by tss on 2019/1/16.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef ConfigViewController_h
#define ConfigViewController_h

#import <UIKit/UIKit.h>



@interface ConfigViewController : UIViewController



@property (weak, nonatomic) IBOutlet UISwitch *Switch_ShowAllTime;
@property (weak, nonatomic) IBOutlet UISwitch *Switch_GlobalAutoRefresh;


//action
- (IBAction)Switch_ShowAllTime_ValueChanged:(id)sender;
- (IBAction)Switch_GlobalAutoRefresh_ValueChanged:(id)sender;


@end

#endif /* ConfigViewController_h */
