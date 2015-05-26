//
//  ActivityListViewController.m
//  sell
//
//  Created by 韩冲 on 15/5/26.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "ActivityListViewController.h"

@interface ActivityListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *arrData;

@end

@implementation ActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllerTitle:@"活动列表"];
    _arrData = @[];
    WS(ws);
    
    self.table = [UITableView new];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.tableFooterView = [UIView new];
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@64);
        make.left.right.bottom.mas_equalTo(ws.view);
    }];
    [self getDataFromNet];
}

- (void)getDataFromNet
{
    NSDictionary *postDic = @{@"command": @"activityList"};
    [self addLoadingViewWithTop:64 bottom:0];
    [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:postDic complete:^(BOOL successed, NSDictionary *result) {
        if (![self.activity isAnimating]) {
            return;
        }
        if (successed) {
            self.arrData = result[@"list"];
            if (!self.arrData.count) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"暂时没有活动" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    else {
        for (id item in cell.contentView.subviews) {
            [item removeFromSuperview];
        }
    }
    
    NSDictionary *dic = _arrData[indexPath.row];
    UILabel *phone = [UILabel new];
    phone.text = dic[@"date"];
    phone.backgroundColor = [UIColor clearColor];
    phone.font = fontWithSize(16);
    phone.textAlignment = NSTextAlignmentLeft;
    phone.textColor = RGBCOLOR(102, 102, 102);
    [cell.contentView addSubview:phone];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@20);
        make.top.mas_equalTo(@0);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@(WINDOW_WIDTH - 20));
    }];
    UITextView *feedback = [UITextView new];
    feedback.text = dic[@"activity"];
    feedback.font = fontWithSize(14);
    feedback.editable = NO;
    [cell.contentView addSubview:feedback];
    [feedback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@25);
        make.right.mas_equalTo(@(-25));
        make.top.mas_equalTo(phone.mas_bottom);
        make.height.mas_equalTo(@(68));
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
