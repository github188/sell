//
//  ViewController.h
//  sell
//
//  Created by 韩冲 on 15/4/12.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

typedef NS_ENUM(NSInteger, stateOfRegister) {
    registerPage = 1,    // 注册
    loginPage,           // 登陆
    retrievePage,         // 找回密码
    changePasswordPage    // 修改密码
};

@interface LoginViewController : ParentViewController <UITextFieldDelegate, UIScrollViewDelegate>
// 所有页面原本继承的是 UIViewController 此处继承的是ParentViewController 是UIViewController基础上的扩展 有一些公共的方法
// 尖括号内是实现的代理 用于监听 输入框的变化和页面的滚动

@property (nonatomic, assign) stateOfRegister stateOfRegister; // 表示页面状态的变量 4种状态（在上方，用的是枚举）

@end

