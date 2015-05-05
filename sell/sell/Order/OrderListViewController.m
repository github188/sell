//
//  OrderListViewController.m
//  sell
//
//  Created by 韩冲 on 15/5/1.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderDetailViewController.h"

@interface OrderListViewController ()

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *arrData;

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllerTitle:@"订单"];
    WS(ws);
    
    self.table = [UITableView new];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.tableFooterView = [UIView new];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@64);
        make.left.right.bottom.mas_equalTo(ws.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getDataFromNet];
}

#pragma mark - function

- (void)getDataFromNet
{
    NSDictionary *postDic = @{@"command": @"orderList"};
    [self addLoadingViewWithTop:64 bottom:0];
    [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:postDic complete:^(BOOL successed, NSDictionary *result) {
        if (![self.activity isAnimating]) {
            return;
        }
        if (successed) {
            self.arrData = result[@"list"];
            if (!self.arrData.count) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"暂时没有订单！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
            }
            [self.table reloadData];
        }
        else {
            // 失败，弹提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"错误：%@",result[@"message"]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self removeLoadingView];
    }];
}

#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrData.count;
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor whiteColor];
    }
    else {
        for (id item in cell.contentView.subviews) {
            [item removeFromSuperview];
        }
    }
    
    NSDictionary *dic = self.arrData[indexPath.section];
    
    UILabel *orderId1 = [UILabel new];
    orderId1.text = @"订单ID:";
    orderId1.backgroundColor = [UIColor clearColor];
    orderId1.font = fontWithSize(15);
    orderId1.textAlignment = NSTextAlignmentRight;
    orderId1.textColor = FontColor;
    [cell.contentView addSubview:orderId1];
    [orderId1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(@10);
        make.height.mas_equalTo(@(25));
        make.width.mas_equalTo(@70);
    }];
    
    UILabel *orderId2 = [UILabel new];
    orderId2.text = dic[@"_id"];
    orderId2.backgroundColor = [UIColor clearColor];
    orderId2.font = fontWithSize(15);
    orderId2.textAlignment = NSTextAlignmentLeft;
    orderId2.textColor = RGBCOLOR(102, 102, 102);
    [cell.contentView addSubview:orderId2];
    [orderId2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(orderId1.mas_right).with.offset(5);
        make.top.mas_equalTo(orderId1);
        make.height.mas_equalTo(@(25));
        make.right.mas_equalTo(cell.contentView);
    }];
    
    UILabel *time1 = [UILabel new];
    time1.text = @"下单时间:";
    time1.backgroundColor = [UIColor clearColor];
    time1.font = fontWithSize(15);
    time1.textAlignment = NSTextAlignmentRight;
    time1.textColor = FontColor;
    [cell.contentView addSubview:time1];
    [time1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderId1.mas_bottom);
        make.left.mas_equalTo(orderId1);
        make.height.mas_equalTo(@(25));
        make.width.mas_equalTo(@70);
    }];
    
    UILabel *time2 = [UILabel new];
    time2.text = dic[@"initTime"];
    time2.backgroundColor = [UIColor clearColor];
    time2.font = fontWithSize(15);
    time2.textAlignment = NSTextAlignmentLeft;
    time2.textColor = RGBCOLOR(102, 102, 102);
    [cell.contentView addSubview:time2];
    [time2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(time1.mas_right).with.offset(5);
        make.top.mas_equalTo(time1);
        make.height.mas_equalTo(@(25));
        make.right.mas_equalTo(cell.contentView);
    }];
    
    UILabel *product1 = [UILabel new];
    product1.text = @"产品数量:";
    product1.backgroundColor = [UIColor clearColor];
    product1.font = fontWithSize(15);
    product1.textAlignment = NSTextAlignmentRight;
    product1.textColor = FontColor;
    [cell.contentView addSubview:product1];
    [product1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(time1.mas_bottom);
        make.left.mas_equalTo(time1);
        make.height.mas_equalTo(@(25));
        make.width.mas_equalTo(@70);
    }];
    
    UILabel *product2 = [UILabel new];
    product2.text = [NSString stringWithFormat:@"%d种产品",(int)[dic[@"list"] count]];
    product2.backgroundColor = [UIColor clearColor];
    product2.font = fontWithSize(15);
    product2.textAlignment = NSTextAlignmentLeft;
    product2.textColor = RGBCOLOR(102, 102, 102);
    [cell.contentView addSubview:product2];
    [product2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(product1.mas_right).with.offset(5);
        make.top.mas_equalTo(product1);
        make.height.mas_equalTo(@(25));
        make.right.mas_equalTo(cell.contentView);
    }];
    
    UILabel *state1 = [UILabel new];
    state1.text = @"状态:";
    state1.backgroundColor = [UIColor clearColor];
    state1.font = fontWithSize(15);
    state1.textAlignment = NSTextAlignmentRight;
    state1.textColor = FontColor;
    [cell.contentView addSubview:state1];
    [state1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(product1.mas_bottom);
        make.left.mas_equalTo(product1);
        make.height.mas_equalTo(@(25));
        make.width.mas_equalTo(@70);
    }];
    
    NSArray *arr = @[@"待支付", @"待配送", @"已配送", @"已完成"];
    UILabel *state2 = [UILabel new];
    state2.text = arr[[dic[@"state"] intValue] - 1];
    state2.backgroundColor = [UIColor clearColor];
    state2.font = fontWithSize(15);
    state2.textAlignment = NSTextAlignmentLeft;
    state2.textColor = RGBCOLOR(102, 102, 102);
    [cell.contentView addSubview:state2];
    [state2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(state1.mas_right).with.offset(5);
        make.top.mas_equalTo(state1);
        make.height.mas_equalTo(@(25));
        make.right.mas_equalTo(cell.contentView);
    }];
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    OrderDetailViewController *viewController = [OrderDetailViewController new];
    viewController.dicOrder = self.arrData[indexPath.section];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
