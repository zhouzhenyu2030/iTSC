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
+(void) SetTabelViewCellDetailText:(UITableView*)vTableView TitleText:(NSString*) vTitleText DetialText:(NSString*) vDetailText;



@end

#endif /* UIHelper_h */
