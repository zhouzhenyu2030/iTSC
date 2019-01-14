//
//  SecondViewController.h
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlobalStartViewController : UIViewController

//property
@property (weak, nonatomic) IBOutlet UILabel *Label_DBGloabalStart;

@property (weak, nonatomic) IBOutlet UIButton *Button_AT;
@property (weak, nonatomic) IBOutlet UIButton *Button_AH;


//action
- (IBAction)Button_CheckGlobalStart:(UIButton *)sender;
- (IBAction)Button_SetAT:(UIButton *)sender;
- (IBAction)Button_SetAH:(UIButton *)sender;
- (void)GenParaValue;


@end

