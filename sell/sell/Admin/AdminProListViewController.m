//
//  AdminProListViewController.m
//  sell
//
//  Created by 韩冲 on 15/5/2.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "AdminProListViewController.h"
#import "AdminProDetailViewController.h"

@interface AdminProListViewController ()

@property (nonatomic, strong) UITableView *table;       // 产品列表
@property (nonatomic, strong) NSArray *arrData;           // 列表数据

@end

@implementation AdminProListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(ws);
    _arrData = @[];
    [self setControllerTitle:@"产品列表"];
    [self.btnRight setBackgroundImage:ImageNamed(@"buy_icon_new-address.png") forState:UIControlStateNormal];
    [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@21);
        make.right.mas_equalTo(@(-10));
        make.top.mas_equalTo(@31);
    }];
    [self setRightBtnShow];
    
    // 产品列表
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
    NSDictionary *postDic = @{@"command": @"productList"};
    [self addLoadingViewWithTop:64 bottom:0];
    [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:postDic complete:^(BOOL successed, NSDictionary *result) {
        if (![self.activity isAnimating]) {
            return;
        }
        if (successed) {
            self.arrData = result[@"list"];
            if (!self.arrData.count) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"暂时没有产品，请添加商品！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
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

#pragma mark - button

- (void)clickRightBtn:(UIButton *)sender
{
    AdminProDetailViewController *viewController = [AdminProDetailViewController new];
    viewController.dicProduct = [@{} mutableCopy];
    [self.navigationController pushViewController:viewController animated:YES];
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
    return Design_Width(238.0);  // 有待商榷
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        [CommonTool setProductCell:cell.contentView detailView:^(UIView *detailView) {
        }];
    }
    
    NSDictionary *dic = self.arrData[indexPath.section];
    for (UIView *view in cell.contentView.subviews) {
        if (view.tag == 21) {
            for (UIImageView *img in view.subviews) {
                [img setImageURL:ImageURL(dic[@"img"]) defaultImage:ImageNamed(@"buy_img_load_fail.png")];
            }
        }
        else {
            for (id item in view.subviews) {
                if ([item tag] == 121) {
                    ((UILabel *)item).text = dic[@"name"];
                }
                if ([item tag] == 122) {
                    ((UITextView *)item).text = [NSString stringWithFormat:@"%@\n%@",dic[@"intro"], dic[@"spe"]];
                }
                if ([item tag] == 123) {
                    ((UILabel *)item).text = [NSString stringWithFormat:@"￥%.2f",[dic[@"price"] floatValue]];
                }
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AdminProDetailViewController *viewController = [AdminProDetailViewController new];
    viewController.dicProduct = [self.arrData[indexPath.section] mutableCopy];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
