//
//  HADatePickerViewController.h
//  iTSC
//
//  Created by tss on 2019/1/29.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef HADatePickerViewController_h
#define HADatePickerViewController_h
#import <UIKit/UIKit.h>


@interface HADatePickerViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;

- (IBAction)ValueChanged:(id)sender;


@end

#endif /* HADatePickerViewController_h */
