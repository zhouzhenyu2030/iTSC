//
//  UIHelper.m
//  iTSC
//
//  Created by tss on 2019/1/20.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIHelper.h"
#import "StringHelper.h"


@implementation UIHelper


//设置TableViewCellDetailText
+(void) ClearTabelViewCellText:(UITableView*)vTableView
{
    NSInteger sections = vTableView.numberOfSections;
    if(sections<=0)
        return;
    
    NSInteger rows;
    NSIndexPath *indexPath;
    UITableViewCell *cell;
    
    for(int i=0; i<sections; i++)
    {
        rows = [vTableView numberOfRowsInSection:i];
        for(int j=0; j<rows; j++)
        {
            indexPath=[NSIndexPath indexPathForRow:j inSection:i];
            cell = [vTableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = @"";
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.text = @"";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        }
    }
}


//设置TableViewCell
+(UITableViewCell*) SetTabelViewCellText:(UITableView*)vTableView Section:(int)vSectionIndex Row:(int)vRowIndex TitleText:(NSString*) vTitleText DetialText:(NSString*) vDetailText
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:vRowIndex inSection:vSectionIndex];
    UITableViewCell *cell = [vTableView cellForRowAtIndexPath:indexPath];
    
    cell.detailTextLabel.textColor = UIColor.blackColor;
    
    if(vTitleText != nil)
        cell.textLabel.text = vTitleText;
    if(vDetailText != nil)
        cell.detailTextLabel.text = vDetailText;
    
    return cell;
}
+(UITableViewCell*) SetTabelViewCellText:(UITableView*)vTableView Section:(int)vSectionIndex Row:(int)vRowIndex TitleText:(NSString*) vTitleText DetialText:(NSString*) vDetailText Font:(UIFont*) vFont
{
    UITableViewCell *cell = [self SetTabelViewCellText:vTableView Section:vSectionIndex Row:vRowIndex TitleText:vTitleText DetialText:vDetailText];
    cell.detailTextLabel.font = vFont;
    return cell;
}
+(UITableViewCell*) SetTabelViewCellText:(UITableView*)vTableView Section:(int)vSectionIndex Row:(int)vRowIndex TitleText:(NSString*) vTitleText DetialText:(NSString*) vDetailText Color:(UIColor*) vColor
{
    UITableViewCell *cell = [self SetTabelViewCellText:vTableView Section:vSectionIndex Row:vRowIndex TitleText:vTitleText DetialText:vDetailText];
    cell.detailTextLabel.textColor = vColor;
    return cell;
}

//设置TableViewCellDetailText
+(UITableViewCell*) SetTabelViewCellDetailText:(UITableView*)vTableView TitleText:(NSString*) vTitleText DetialText:(NSString*) vDetailText
{
    if(vTitleText == nil || vDetailText == nil)
        return nil;
   
    NSInteger sections = vTableView.numberOfSections;
    if(sections<=0)
        return nil;
    
    NSInteger rows;
    NSIndexPath *indexPath;
    UITableViewCell *cell;
    
    for(int i=0; i<sections; i++)
    {
        rows = [vTableView numberOfRowsInSection:i];
        for(int j=0; j<rows; j++)
        {
            indexPath=[NSIndexPath indexPathForRow:j inSection:i];
            cell = [vTableView cellForRowAtIndexPath:indexPath];
            if([cell.textLabel.text isEqualToString:vTitleText])
            {
                cell.detailTextLabel.text = vDetailText;
                return cell;
            }
        }
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//显示Field值
+(void) DisplayCell:(UITableView*) vTableView Field:(NSDictionary*)vField TitleName:(NSString*)vTitleName Value:(NSString*) vValue SetColor:(BOOL) visSetColor
{
    UITableViewCell* cell=[UIHelper SetTabelViewCellDetailText:vTableView TitleText: vTitleName DetialText:vValue];
    
    if(cell==nil)
        return;
    
    if(visSetColor == false)
        return;
    
    if(vValue.floatValue==0)
    {
        cell.detailTextLabel.textColor=UIColor.blackColor;
    }
    else
    {
        if(vValue.floatValue>0)
            cell.detailTextLabel.textColor=UIColor.blueColor;
        else
            cell.detailTextLabel.textColor=UIColor.redColor;
    }
}


+(void) DisplayCell:(UITableView*) vTableView Field:(NSDictionary*)vField TitleName:(NSString*)vTitleName FieldName:(NSString*) vFieldName SetColor:(BOOL) visSetColor
{
    NSString* _value = [StringHelper sPositiveFormat:vField[vFieldName] pointNumber:2];
    [self DisplayCell:vTableView Field:vField TitleName:vTitleName Value:_value SetColor:visSetColor];
}

+(UITableViewCell*) DisplayIntCell:(UITableView*) vTableView Field:(NSDictionary*)vField TitleName:(NSString*)vTitleName FieldName:(NSString*) vFieldName
{
    NSString* value = [StringHelper sPositiveFormat:vField[vFieldName] pointNumber:0];
    UITableViewCell* cell=[UIHelper SetTabelViewCellDetailText:vTableView TitleText: vTitleName DetialText:value];
    return cell;
}







///////////////////////////////////////////////////  Alert ///////////////////////////////////////////////////
+(UIAlertController *) ShowMessage:(NSString*) vTitle Message:(NSString*)vMessage
{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:vTitle message:vMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK Action");
    }];
    [alertController addAction:okAction];
    return alertController;
}

