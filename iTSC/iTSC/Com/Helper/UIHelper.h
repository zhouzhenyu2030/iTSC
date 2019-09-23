//
//  UIHelper.h
//  iTSC
//
//  Created by tss on 2019/1/20.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef UIHelper_h
#define UIHelper_h


#import <UIKit/UIKit.h>

@interface UIHelper : NSObject



+(void) ClearTabelViewCellText:(UITableView*)vTableView;

+(UITableViewCell*) SetTabelViewCellText:(UITableView*)vTableView Section:(int)vSectionIndex Row:(int)vRowIndex TitleText:(NSString*) vTitleText DetialText:(NSString*) vDetailText;
+(UITableViewCell*) SetTabelViewCellText:(UITableView*)vTableView Section:(int)vSectionIndex Row:(int)vRowIndex TitleText:(NSString*) vTitleText DetialText:(NSString*) vDetailText Font:(UIFont*) vFont;
+(UITableViewCell*) SetTabelViewCellText:(UITableView*)vTableView Section:(int)vSectionIndex Row:(int)vRowIndex TitleText:(NSString*) vTitleText DetialText:(NSString*) vDetailText Color:(UIColor*) vColor;


+(UITableViewCell*) SetTabelViewCellDetailText:(UITableView*)vTableView TitleText:(NSString*) vTitleText DetialText:(NSString*) vDetailText;

+(void) DisplayCell:(UITableView*) vTableView Field:(NSDictionary*)vField TitleName:(NSString*)vTitleName FieldName:(NSString*) vFieldName SetColor:(BOOL) visSetColor;
+(UITableViewCell*) DisplayIntCell:(UITableView*) vTableView Field:(NSDictionary*)vField TitleName:(NSString*)vTitleName FieldName:(NSString*) vFieldName;


+(UIAlertController *) ShowMessage:(NSString*) vTitle Message:(NSString*)vMessage;
+(UIAlertController *) ShowAlert:(NSString*) vTitle Message:(NSString*)vMessage;

+(UIAlertController *) GenAlertController:(NSString*) vMessage;


@end

#endif /* UIHelper_h */
