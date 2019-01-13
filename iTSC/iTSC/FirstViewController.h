//
//  FirstViewController.h
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController: UIViewController

    
    
    //property
    @property (weak, nonatomic) IBOutlet UILabel *Label_AccountID;
    
    @property (weak, nonatomic) IBOutlet UILabel *Label_HisDate;
    @property (weak, nonatomic) IBOutlet UILabel *Label_RecordTime;


    @property (weak, nonatomic) IBOutlet UILabel *Label_AssetTheo;
    @property (weak, nonatomic) IBOutlet UILabel *Label_Asset;
    @property (weak, nonatomic) IBOutlet UILabel *Label_AssetLastPrice;

    
    @property (weak, nonatomic) IBOutlet UILabel *Label_TradeMktPNL;
    @property (weak, nonatomic) IBOutlet UILabel *Label_YdMktPNL;
    @property (weak, nonatomic) IBOutlet UILabel *Label_TotalMktPNL;

    
    @property (weak, nonatomic) IBOutlet UILabel *Label_TradeTheoPNL;
    @property (weak, nonatomic) IBOutlet UILabel *Label_YdTheoPNL;
    @property (weak, nonatomic) IBOutlet UILabel *Label_TotalTheoPNL;

    
    
    @property (weak, nonatomic) IBOutlet UILabel *Label_TradeQty;
    

    @property (weak, nonatomic) IBOutlet UILabel *Label_OrderInsertQty;
    @property (weak, nonatomic) IBOutlet UILabel *Label_OrderInsertCnt;
    
    
    @property (weak, nonatomic) IBOutlet UILabel *Label_RiskLevel;
    
    
    @property (weak, nonatomic) IBOutlet UILabel *Label_TotalCash;
    @property (weak, nonatomic) IBOutlet UILabel *Label_CurrMargin;
    
    

    
//action
- (IBAction)MyButtonClick:(UIButton *)sender;


@end
