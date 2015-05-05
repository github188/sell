//
//  AdminOrderDetailViewController.m
//  sell
//
//  Created by 韩冲 on 15/5/4.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "AdminOrderDetailViewController.h"

@interface AdminOrderDetailViewController ()

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *arrProduct;
@property (nonatomic, strong) NSDictionary *dicAddress;

@end

@implementation AdminOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllerTitle:@"订单详情"];
    WS(ws);
    _arrProduct = [@[] mutableCopy];
    _dicAddress = @{};
    
    /**
     *  state 1、未支付   2、已支付待配送   3、已配送   4、已完成
     */
    if ([_dicOrder[@"state"] intValue] == 2) {
        [self setRightBtnShow];
        [self.btnRight setTitle:@"已送达" forState:UIControlStateNormal];
    }
    
    // TableView设置
    _table = [UITableView new];
    _table.delegate = self;
    _table.dataSource = self;
    _table.showsHorizontalScrollIndicator = NO;
    _table.showsVerticalScrollIndicator = NO;
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@64);
        make.left.width.bottom.mas_equalTo(ws.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getAddress];
}

#pragma mark - button

- (void)clickRightBtn:(UIButton *)sender
{
    NSDictionary *postDic = @{@"command": @"changeOrder", @"state": @"3", @"orderId": _dicOrder[@"_id"]};
    [self addLoadingViewWithTop:64 bottom:0];
    [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:postDic complete:^(BOOL successed, NSDictionary *result) {
        if (![self.activity isAnimating]) {
            return;
        }
        if (successed) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            // 失败，弹提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"错误：%@",result[@"message"]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [self removeLoadingView];
        }
    }];
}

#pragma mark - function

- (void)getAddress
{
    NSDictionary *postDic = @{@"command": @"addressDetail", @"id": _dicOrder[@"addressID"]};
    [self addLoadingViewWithTop:64 bottom:0];
    [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:postDic complete:^(BOOL successed, NSDictionary *result) {
        if (![self.activity isAnimating]) {
            return;
        }
        if (successed) {
            _dicAddress = result;
            [self.table reloadData];
            [self removeLoadingView];
            [self getProduct];
        }
        else {
            // 失败，弹提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"错误：%@",result[@"message"]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            [self removeLoadingView];
        }
    }];
}

