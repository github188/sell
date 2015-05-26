//
//  AdminNewActivityViewController.m
//  sell
//
//  Created by 韩冲 on 15/5/26.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "AdminNewActivityViewController.h"

@interface AdminNewActivityViewController ()

@property (nonatomic, strong) UITextView *tv;

@end

@implementation AdminNewActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllerTitle:@"发布活动"];
    [self setRightBtnShow];
    [self.btnRight setTitle:@"发布" forState:UIControlStateNormal];
    
    _tv = [UITextView new];
    _tv.font = fontWithSize(15);
    _tv.textColor = RGBCOLOR(102, 102, 102);
    _tv.layer.borderWidth = 1;
    _tv.layer.borderColor = RGBCOLOR(150, 150, 150).CGColor;
    _tv.layer.cornerRadius = 5;
    [self.view addSubview:_tv];
    [_tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@20);
        make.right.mas_equalTo(@(-20));
        make.top.mas_equalTo(@70);
        make.height.mas_equalTo(@100);
    }];
}

- (void)clickRightBtn:(UIButton *)sender
{
    if ([_tv.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写活动内容" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
    // 验证手机号等等
    NSDictionary *postDic = @{
                              @"activity": _tv.text,
                              @"command": @"newActivity"
                              };
    [self addLoadingViewWithTop:64 bottom:0];
    [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:postDic complete:^(BOOL successed, NSDictionary *result) {
        if (![self.activity isAnimating]) {
            return;
        }
        if (successed) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            // 失败，弹提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"错误：%@",result[@"message"]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self removeLoadingView];
    }];
}

@end
