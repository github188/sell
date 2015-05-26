//
//  PaySuccessViewController.m
//  eAinng
//
//  Created by tmachc on 15/3/24.
//  Copyright (c) 2015年 CCWOnline. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "HomeViewController.h"

@interface PaySuccessViewController ()

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllerTitle:@"支付成功"];
    [self setLeftBtnHidden];
    WS(ws);
    
    // 支付按钮
    UIButton *over = [UIButton new];
    over.backgroundColor = OrangeColor;
    over.titleLabel.font = fontTitleWithSize(18);
    [over setTitle:@"回首页" forState:UIControlStateNormal];
    [over setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    over.layer.cornerRadius = 20;
    [self.view addSubview:over];
    [over addTarget:self action:@selector(over:) forControlEvents:UIControlEventTouchUpInside];
    [over mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(Design_Width(232.0)));
        make.height.mas_equalTo(@(40));
        make.center.mas_equalTo(ws.view);
    }];
}

- (IBAction)over:(id)sender
{
    HomeViewController *home;
    for (id viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[HomeViewController class]]) {
            home = viewController;
        }
    }
    [self.navigationController popToViewController:home animated:YES];
}

@end
