//
//  HomeViewController.m
//  sell
//
//  Created by 韩冲 on 15/4/13.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "HomeViewController.h"
#import "ProductListViewController.h"
#import "MyViewController.h"
#import "OrderListViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) UITableView *table;      // 列表

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setControllerTitle:@"首页"];
    [self setLeftBtnHidden];
    WS(ws);
    
    self.table = [UITableView new];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, WINDOW_WIDTH)];
    self.table.tableFooterView = [UIView new];
    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.table.rowHeight = 50;
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@64);
        make.left.width.bottom.mas_equalTo(ws.view);
    }];
    UIImageView *icon = [UIImageView new];
    icon.backgroundColor = [UIColor orangeColor];
    icon.image = ImageNamed(@"");
    [self.table.tableHeaderView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.mas_equalTo(ws.table.tableHeaderView);
    }];
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView *icon = [UIImageView new];
        icon.tag = 1;
        icon.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(@(-28));
            make.centerY.mas_equalTo(cell.contentView);
            make.width.height.mas_equalTo(@16);
        }];
        
        UILabel *lab = [UILabel new];
        lab.tag = 2;
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont systemFontOfSize:17];
        [cell.contentView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_right).with.offset(5);
            make.top.height.right.mas_equalTo(cell.contentView);
        }];
    }
    UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:1];
    UILabel *lab = (UILabel *)[cell.contentView viewWithTag:2];
    if (indexPath.row == 0) {
        lab.text = @"购买";
        icon.image = ImageNamed(@"");
    }
    else if (indexPath.row == 1) {
        lab.text = @"订单";
        icon.image = ImageNamed(@"");
    }
    else if (indexPath.row == 2) {
        lab.text = @"我的";
        icon.image = ImageNamed(@"");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; // 松手之后 选中状态立即消失
    if (indexPath.row == 0) {
        ProductListViewController *viewController = [ProductListViewController new];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 1) {
        OrderListViewController *viewController = [OrderListViewController new];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.row == 2) {
        MyViewController *viewController = [MyViewController new];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
