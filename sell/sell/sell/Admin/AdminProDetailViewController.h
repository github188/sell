//
//  AdminProDetailViewController.h
//  sell
//
//  Created by 韩冲 on 15/5/2.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "ParentViewController.h"

@interface AdminProDetailViewController : ParentViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *dicProduct;

@end
