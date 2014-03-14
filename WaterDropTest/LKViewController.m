//
//  LKViewController.m
//  WaterDropTest
//
//  Created by ljh on 14-1-10.
//  Copyright (c) 2014年 LJH. All rights reserved.
//

#import "LKViewController.h"

@interface LKViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LKViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.headView = [[[NSBundle mainBundle] loadNibNamed:@"SYHeadInfoView3" owner:nil options:nil] lastObject];
    _tableView.tableHeaderView  = _headView;
    
    __weak LKViewController* wself = self;
    [_headView setHandleRefreshEvent:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself.headView stopRefresh];
        });
    }];
}
#pragma mark- scroll delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.headView.offsetY = scrollView.contentOffset.y;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _headView.touching = NO;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==NO)
    {
        _headView.touching = NO;
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _headView.touching = YES;
}
#pragma mark-


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10000;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
