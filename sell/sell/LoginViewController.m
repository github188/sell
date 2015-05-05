//
//  ViewController.m
//  sell
//
//  Created by 韩冲 on 15/4/12.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "AdminHomeViewController.h"

@interface LoginViewController ()

// 声明该类中用到的私有变量 在该类中是全局的 外部不可调用
@property (nonatomic, strong) UIScrollView *scrView;       // 弹出键盘时候需要滚动上去
@property (nonatomic, strong) UITextField *tfPhone;        // 手机号
@property (nonatomic, strong) UITextField *tfPassword;     // 密码
@property (nonatomic, strong) UITextField *tfCode;         // 验证码
@property (nonatomic, strong) NSTimer *timer;              // 计时器
@property (nonatomic, assign) int second;                  // 倒计时
@property (nonatomic, strong) UIButton *codeBtn;            // 获取验证码
@property (nonatomic, assign) BOOL showKeyBoard;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 没有状态的话 默认为注册 其他情况判断状态，修改顶部的标题
    if (!self.stateOfRegister) {
        self.stateOfRegister = registerPage;
    }
    if (self.stateOfRegister == registerPage) {
        [self setControllerTitle:@"注册"];
        [self setLeftBtnHidden];
    }
    else if (self.stateOfRegister == loginPage) {
        [self setControllerTitle:@"登录"];
    }
    else if (self.stateOfRegister == retrievePage) {
        [self setControllerTitle:@"找回密码"];
    }
    else if (self.stateOfRegister == changePasswordPage) {
        [self setControllerTitle:@"修改密码"];
    }
    // 初始化常用的东西
    WS(ws);
    _second = 60;
    _showKeyBoard = false;
    
    // 建一个可以滚动的页面
    _scrView = [UIScrollView new];
    _scrView.backgroundColor = [UIColor clearColor];
    _scrView.delegate = self;  // 设置代理在自己的类中，也就是出现滑动了，下方代码可以监听到
    [self.view addSubview:_scrView]; // 加到本页中
    [_scrView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 设置约束 可滑的页 左边 宽度 下边 都和本页是一样的
        make.left.width.bottom.mas_equalTo(ws.view);
        // 上面离本页 64像素（64是标题栏的高度）
        make.top.mas_equalTo(@64);
    }];
    
    // 大标题 类型为 UILabel 用于显示文字的
    UILabel *labSubTitle = [UILabel new];
    labSubTitle.text = @"自动售货机";
    labSubTitle.textAlignment = NSTextAlignmentCenter; // 中心对齐
    labSubTitle.textColor = FontColor; // 颜色为深绿（宏定义的）
    labSubTitle.font = fontWithSize(40); // 字体大小 40号
    [_scrView addSubview:labSubTitle];  // 加到本页中 下面为设置约束
    [labSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(Design_Width(100.0)));
        make.left.mas_equalTo(@20);
        make.centerX.mas_equalTo(ws.scrView);
        make.height.mas_equalTo(@45);
    }];
    
    // 手机号部分
    UIView *phoneView = [UIView new];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.scrView addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labSubTitle.mas_bottom).with.offset(36);
        make.left.mas_equalTo(@20);
        make.centerX.mas_equalTo(ws.scrView);
        make.height.mas_equalTo(@59);
    }];
    UIImageView *phoneIcon = [UIImageView new];
    phoneIcon.image = ImageNamed(self.stateOfRegister == changePasswordPage ? @"login_icon_password.png" : @"login_icon_phone.png");
    [phoneView addSubview:phoneIcon];
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(phoneView);
        make.left.mas_equalTo(@10);
        make.width.height.mas_equalTo(@25);
    }];
    // 手机号文本框
    _tfPhone = [UITextField new];
    _tfPhone.tag = 3100; // 给输入框设置个标签，页面中通过3100 就可以找到这个输入框
    _tfPhone.font = fontWithSize(16);
    _tfPhone.placeholder = @"请输入手机号，暂时只支持中国大陆";  // 设置默认显示字体
    if (WINDOW_WIDTH < 750/2) { // iphone4需要把字调小 适配用的
        [_tfPhone setValue:fontWithSize(14) forKeyPath:@"_placeholderLabel.font"];
    }
    _tfPhone.keyboardType = UIKeyboardTypeNumberPad; // 设置输入键盘的类型 数字
    _tfPhone.returnKeyType = UIReturnKeyNext;    // 设置回车键的类型 下一项
    if (self.stateOfRegister == changePasswordPage) {  // 如果是找回密码 显示不同的东西
        _tfPhone.placeholder = @"请输入旧密码密码";
        _tfPhone.keyboardType = UIKeyboardTypeASCIICapable;
        _tfPhone.secureTextEntry = YES;
    }
    _tfPhone.delegate = self;
    [phoneView addSubview:_tfPhone];
    [_tfPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(phoneView);
        make.left.mas_equalTo(phoneIcon.mas_right).with.offset(10);
        make.right.mas_equalTo(@(-10));
    }];
    
    // 密码
    UIView *passwordView = [UIView new];
    passwordView.backgroundColor = [UIColor whiteColor];
    [self.scrView addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneView.mas_bottom).with.offset(15);
        make.left.mas_equalTo(@20);
        make.centerX.mas_equalTo(ws.scrView);
        make.height.mas_equalTo(@59);
    }];
    UIImageView *passwordIcon = [UIImageView new];
    passwordIcon.image = ImageNamed(@"login_icon_password.png");
    [passwordView addSubview:passwordIcon];
    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(passwordView);
        make.left.mas_equalTo(@10);
        make.width.height.mas_equalTo(@25);
    }];
    _tfPassword = [UITextField new];
    _tfPassword.tag = 3101;
    _tfPassword.font = fontWithSize(16);
    _tfPassword.placeholder = @"请输入密码（6~16位数字或英文）";
    if (self.stateOfRegister == changePasswordPage) {
        _tfPassword.placeholder = @"请输入新密码密码（6~16位数字或英文）";
    }
    if (WINDOW_WIDTH < 750/2) {
        [_tfPassword setValue:fontWithSize(14) forKeyPath:@"_placeholderLabel.font"];
    }
    _tfPassword.keyboardType = UIKeyboardTypeASCIICapable;
    _tfPassword.returnKeyType = UIReturnKeyDone;
    if (self.stateOfRegister == registerPage || self.stateOfRegister == retrievePage) {
        _tfPassword.returnKeyType = UIReturnKeyNext;
    }
    _tfPassword.delegate = self;
    _tfPassword.secureTextEntry = YES;
    [passwordView addSubview:_tfPassword];
    [_tfPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(passwordView);
        make.left.mas_equalTo(passwordIcon.mas_right).with.offset(10);
        make.right.mas_equalTo(@(-10));
    }];
    
    // 验证码
    UIView *codeView = [UIView new];
    if (self.stateOfRegister == loginPage || self.stateOfRegister == changePasswordPage) {
        codeView.hidden = YES;
    }
    codeView.backgroundColor = [UIColor whiteColor];
    [self.scrView addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(passwordView.mas_bottom).with.offset(15);
        make.left.mas_equalTo(@20);
        make.centerX.mas_equalTo(ws.scrView);
        make.height.mas_equalTo(@59);
    }];
    _codeBtn = [UIButton new];
    _codeBtn.backgroundColor = RGBCOLOR(198, 226, 150);
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeBtn setTitleColor:RGBCOLOR(55, 101, 12) forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = fontWithSize(16);
    [_codeBtn addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    [codeView addSubview:_codeBtn];
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@106);
        make.left.top.height.mas_equalTo(codeView);
    }];
    _tfCode = [UITextField new];
    _tfCode.tag = 3102;
    _tfCode.font = fontWithSize(16);
    _tfCode.placeholder = @"请输入验证码";
    _tfCode.keyboardType = UIKeyboardTypeNumberPad;
    _tfCode.returnKeyType = UIReturnKeyDone;
    _tfCode.delegate = self;
    [codeView addSubview:_tfCode];
    [_tfCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(codeView);
        make.left.mas_equalTo(ws.codeBtn.mas_right).with.offset(15);
        make.right.mas_equalTo(@(-15));
    }];
    UIButton *add = [UIButton new];
    add.backgroundColor = OrangeColor;
    add.titleLabel.font = fontTitleWithSize(18);
    if (self.stateOfRegister == registerPage) {
        [add setTitle:@"立即注册" forState:UIControlStateNormal];
    }
    else if (self.stateOfRegister == loginPage) {
        [add setTitle:@"登录" forState:UIControlStateNormal];
    }
    else if (self.stateOfRegister == retrievePage) {
        [add setTitle:@"找回密码" forState:UIControlStateNormal];
    }
    else if (self.stateOfRegister == changePasswordPage) {
        [add setTitle:@"修改密码" forState:UIControlStateNormal];
    }
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    add.layer.cornerRadius = Design_Width(40.0);
    [self.scrView addSubview:add];
    [add addTarget:self action:@selector(clickedRegister:) forControlEvents:UIControlEventTouchUpInside];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.stateOfRegister == loginPage || self.stateOfRegister == changePasswordPage) {
            make.top.mas_equalTo(passwordView.mas_bottom).with.offset(44.0);
        }
        else {
            make.top.mas_equalTo(codeView.mas_bottom).with.offset(44.0);
        }
        make.width.mas_equalTo(@(Design_Width(232.0)));
        make.height.mas_equalTo(@(Design_Width(80.0)));
        make.centerX.mas_equalTo(ws.scrView);
    }];
    UIButton *login = [UIButton new];
    login.backgroundColor = [UIColor clearColor];
    login.titleLabel.font = fontTitleWithSize(16);
    if (self.stateOfRegister == registerPage) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"已注册过，点击登录"];
        [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(102, 102, 102) range:NSMakeRange(0, str.length - 2)];  // range代表从第几个开始，一共几个
        [str addAttribute:NSForegroundColorAttributeName value:FontColor range:NSMakeRange(str.length - 2, 2)];  // range代表从第几个开始，一共几个
        [login setAttributedTitle:str forState:UIControlStateNormal];
    }
    else if (self.stateOfRegister == loginPage) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"忘记密码？点此找回密码"];
        [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(102, 102, 102) range:NSMakeRange(0, str.length - 4)];  // range代表从第几个开始，一共几个
        [str addAttribute:NSForegroundColorAttributeName value:FontColor range:NSMakeRange(str.length - 4, 4)];  // range代表从第几个开始，一共几个
        [login setAttributedTitle:str forState:UIControlStateNormal];
    }
    else if (self.stateOfRegister == retrievePage || self.stateOfRegister == changePasswordPage) {
        login.hidden = YES;
    }
    [self.scrView addSubview:login];
    [login addTarget:self action:@selector(clickedLogin:) forControlEvents:UIControlEventTouchUpInside];
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(add.mas_bottom).with.offset(28.0);
        make.width.mas_equalTo(@215);
        make.height.mas_equalTo(@26.0);
        make.centerX.mas_equalTo(ws.scrView);
    }];
    [_scrView setContentOffset:CGPointMake(0, 0) animated:YES];
    // 如果登录了 直接进首页
    if ([userDefaults objectForKey:@"phone"]) {
        if ([[userDefaults objectForKey:@"type"] isEqualToString:@"admin"]) {
            AdminHomeViewController *viewController = [AdminHomeViewController new];
            [self.navigationController pushViewController:viewController animated:NO];
        }
        else {
            HomeViewController *homeViewController = [HomeViewController new];
            [self.navigationController pushViewController:homeViewController animated:NO];
        }
    }
}

