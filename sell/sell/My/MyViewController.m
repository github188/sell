//
//  MyViewController.m
//  sell
//
//  Created by 韩冲 on 15/5/1.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "MyViewController.h"
#import "LoginViewController.h"
#import "ActivityListViewController.h"
#import "NewFeedbackViewController.h"

@interface MyViewController ()

@property (nonatomic, strong) UITableView *table;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllerTitle:@"我的"];
    WS(ws);
    
    self.table = [UITableView new];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 50)];
    self.table.tableFooterView = [UIView new];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.scrollEnabled = false;
    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@64);
        make.left.right.bottom.mas_equalTo(ws.view);
    }];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 40, 40)];
    icon.image = ImageNamed(@"user_img_user.png");
    [self.table.tableHeaderView addSubview:icon];
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, WINDOW_WIDTH - 70, 40)];
    phone.text = [userDefaults stringForKey:@"phone"];
    phone.backgroundColor = [UIColor clearColor];
    phone.textColor = [UIColor blackColor];
    phone.font = fontWithSize(19);
    phone.textAlignment = NSTextAlignmentLeft;
    [self.table.tableHeaderView addSubview:phone];
}

#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 10)];
    sectionView.backgroundColor = [UIColor clearColor];
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
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
        if (indexPath.row == 0 || indexPath.row == 1) {
            UIImageView *arrow = [UIImageView new];
            arrow.tag = 403;
            arrow.backgroundColor = [UIColor clearColor];
            arrow.image = ImageNamed(@"buy_icon_more.png");
            [cell.contentView addSubview:arrow];
            [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell.contentView);
                make.right.mas_equalTo(@(-11.0));
                make.width.height.mas_equalTo(@(21.0));
            }];
        }
        
        if (indexPath.row == 0) {
            name.text = @"活动";
        }
        else if (indexPath.row == 1) {
            name.text = @"意见反馈";
        }
        else if (indexPath.row == 2) {
            name.text = @"清除缓存";
        }
        else if (indexPath.row == 3) {
            name.text = @"修改密码";
        }
    }
    else {
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 2;
        label.font = fontWithSize(17);
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"退出登录";
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.top.height.mas_equalTo(cell.contentView);
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ActivityListViewController *viewController = [ActivityListViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (indexPath.row == 1) {
            NewFeedbackViewController *viewController = [NewFeedbackViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (indexPath.row == 2) {
            // 清楚缓存
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"您确定要清楚缓存吗？"
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:@"确定"
                                                            otherButtonTitles:nil];
            actionSheet.tag = 10;
            [actionSheet showInView:self.view];
        }
        else if (indexPath.row == 3) {
            LoginViewController *viewController = [LoginViewController new];
            viewController.stateOfRegister = changePasswordPage;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else {
        // 退出登录
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"您确定要退出登录吗？"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"确定"
                                                        otherButtonTitles:nil];
        actionSheet.tag = 11;
        [actionSheet showInView:self.view];
    }
}

#pragma marks -- UIActionSheetDelegate --
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10 && buttonIndex == 0) {
        // 清楚缓存
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"已清楚缓存"
                                                           delegate:self
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else if (actionSheet.tag == 11 && buttonIndex == 0) {
        // 退出登录
        [userDefaults removeObjectForKey:@"phone"];
        [userDefaults removeObjectForKey:@"id"];
        [userDefaults removeObjectForKey:@"type"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"退出登录成功"
                                                           delegate:self
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
        alertView.tag = 1400;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag == 1400) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
