//
//  AdminOrderDetailViewController.h
//  sell
//
//  Created by 韩冲 on 15/5/4.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "ParentViewController.h"

@interface AdminOrderDetailViewController : ParentViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *dicOrder;

@end
