//
//  AddressDetailViewController.m
//  eAinng
//
//  Created by tmachc on 15/3/4.
//  Copyright (c) 2015年 CCWOnline. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "AddressListViewController.h"

@interface AddressDetailViewController ()

@property (nonatomic, strong) UITableView *table;               // 详情

@end

@implementation AddressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.stateOfAddress == StateNewAddress) {
        [self setControllerTitle:@"新建地址"];
        _dicData = [NSMutableDictionary new];
    }
    else {
        [self setControllerTitle:@"修改地址"];
        NSLog(@"dic--->>>%@",self.dicData);
    }
    [self setRightBtnShow];
    [self.btnRight setTitle:@"保存" forState:UIControlStateNormal];
    [self.btnRight setTitleColor:FontColor forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = fontWithSize(18);
    WS(ws);
    
    // 产品列表
    self.table = [UITableView new];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.scrollEnabled = NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@64);
        make.left.right.bottom.mas_equalTo(ws.view);
    }];
}

#pragma mark - button

- (void)clickRightBtn:(UIButton *)sender
{
    UITextField *tfName = (UITextField *)[self.table viewWithTag:600];
    UITextField *tfPhone = (UITextField *)[self.table viewWithTag:601];
    UITextField *tfAddress = (UITextField *)[self.table viewWithTag:602];
    [tfName resignFirstResponder];
    [tfPhone resignFirstResponder];
    [tfAddress resignFirstResponder];
    if ([tfName.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写姓名" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
    else if ([tfPhone.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写联系方式" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
    else if (tfPhone.text.length != 11) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写11位电话号码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
    else if ([tfAddress.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写详细地址" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
    // 验证手机号等等
    NSDictionary *postDic = @{
                              @"id": _dicData[@"_id"] ? _dicData[@"_id"] : @"",
                              @"name": _dicData[@"name"],
                              @"phone": _dicData[@"phone"],
                              @"address": _dicData[@"address"],
                              @"type": _dicData[@"_id"] ? @"2" : @"1",
                              @"command": @"changeAddress"
                              };
    [self addLoadingViewWithTop:64 bottom:0];
    [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:postDic complete:^(BOOL successed, NSDictionary *result) {
        if (![self.activity isAnimating]) {
            return;
        }
        if (successed) {
//            NSArray *ary = self.navigationController.viewControllers;
//            [(AddressListViewController *)ary[ary.count-2] getDataFromNet];
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

#pragma mark - function

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;  // 有待商榷
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 详情名称
    UILabel *name = [UILabel new];
    name.backgroundColor = [UIColor clearColor];
    name.font = fontWithSize(16);
    name.textAlignment = NSTextAlignmentLeft;
    name.textColor = FontColor;
    [cell.contentView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@20);
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@(-1));
        make.width.mas_equalTo(@105);
    }];
    UITextField *text = [UITextField new];
    text.tag = 600 + indexPath.row;
    text.textAlignment = NSTextAlignmentRight;
    text.textColor = RGBCOLOR(51, 51, 51);
    text.backgroundColor = [UIColor clearColor];
    text.font = fontWithSize(15);
    text.borderStyle = UITextBorderStyleNone;
    text.returnKeyType = UIReturnKeyNext;
    text.keyboardType = UIKeyboardTypeNumberPad;
    text.delegate = self;
    [cell.contentView addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(cell.contentView);
        make.right.mas_equalTo(@(-20));
        make.left.mas_equalTo(@90);
    }];
    switch (indexPath.row) {
        case 0: {
            name.text = @"收货人姓名";
            text.text = _dicData[@"name"];
            text.keyboardType = UIKeyboardTypeDefault;
        }
            break;
        case 1: {
            name.text = @"联系方式";
            text.text = _dicData[@"phone"];
            text.keyboardType = UIKeyboardTypePhonePad;
            text.returnKeyType = UIReturnKeyDone;
        }
            break;
        case 2: {
            name.text = @"详细地址";
            text.text = _dicData[@"address"];
            text.keyboardType = UIKeyboardTypeDefault;
        }
            break;
            
        default:
            break;
    }
    
    // 线
    UIView *line = [UIView new];
    line.backgroundColor = RGBCOLOR(221, 221, 221);
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.bottom.mas_equalTo(cell.contentView);
        make.height.mas_equalTo(@1);
    }];
    if (!indexPath.row) {
        // 线
        UIView *line = [UIView new];
        line.backgroundColor = RGBCOLOR(221, 221, 221);
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.top.mas_equalTo(cell.contentView);
            make.height.mas_equalTo(@1);
        }];
    }
    
    return cell;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    switch (textField.tag) {
        case 600:{
            UITextField *tf = (UITextField *)[self.table viewWithTag:601];
            [tf becomeFirstResponder];
        }
            break;
        case 601:{
            UITextField *tf = (UITextField *)[self.table viewWithTag:602];
            [tf becomeFirstResponder];
        }
            break;
            
        default:
            break;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 601) {
        if (textField.text.length != 11) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 600) {
        [_dicData setObject:textField.text forKey:@"name"];
    }
    else if (textField.tag == 601) {
        [_dicData setObject:textField.text forKey:@"phone"];
    }
    else if (textField.tag == 602) {
        [_dicData setObject:textField.text forKey:@"address"];
    }
//    [self.table reloadData];
}

@end
