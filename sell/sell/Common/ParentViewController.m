//
//  ParentViewController.m
//  sell
//
//  Created by 韩冲 on 15/4/12.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "ParentViewController.h"

@interface ParentViewController ()

/*
 声明顶部的导航栏，此处定义为私有的，在具体类里面不可直接调用！并且可以声明相同名字的变量
 */
@property (nonatomic, strong) UIView *viewNav;       //顶部导航栏
@property (nonatomic, strong) UILabel *labTitle;     //导航标题

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = SystemColor;
    WS(ws);
    self.viewNav = [[UIView alloc] init];
    [self.view addSubview:self.viewNav];
    [self.viewNav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(ws.view);
        make.height.mas_equalTo(@64);
    }];
    
    self.btnLeft = [UIButton new];
    [self.viewNav addSubview:self.btnLeft];
    [self.btnLeft addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@20);
        make.left.mas_equalTo(ws.viewNav).with.offset(5);
        make.width.mas_equalTo(@59);
        make.height.mas_equalTo(@44);
    }];
    self.btnLeft.titleLabel.font = fontWithSize(15);
    [self.btnLeft setTitleColor:RGBCOLOR(93, 170, 20) forState:UIControlStateNormal];
    [self.btnLeft setImage:ImageNamed(@"common_icon_back.png") forState:UIControlStateNormal];
    [self.btnLeft setImage:ImageNamed(@"common_icon_back.png") forState:UIControlStateHighlighted];
    
    self.btnRight = [UIButton new];
    [self.btnRight setTitleColor:FontColor forState:UIControlStateNormal];
    self.btnRight.hidden = YES;
    [self.viewNav addSubview:self.btnRight];
    [self.btnRight addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@20);
        make.right.mas_equalTo(ws.viewNav);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@44);
    }];
    
    self.labTitle = [[UILabel alloc] init];
    self.labTitle.textAlignment = NSTextAlignmentCenter;
    self.labTitle.font = fontTitleWithSize(22);
    self.labTitle.textColor = RGBCOLOR(93, 170, 20);
    [self.viewNav addSubview:self.labTitle];
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@20);
        make.right.equalTo(ws.viewNav).with.offset(-60);
        make.left.mas_equalTo(@60);
        make.height.mas_equalTo(@44);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - button

- (IBAction)clickLeftBtn:(UIButton *)sender
{
    if ([self.activity isAnimating]) {
        [self removeLoadingView];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickRightBtn:(UIButton *)sender
{
    
}

#pragma mark - function

- (void)setControllerTitle:(NSString *)str
{
    self.labTitle.text = str;
}

- (void)setLeftBtnHidden
{
    self.btnLeft.hidden = YES;
}

- (void)setRightBtnShow
{
    self.btnRight.hidden = NO;
}

// 添加loading
- (void)addLoadingViewWithTop:(float)top bottom:(float)bottom
{
    UIView *loadingView = [UIView new];
    loadingView.tag = 9101;
    loadingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:loadingView];
    WS(ws);
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(ws.view);
        make.top.mas_equalTo(top);
        make.bottom.mas_equalTo(-bottom);
    }];
    UIImageView *img = [UIImageView new];
    img.backgroundColor = [UIColor blackColor];
    img.alpha = 0.3;
    [loadingView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.width.height.mas_equalTo(loadingView);
    }];
    _activity = [UIActivityIndicatorView new];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [loadingView addSubview:_activity];
    [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(loadingView);
    }];
    [_activity startAnimating];
}
// 移除loading
- (void)removeLoadingView
{
    UIView *loadingView = [self.view viewWithTag:9101];
    for (id activity in loadingView.subviews) {
        if ([activity isKindOfClass:[UIActivityIndicatorView class]]) {
            [activity stopAnimating];
        }
        [activity removeFromSuperview];
    }
    [loadingView removeFromSuperview];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
