//
//  FirstViewController.m
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import "FirstViewController.h"
#import "OHMySQL.h"
#import "StringHelper.h"

@implementation FirstViewController

    @synthesize Label_AccountID;
    
    @synthesize Label_HisDate;
    @synthesize Label_RecordTime;
    
    @synthesize Label_AssetTheo;
    @synthesize Label_Asset;
    @synthesize Label_AssetLastPrice;
    
    @synthesize Label_TradeMktPNL;
    @synthesize Label_YdMktPNL;
    @synthesize Label_TotalMktPNL;
    
    @synthesize Label_YdTheoPNL;
    @synthesize Label_TradeTheoPNL;
    @synthesize Label_TotalTheoPNL;
 
    @synthesize Label_TradeQty;
    @synthesize Label_OrderInsertQty;
    @synthesize Label_OrderInsertCnt;
    
    @synthesize Label_RiskLevel;
    
    @synthesize Label_TotalCash;
    @synthesize Label_CurrMargin;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)MyButtonClick:(UIButton *)sender
    {

    //connect
    OHMySQLUser *user = [[OHMySQLUser alloc] initWithUserName:@"opt"
                                                     password:@"Hr@2017yy"
                                                   serverName:@"101.226.255.148"
                                                       dbName:@"tss"
                                                         port:30003
                                                       socket:nil];
    OHMySQLStoreCoordinator *coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:user];
    [coordinator connect];
    
        
    //Query Context
    OHMySQLQueryContext *queryContext = [OHMySQLQueryContext new];
    queryContext.storeCoordinator = coordinator;
    
    
    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"hisasset" condition:@"AccountID=0"];
    NSError *error = nil;
    NSArray *tasks = [queryContext executeQueryRequestAndFetchResult:query error:&error];
        
        
        NSUInteger count = tasks.count;//减少调用次数
        //for( int i=0; i<count; i++){
            NSLog(@"%@", [tasks objectAtIndex:count-1]);
        //}
    //for(id obj in tasks){
     //       NSLog(@"%@",obj);
    //}
        
        
    //显示
    NSDictionary  *_field=[tasks objectAtIndex:count-1];
        
    Label_AccountID.text = [NSString stringWithFormat:@"%d", [_field[@"AccountID"] intValue]];
        
    Label_HisDate.text = _field[@"HisDate"];
    Label_RecordTime.text = _field[@"RecordTime"];

    Label_Asset.text = [StringHelper sPositiveFormat:_field[@"Asset"] pointNumber:2];
    Label_AssetTheo.text = [StringHelper sPositiveFormat:_field[@"AssetTheo"] pointNumber:2];
    Label_AssetLastPrice.text = [StringHelper sPositiveFormat:_field[@"AssetLastPrice"] pointNumber:2];

    Label_TradeMktPNL.text = [StringHelper sPositiveFormat:_field[@"TradeMktPNL"] pointNumber:2];
    Label_YdMktPNL.text = [StringHelper sPositiveFormat:_field[@"YdMktPNL"] pointNumber:2];
    Label_TotalMktPNL.text = [StringHelper sPositiveFormat:_field[@"TotalMktPNL"] pointNumber:2];

    Label_YdMktPNL.text = [StringHelper sPositiveFormat:_field[@"YdMktPNL"] pointNumber:2];
    Label_TradeMktPNL.text = [StringHelper sPositiveFormat:_field[@"TradeMktPNL"] pointNumber:2];
    Label_TotalMktPNL.text = [StringHelper sPositiveFormat:_field[@"TotalMktPNL"] pointNumber:2];

    Label_YdTheoPNL.text = [StringHelper sPositiveFormat:_field[@"YdTheoPNL"] pointNumber:2];
    Label_TradeTheoPNL.text = [StringHelper sPositiveFormat:_field[@"TradeTheoPNL"] pointNumber:2];
    Label_TotalTheoPNL.text = [StringHelper sPositiveFormat:_field[@"TotalTheoPNL"] pointNumber:2];

        
    Label_TradeQty.text = [StringHelper sPositiveFormat:_field[@"TradeQty"] pointNumber:0];
    Label_OrderInsertQty.text = [StringHelper sPositiveFormat:_field[@"OrderInsertQty"] pointNumber:0];
    Label_OrderInsertCnt.text = [StringHelper sPositiveFormat:_field[@"OrderInsertCnt"] pointNumber:0];
        
    Label_RiskLevel.text = [StringHelper sPositiveFormat:_field[@"RiskLevel"] pointNumber:2];
    Label_TotalCash.text = [StringHelper sPositiveFormat:_field[@"TotalCash"] pointNumber:2];
    Label_CurrMargin.text =[StringHelper sPositiveFormat:_field[@"CurrMargin"] pointNumber:2];


        
    //disconnect
    [coordinator disconnect];
        

    }
    
    
    
@end
