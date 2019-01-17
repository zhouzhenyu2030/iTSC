//
//  GreeksViewController.h
//  iTSC
//
//  Created by tss on 2019/1/14.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef GreeksViewController_h
#define GreeksViewController_h

#import <UIKit/UIKit.h>
#import "TscConfig.h"


@interface GreeksViewController : UIViewController
{
    int i;
    NSTimer* myTimer;
}

//property
@property (weak, nonatomic) IBOutlet UILabel *Label_RecordTime;
//@property (weak, nonatomic) IBOutlet UILabel *Label_ItemKey;


@property (weak, nonatomic) IBOutlet UILabel *Label_TotalDelta;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalVega;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalTheta;

@property (weak, nonatomic) IBOutlet UILabel *Label_TotalGamma;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalCharm;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalVanna;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalVolga;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalVeta;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalTata;


@property (weak, nonatomic) IBOutlet UILabel *Label_TotalColor;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalSpeed;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalZomma;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalUltima;


@property (weak, nonatomic) IBOutlet UILabel *Label_TotalSRR;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalSLR;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalPCR;
@property (weak, nonatomic) IBOutlet UILabel *Label_TotalCCR;


@property (weak, nonatomic) IBOutlet UISwitch *Switch_AutoRefresh;


@property (weak, nonatomic) IBOutlet UILabel *Label_RefreshCount;

//action
- (IBAction)Button_Risk_Query_Click:(UIButton *)sender;
- (IBAction)AutoRefresh:(id)sender;


@end


#endif /* GreeksViewController_h */
