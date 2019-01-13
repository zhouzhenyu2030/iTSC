//
//  OCCodingHelper.m
//  iTSC
//
//  Created by tss on 2019/1/8.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 NSString* myString = @"My String\n";
 NSString* anotherString = [NSString stringWithFormat:@"%d %s", 1, @"String"];
 
 // 从一个C语言字符串创建Objective-C字符串
 NSString*  fromCString = [NSString stringWithCString:"A C string"
 encoding:NSASCIIStringEncoding];
 


 @interface MyObject : NSObject {
 int memberVar1; // 实体变量
 id  memberVar2;
 }
 
 +(return_type) class_method; // 类方法
 
 -(return_type) instance_method1; // 实例方法
 -(return_type) instance_method2: (int) p1;
 -(return_type) instance_method3: (int) p1 andPar: (int) p2;
 @end
 
 @implementation MyObject {
 int memberVar3; //私有實體變數
 }
 
 +(return_type) class_method {
 .... //method implementation
 }
 -(return_type) instance_method1 {
 ....
 }
 -(return_type) instance_method2: (int) p1 {
 ....
 }
 -(return_type) instance_method3: (int) p1 andPar: (int) p2 {
 ....
 }
 @end
 
 
 方法前面的 +/- 号代表函数的类型：加号（+）代表类方法（class method），不需要实例就可以调用，与C++ 的静态函数（static member function）相似。减号（-）即是一般的实例方法（instance method）。
 Objective-C定义一个新的方法时，名称内的冒号（:）代表参数传递
 
 
 值得一提的是不只Interface区块可定义实体变量，Implementation区块也可以定义实体变量，两者的差别在于访问权限的不同，Interface区块内的实体变量默认权限为protected，宣告于implementation区块的实体变量则默认为private，故在Implementation区块定义私有成员更匹配面向对象之封装原则，因为如此类别之私有信息就不需曝露于公开interface（.h文件）中。
 
 
 创建对象
 Objective-C创建对象需通过alloc以及init两个消息。alloc的作用是分配内存，init则是初始化对象。 init与alloc都是定义在NSObject里的方法，父对象收到这两个信息并做出正确回应后，新对象才创建完毕。以下为范例：
 MyObject * my = [[MyObject alloc] init];
 在Objective-C 2.0里，若创建对象不需要参数，则可直接使用new
 MyObject * my = [MyObject new];
 仅仅是语法上的精简，效果完全相同。
 若要自己定义初始化的过程，可以重写init方法，来添加额外的工作。（用途类似C++ 的构造函数constructor）
 
 */
 
 
 
 
 
 
 
 
 
 

/*
 // 使用NSEnumerator
 NSEnumerator *enumerator = [thePeople objectEnumerator];
 Person *p;
 
 while ( (p = [enumerator nextObject]) != nil ) {
 NSLog(@"%@ is %i years old.", [p name], [p age]);
 }
 
 // 使用依次枚举
 for ( int i = 0; i < [thePeople count]; i++ ) {
 Person *p = [thePeople objectAtIndex:i];
 NSLog(@"%@ is %i years old.", [p name], [p age]);
 }
 
 // 使用快速枚举
 for (Person *p in thePeople) {
 NSLog(@"%@ is %i years old.", [p name], [p age]);
 }
 */






/////////////////////////////////////////////////////////////////////
//Main
/////////////////////////////////////////////////////////////////////
/*
int main(int argc, char *argv[])
{
    
    @autoreleasepool {
        NSLog(@"Hello World!");
    }
    
    return 0;
}
*/
