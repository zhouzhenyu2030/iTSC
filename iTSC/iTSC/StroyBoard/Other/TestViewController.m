//
//  TestViewContoller.m
//  iTSC
//
//  Created by tss on 2019/1/19.
//  Copyright © 2019年 tss. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestViewController.h"
#import "DBHelper.h"
#import "StringHelper.h"
#import "TscConfig.h"


@implementation TestViewController


@synthesize TableView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRefresh];
}

// 设置下拉刷新
- (void)setupRefresh {
    NSLog(@"setupRefresh -- 下拉刷新");
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新"];
    //刷新图形时的颜色，即刷新的时候那个菊花的颜色
    refreshControl.tintColor = [UIColor redColor];
    [self.TableView addSubview:refreshControl];
    [refreshControl beginRefreshing];
    [self refreshClick:refreshControl];
}


// 下拉刷新触发
- (void)refreshClick:(UIRefreshControl *)refreshControl
{
    [self QueryAndDisplay];
    NSLog(@"refreshClick: -- 刷新触发");
    [refreshControl endRefreshing];
    [self.TableView reloadData];// 刷新tableView即可
}



//查询，在此获取数据
- (void)QueryAndDisplay
{
    //TableView
    //TableView.visibleCells[0].detailTextLabel.text=@"-"
    
    NSInteger sections = TableView.numberOfSections;
    if(sections<=0) return;
    
    //NSInteger rows = [TableView numberOfRowsInSection:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UITableViewCell *cell = [TableView cellForRowAtIndexPath:indexPath];
    
    
    cell.textLabel.text=@"zz";
    cell.detailTextLabel.text=@"zzy";
    
    
    NSLog(@"%@", cell.detailTextLabel.text); //=@"-";
    
    
    
   
    
    //DB Query
    NSLog(@"PosViewController: start!");
    
    
    [DBHelper Init];
    
    OHMySQLQueryContext *_queryContext=[DBHelper GetContext];
    if(_queryContext==nil)
    {
        NSLog(@"PosViewController: Init: queryContext==nil!");
        return;
    }
    
    NSLog(@"PosViewController: SELECT: start!");
    
    
    
    //SELECT
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"runtimeinfo" condition:@"ItemKey='Risk' and EntityType='A'"];
    NSError *error = nil;
    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
    
    
    NSUInteger count = tasks.count;
    if(count <= 0)
        return;
    
    
    
    
    
    //显示
    //Label_RecordTime.text = [tasks objectAtIndex:count-1][@"RecordTime"];
    
    NSDictionary  *_field;
    NSString* _typename;
    UILabel *_detail=cell.detailTextLabel;
    
    for( int i=0; i<count; i++)
    {
        _field=[tasks objectAtIndex:i];
        NSLog(@"%@", _field);
        
        _typename = _field[@"ItemType"];
        
        if([_typename isEqualToString:@"TotalDelta"])
            _detail.text = [StringHelper sPositiveFormat:_field[@"ItemValue"] pointNumber:2];
        
        //_detail.fontcolor
  
    }
    
 
    
    
    NSLog(@"PosViewController: SELECT: over!");
}

@end
