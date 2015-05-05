//
//  OrderDetailViewController.h
//  eAinng
//
//  Created by Crab on 15/3/12.
//  Copyright (c) 2015年 CCWOnline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : ParentViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *dicOrder;

@end