- (void)getProduct
{
    for (NSDictionary *dic in _dicOrder[@"list"]) {
        NSDictionary *postDic = @{@"command": @"productDetail", @"id": dic[@"productId"]};
        [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:postDic complete:^(BOOL successed, NSDictionary *result) {
            if (successed) {
                [_arrProduct addObject:result];
                [self.table reloadData];
            }
            else {
                // 失败，弹提示
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"错误：%@",result[@"message"]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2 + _arrProduct.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }
    else if (section == 1) {
        return 3;
    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1 || section == 2) {
        return 44;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = SystemColor;
    if (section == 0 || section == 1 || section == 2) {
        view.frame = CGRectMake(0, 0, WINDOW_WIDTH, 44);
        
        UILabel *labList = [UILabel new];
        labList.backgroundColor = [UIColor clearColor];
        labList.font = fontWithSize(16);
        labList.textColor = FontColor;
        labList.textAlignment = NSTextAlignmentLeft;
        [view addSubview:labList];
        [labList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.right.mas_equalTo(view);
            make.left.mas_equalTo(view).with.offset(20);
        }];
        if (section == 0) {
            labList.text = @"订单详情";
        }
        else if (section == 1) {
            labList.text = @"收货信息";
        }
        else if (section == 2) {
            labList.text = @"配送清单";
        }
    }
    else {
        view.frame = CGRectMake(0, 0, WINDOW_WIDTH, 10);
    }
    
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 50;
    if (indexPath.section == 0) {
        return height;
    }
    else if (indexPath.section == 1) {
        return height;
    }
    else {
        return Design_Width(238.0);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        for (id item in cell.contentView.subviews) {
            [item removeFromSuperview];
        }
    }
    UILabel *name = [UILabel new];
    UILabel *description = [UILabel new];
    if (indexPath.section == 0 || indexPath.section == 1) {
        cell.backgroundColor = [UIColor whiteColor];
        name.backgroundColor = [UIColor clearColor];
        name.font = fontWithSize(15);
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = RGBCOLOR(51, 51, 51);
        [cell.contentView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@(Design_Width(40.0)));
            make.top.mas_equalTo(@0);
            make.bottom.mas_equalTo(@(-1));
            make.width.mas_equalTo(@70);
        }];
        description.backgroundColor = [UIColor clearColor];
        description.font = fontWithSize(16);
        description.textAlignment = NSTextAlignmentRight;
        description.textColor = RGBCOLOR(51, 51, 51);
        [cell.contentView addSubview:description];
        [description mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(@(Design_Width(-40.0)));
            make.top.height.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(name.mas_right);
        }];
        // 线
        UIView *line = [UIView new];
        line.backgroundColor = RGBCOLOR(221, 221, 221);
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.bottom.mas_equalTo(cell.contentView);
            make.height.mas_equalTo(@1);
        }];
    }
    if (!_dicOrder.count) {
        return cell;
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                name.text = @"状态";
                NSArray *arr = @[@"待支付", @"待配送", @"已配送", @"已完成"];
                description.text = arr[[_dicOrder[@"state"] intValue] - 1];
                description.textColor = OrangeColor;
            }
                break;
            case 1: {
                name.text = @"订单ID";
                description.text = _dicOrder[@"_id"];
            }
                break;
            case 2: {
                name.text = @"订单金额";
                description.text = [NSString stringWithFormat:@"￥%@",_dicOrder[@"total"]];
                description.textColor = OrangeColor;
            }
                break;
            case 3: {
                name.text = @"支付方式";
                description.text = [_dicOrder[@"payType"] intValue] == 1 ? @"支付宝" : @"微信支付";
            }
                break;
            case 4: {
                name.text = @"下单时间";
                description.text = _dicOrder[@"initTime"];
            }
                break;
            case 5: {
                name.text = @"更新时间";
                description.text = _dicOrder[@"changeTime"];
            }
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        // 地址信息部分
        if (_dicAddress.count) {
            switch (indexPath.row) {
                case 0: {
                    name.text = @"收货人";
                    description.text = _dicAddress[@"name"];
                }
                    break;
                case 1: {
                    name.text = @"收货地址";
                    description.text = _dicAddress[@"address"];
                    description.numberOfLines = 3;
                }
                    break;
                case 2: {
                    name.text = @"联系方式";
                    description.text = _dicAddress[@"phone"];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    else {
        // 产品信息部分
        cell.backgroundColor = [UIColor clearColor];
        [CommonTool setProductCell:cell.contentView detailView:^(UIView *detailView) {
            // 数量
            UILabel *labAddress = [UILabel new];
            labAddress.backgroundColor = [UIColor clearColor];
            labAddress.tag = 124;
            labAddress.font = fontWithSize(19);
            labAddress.textColor = FontColor;
            labAddress.textAlignment = NSTextAlignmentRight;
            [detailView addSubview:labAddress];
            [labAddress mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.mas_equalTo(@(Design_Width(-20.0)));
                make.width.mas_equalTo(@(Design_Width(140.0)));
                make.height.mas_equalTo(@(Design_Width(50.0)));
            }];
        }];
        
        NSDictionary *dic = self.arrProduct[indexPath.section - 2];
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
                    else if ([item tag] == 122) {
                        ((UITextView *)item).text = [NSString stringWithFormat:@"%@\n%@",dic[@"intro"], dic[@"spe"]];
                    }
                    else if ([item tag] == 123) {
                        ((UILabel *)item).text = [NSString stringWithFormat:@"￥%@",dic[@"price"]];
                    }
                    else if ([item tag] == 124) {
                        ((UILabel *)item).text = [NSString stringWithFormat:@"x %@",_dicOrder[@"list"][indexPath.section - 2][@"num"]];
                    }
                }
            }
        }
    }
    
    return cell;
}

@end