+(UIAlertController *) ShowAlert:(NSString*) vTitle Message:(NSString*)vMessage
{
    //(UITableViewController*) vViewontroller Title:
    // 1.创建UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:vTitle
                                                                             message:vMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //这里的preferredStyle:参数有UIAlertControllerStyleAlert和UIAlertControllerStyleActionSheet两种
    
    // 2.创建并添加按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK Action");
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
    }];
    
    [alertController addAction:okAction];           // A
    [alertController addAction:cancelAction];       // B
    
    // 3.呈现UIAlertContorller
    //[vViewontroller presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
}




/*
 //Alert
 UITextField *myTextField;
 UIPickerView *myPickerView;
 NSArray *pickerArray;
 -(void) SetRefreshSeconds
 {
 // 1.创建UIAlertController
 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert Title"
 message:@"The message is ..."
 preferredStyle:UIAlertControllerStyleAlert];
 //这里的preferredStyle:参数有UIAlertControllerStyleAlert和UIAlertControllerStyleActionSheet两种
 
 // 2.1 添加文本框
 [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
 textField.placeholder = @"username";
 }];
 [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
 textField.placeholder = @"password";
 textField.secureTextEntry = YES;
 }];
 
 // 2.创建并添加按钮
 UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 NSLog(@"OK Action");
 }];
 UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
 NSLog(@"Cancel Action");
 }];
 
 [alertController addAction:okAction];           // A
 [alertController addAction:cancelAction];       // B
 
 // 3.呈现UIAlertContorller
 //[self presentViewController:alertController animated:YES completion:nil];
 
 pickerArray = [[NSArray alloc]initWithObjects:@"Chess",
 @"Cricket",@"Football",@"Tennis",@"Volleyball", nil];
 
 myTextField = [[UITextField alloc]initWithFrame:
 CGRectMake(10, 100, 300, 30)];
 
 myTextField.borderStyle = UITextBorderStyleRoundedRect;
 myTextField.textAlignment = UITextAlignmentCenter;
 myTextField.delegate = self;
 [self.view addSubview:myTextField];
 [myTextField setPlaceholder:@"Pick a Sport"];
 
 
 myPickerView = [[UIPickerView alloc]init];
 myPickerView.dataSource = self;
 myPickerView.delegate = self;
 myPickerView.showsSelectionIndicator = YES;
 UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
 initWithTitle:@"Done" style:UIBarButtonItemStyleDone
 target:self action:@selector(done:)];
 UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
 CGRectMake(0, self.view.frame.size.height-
 myPickerView.frame.size.height-50, 320, 50)];
 [toolBar setBarStyle:UIBarStyleBlackOpaque];
 NSArray *toolbarItems = [NSArray arrayWithObjects:
 doneButton, nil];
 [toolBar setItems:toolbarItems];
 myTextField.inputView = myPickerView;
 myTextField.inputAccessoryView = toolBar;
 }
 #pragma mark - Text field delegates
 
 -(void)textFieldDidBeginEditing:(UITextField *)textField{
 if ([textField.text isEqualToString:@""]) {
 [self dateChanged:nil];
 }
 }
 #pragma mark - Picker View Data source
 -(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
 return 1;
 }
 -(NSInteger)pickerView:(UIPickerView *)pickerView
 numberOfRowsInComponent:(NSInteger)component{
 return [pickerArray count];
 }
 
 #pragma mark- Picker View Delegate
 
 -(void)pickerView:(UIPickerView *)pickerView didSelectRow:
 (NSInteger)row inComponent:(NSInteger)component{
 [myTextField setText:[pickerArray objectAtIndex:row]];
 }
 - (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
 (NSInteger)row forComponent:(NSInteger)component{
 return [pickerArray objectAtIndex:row];
 }

 */

@end
