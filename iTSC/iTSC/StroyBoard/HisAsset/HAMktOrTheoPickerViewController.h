//
//  HAMktOrTheoPickerViewController.h
//  iTSC
//
//  Created by tss on 2019/3/4.
//  Copyright © 2019年 tss. All rights reserved.
//

#ifndef HAMktOrTheoPickerViewController_h
#define HAMktOrTheoPickerViewController_h

#import <UIKit/UIKit.h>

@interface HAMktOrTheoPickerViewController : UIViewController
{
    NSArray *key;           //保存要展示的Key
    NSArray *fieldname;    //保存要展示的HisAsset字段名称
}

@property (weak, nonatomic) IBOutlet UIPickerView *HAFieldNamePicker;


@end

#endif /* HAMktOrTheoPickerViewController_h */
