//
//  ParentViewController.h
//  sell
//
//  Created by 韩冲 on 15/4/12.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) UIButton *btnLeft;     //左按钮
@property (nonatomic, strong) UIButton *btnRight;    //右按钮
@property (nonatomic, strong) UIActivityIndicatorView *activity;    //右按钮

/**
 *  设置每页的标题
 *
 *  @param str 标题
 */
- (void)setControllerTitle:(NSString *)str;

/**
 *  隐藏导航左按钮
 */
- (void)setLeftBtnHidden;

/**
 *  显示导航右按钮
 */
- (void)setRightBtnShow;

/**
 *  导航左按钮点击事件
 *
 *  @param sender 点击的按钮
 */
- (IBAction)clickLeftBtn:(UIButton *)sender;

/**
 *  导航右按钮点击事件
 *
 *  @param sender 点击的按钮
 */
- (IBAction)clickRightBtn:(UIButton *)sender;

/**
 *  添加loading
 *
 *  @param top    距顶部的距离
 *  @param bottom 距底部的距离
 */
- (void)addLoadingViewWithTop:(float)top bottom:(float)bottom;

/**
 *  移除loading
 */
- (void)removeLoadingView;

@end
