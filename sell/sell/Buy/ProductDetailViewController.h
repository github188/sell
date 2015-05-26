//
//  ProductDetailViewController.h
//  sell
//
//  Created by 韩冲 on 15/4/25.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "ParentViewController.h"

@interface ProductDetailViewController : ParentViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *dicProduct;

@end
