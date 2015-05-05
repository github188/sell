//
//  AdminHomeViewController.m
//  sell
//
//  Created by 韩冲 on 15/5/1.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "AdminHomeViewController.h"
#import "AdminProListViewController.h"
#import "AdminOrderViewController.h"

@interface AdminHomeViewController ()

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *arrData;

@end

@implementation AdminHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllerTitle:@"管理员"];
    [self setLeftBtnHidden];
    WS(ws);
    
    // 产品列表
    self.table = [UITableView new];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.tableFooterView = [UIView new];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.table.scrollEnabled = false;
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@64);
        make.left.right.bottom.mas_equalTo(ws.view);
    }];
}

#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 10)];
    sectionView.backgroundColor = SystemColor;
    
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        return 1;
    }
    return 2;
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
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor whiteColor];
    
    UILabel *product = [UILabel new];
    product.textAlignment = NSTextAlignmentCenter;
    product.textColor = FontColor;
    product.font = fontWithSize(17);
    [cell.contentView addSubview:product];
    [product mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.mas_equalTo(cell.contentView);
    }];
    if (indexPath.section == 0) {
        product.text = indexPath.row ? @"订单管理" : @"管理产品";
    }
    else {
        product.text = @"退出登录";
        product.textColor = [UIColor redColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section) {
        // 退出登录
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"您确定要退出登录吗？"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"确定"
                                                        otherButtonTitles:nil];
        actionSheet.tag = 11;
        [actionSheet showInView:self.view];
    }
    else {
        if (indexPath.row == 0) {
            AdminProListViewController *viewController = [AdminProListViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else {
            AdminOrderViewController *viewController = [AdminOrderViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 11 && buttonIndex == 0) {
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