#pragma mark - button

- (void)clickLeftBtn:(UIButton *)sender
{
    // 移除timer
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
    _scrView.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

// 验证码
- (IBAction)getCode:(id)sender
{
    if ([self.activity isAnimating]) {
        return;
    }
    [_tfPhone resignFirstResponder];
    [_tfPassword resignFirstResponder];
    [_tfCode resignFirstResponder];
    if ([_tfPhone.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写手机号" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        alert.tag = 3400;
        [alert show];
        return;
    }
    if (_tfPhone.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写正确的手机号" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        alert.tag = 3400;
        [alert show];
        return;
    }
    if (_timer.isValid) {
        return;
    }
    NSString *type;
    if (self.stateOfRegister == registerPage) {
        type = @"1";
    }    else if (self.stateOfRegister == retrievePage) {
        type = @"2";
    }
    NSDictionary *dic = @{
                          @"phone": _tfPhone.text,
                          @"command": @"getCode",
                          @"type": type
                          };
    [self addLoadingViewWithTop:64 bottom:0];
    [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:dic complete:^(BOOL successed, NSDictionary *result) {
        if (![self.activity isAnimating]) {
            return;
        }
        if (successed) {
            if ([result[@"isSuccess"] boolValue]) {
                _tfCode.text = [NSString stringWithFormat:@"%@",result[@"code"]];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setCodeTimer:) userInfo:nil repeats:YES];
            }
            else {
                // 失败 弹提示
                [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"错误：%@",result[@"message"]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
            }
        }
        [self removeLoadingView];
    }];
}
- (IBAction)clickedRegister:(id)sender
{
    if ([self.activity isAnimating]) {
        return;
    }
    [_tfPhone resignFirstResponder];
    [_tfPassword resignFirstResponder];
    [_tfCode resignFirstResponder];
    // 注册
    if ([_tfPhone.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写手机号" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        [_tfPhone becomeFirstResponder];
        return;
    }
    if ([_tfPassword.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写密码" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        [_tfPassword becomeFirstResponder];
        return;
    }
    if ([_tfCode.text isEqualToString:@""] && self.stateOfRegister != loginPage && self.stateOfRegister != changePasswordPage) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写验证码" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        [_tfCode becomeFirstResponder];
        return;
    }
    NSString *type = @"";
    if (self.stateOfRegister == registerPage) {
        type = @"1";
    }
    else if (self.stateOfRegister == retrievePage) {
        type = @"2";
    }
    else if (self.stateOfRegister == loginPage) {
        type = @"3";
    }
    NSDictionary *dic = @{
                          @"command": @"register",
                          @"phone": _tfPhone.text,
                          @"password": [_tfPassword.text md5],
                          @"code": _tfCode.text,
                          @"type": type     // 注册
                          };
    if (self.stateOfRegister == changePasswordPage) {
        dic = @{
                @"command": @"register",
                @"phone": [userDefaults objectForKey:@"phone"],
                @"OldPassword": [_tfPhone.text md5],
                @"password": [_tfPassword.text md5],
                @"type": @"4"
                };
    }
    [self addLoadingViewWithTop:64 bottom:0];
    [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:dic complete:^(BOOL successed, NSDictionary *result) {
        if (![self.activity isAnimating]) {
            return;
        }
        if (successed) {
            if ([result[@"isSuccess"] boolValue]) {
                if (self.stateOfRegister == changePasswordPage) {
                    [userDefaults removeObjectForKey:@"phone"];
                    [userDefaults removeObjectForKey:@"id"];
                    [userDefaults removeObjectForKey:@"type"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功，请重新登录" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    alert.tag = 4500;
                    [alert show];
                    return;
                }
                [userDefaults setObject:result[@"phone"] forKey:@"phone"];
                [userDefaults setObject:result[@"id"] forKey:@"id"];
                [userDefaults setObject:result[@"type"] forKey:@"type"];
                // 移除timer
                if (_timer) {
                    if ([_timer isValid]) {
                        [_timer invalidate];
                    }
                    _timer = nil;
                }
                if ([result[@"type"] isEqualToString:@"admin"]) {
                    AdminHomeViewController *viewController = [AdminHomeViewController new];
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                else {
                    HomeViewController *homeViewController = [HomeViewController new];
                    [self.navigationController pushViewController:homeViewController animated:YES];
                }
            }
            else {
                // 失败 弹提示
                [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"错误：%@",result[@"message"]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
            }
        }
        else {
            
            // 失败，弹提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"错误：%@",result[@"message"]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self removeLoadingView];
    }];
}

- (IBAction)clickedLogin:(id)sender
{
    LoginViewController *viewController = [[LoginViewController alloc] init];
    if (self.stateOfRegister == registerPage) {
        viewController.stateOfRegister = loginPage;
    }
    else if (self.stateOfRegister == loginPage) {
        viewController.stateOfRegister = retrievePage;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - function

- (void)setCodeTimer:(NSTimer *)timer
{
    if (_second) {
        [_codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",_second] forState:UIControlStateNormal];
        _second --;
    }
    else {
        _second = 60;
        [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        [timer invalidate];
    }
}

#pragma mark - textField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _showKeyBoard = YES;
    [_scrView setContentSize:CGSizeMake(WINDOW_WIDTH, 700)];
    [_scrView setContentOffset:CGPointMake(0, Design_Width(200.0)) animated:NO];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_tfPhone]) {
        [_tfPassword becomeFirstResponder];
    }
    else if ([textField isEqual:_tfPassword]) {
        if (self.stateOfRegister == loginPage || self.stateOfRegister == changePasswordPage) {
            [self clickedRegister:nil];
        }
        else {
            [_tfCode becomeFirstResponder];
        }
    }
    else if ([textField isEqual:_tfCode]) {
        [self clickedRegister:nil];
    }
    return YES;
}

#pragma mark - scroll

// setContentOffset之后的回调
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _showKeyBoard = false;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_showKeyBoard) {
        return;
    }
    if ([_tfPhone isFirstResponder] || [_tfPassword isFirstResponder] || [_tfCode isFirstResponder]) {
        [_tfPhone resignFirstResponder];
        [_tfPassword resignFirstResponder];
        [_tfCode resignFirstResponder];
    }
}

#pragma mark - alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3400) {
        [_tfPhone becomeFirstResponder];
    }
    if (alertView.tag == 4500) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
