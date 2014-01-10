//
//  LKViewController.h
//  WaterDropTest
//
//  Created by ljh on 14-1-10.
//  Copyright (c) 2014年 LJH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYHeadInfoView3.h"
@interface LKViewController : UIViewController
@property (strong, nonatomic) SYHeadInfoView3 *headView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
