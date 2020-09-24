//
//  HAMktOrTheoPicker.m
//  iTSC
//
//  Created by tss on 2019/3/4.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"
#import "UIHelper.h"
#import "TscConnections.h"
#import "TscConst.h"

#import "HAMktOrTheoPickerViewController.h"


@implementation HAMktOrTheoPickerViewController


@synthesize HAFieldNamePicker;


NSString* myFunctionName=@"HAMktOrTheoPickerViewController";




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获取需要展示的数据
    NSInteger _index = [self loadData];
    
    
 
    //指定数据源和委托
    HAFieldNamePicker.delegate = self;
    HAFieldNamePicker.dataSource = self;
    
    //显示初始值
    [HAFieldNamePicker selectRow:_index inComponent:0 animated:false];  // inComponent:0 animated:true];
}


#pragma mark 加载数据
-(NSInteger)loadData
{
    //需要展示的数据以数组的形式保存
    key = @[@"A", @"M", @"T"];
    fieldname = @[@"AssetTheo", @"NVMrkt", @"NVTheo"];
    
    //获取初始值
    NSString* _InitFieldName=[TscConfig strHisAssetDisplayFieldName];
  
    if(_InitFieldName == Nil)
        return 0;
    if([_InitFieldName length] == 0)
        return 0;
    if([fieldname containsObject:_InitFieldName] == false)
        return 0;
    
    NSInteger _index=[fieldname indexOfObject:_InitFieldName];
    if(_index<0) _index = 0;
    NSLog(@"%@: index=%d, initFieldName=%@", myFunctionName, (int)_index,[TscConfig strHisAssetDisplayFieldName]);
    return _index;
}

#pragma mark UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (component) {
        case 0:
            result = key.count;//根据数组的元素个数返回几行数据
            break;
        case 1:
            result = fieldname.count;
            break;
            
        default:
            break;
    }
    
    return result;
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * title = nil;
    switch (component) {
        case 0:
            title = key[row];
            break;
        case 1:
            title = fieldname[row];
            break;
        default:
            break;
    }
    
    return title;
}



//选中时回调的委托方法
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //[TscConfig setHisAssetDisplayFieldName:[fieldname[pickerView selectedRowInComponent:0]]];
    NSString* _selectedname = fieldname[row];
    [TscConfig setHisAssetDisplayFieldName:_selectedname];
    /*
     example
    switch (component) {
        case 0://选中省份表盘时，根据row的值改变城市数组，刷新城市数组，实现联动
            self.cities = self.provinces[row][@"Cities"];
            [self.pickerView reloadComponent:1];
            break;
        case 1:
            self.label.text = [NSString stringWithFormat:@"%@%@",self.provinces[[self.pickerView selectedRowInComponent:0]][@"State"],self.cities[[self.pickerView selectedRowInComponent:1]][@"city"]];//如果选中第二个
            break;
            
        default:
            break;
    }
     */
}

@end
