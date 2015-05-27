//
//  ConfirmOrderViewController.m
//  eAinng
//
//  Created by tmachc on 15/3/4.
//  Copyright (c) 2015年 CCWOnline. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "AddressListViewController.h"
#import "PaySuccessViewController.h"
#import "HomeViewController.h"

@interface ConfirmOrderViewController ()

@property (nonatomic, strong) UITableView *table;           // 列表
@property (nonatomic, strong) NSArray *arrData;             // 数据
@property (nonatomic, strong) UILabel *labTotle;            // 总价
@property (nonatomic, strong) NSString *strPlistPath;       // plist地址
@property (nonatomic, strong) UIButton *btnAddress;         // 选择地址
@property (nonatomic, strong) NSString *strAddressId;       // AddressId
@property (nonatomic, strong) NSString *orderid;            // 订单id

@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllerTitle:@"确认订单"];
    WS(ws);
    self.strPlistPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:@"BuyList.plist"];
    _dicAddress = @{};
    
    // 结算view
    UIView *payView = [UIView new];
    payView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payView];
    [payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(ws.view);
        make.height.mas_equalTo(@(65));
    }];
    // 总价
    _labTotle = [UILabel new];
    _labTotle.text = @"￥0";
    _labTotle.backgroundColor = [UIColor clearColor];
    _labTotle.font = fontWithSize(26);
    _labTotle.textColor = OrangeColor;
    _labTotle.textAlignment = NSTextAlignmentLeft;
    [payView addSubview:_labTotle];
    [_labTotle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(payView);
        make.left.mas_equalTo(@(20));
    }];
    // 支付按钮
    UIButton *pay = [UIButton new];
    pay.backgroundColor = OrangeColor;
    pay.titleLabel.font = fontTitleWithSize(18);
    [pay setTitle:@"去支付" forState:UIControlStateNormal];
    [pay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    pay.layer.cornerRadius = 20;
    [payView addSubview:pay];
    [pay addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    [pay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@(Design_Width(-20.0)));
        make.width.mas_equalTo(@(Design_Width(232.0)));
        make.height.mas_equalTo(@(40));
        make.centerY.mas_equalTo(payView);
    }];
    // 产品列表
    self.table = [UITableView new];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 5 + 40 + 59 + 12 + 40)];
    self.table.tableFooterView = [UIView new];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(64));
        make.bottom.mas_equalTo(payView.mas_top);
        make.left.right.mas_equalTo(ws.view);
    }];
    
    // 上半部分
    // 送货地址
    UILabel *labAddress = [UILabel new];
    labAddress.backgroundColor = [UIColor clearColor];
    labAddress.text = @"送货地址";
    labAddress.font = fontWithSize(16);
    labAddress.textColor = FontColor;
    labAddress.textAlignment = NSTextAlignmentLeft;
    [self.table.tableHeaderView addSubview:labAddress];
    [labAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@5);
        make.height.mas_equalTo(@40);
        make.left.mas_equalTo(@20);
        make.right.mas_equalTo(@0);
    }];
    _btnAddress = [UIButton new];
    _btnAddress.backgroundColor = [UIColor whiteColor];
    [_btnAddress setTitle:@"请选择地址" forState:UIControlStateNormal];
    [_btnAddress setTitleColor:FontColor forState:UIControlStateNormal];
    _btnAddress.titleLabel.font = fontWithSize(17);
    [_btnAddress addTarget:self action:@selector(clickAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.table.tableHeaderView addSubview:_btnAddress];
    [_btnAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
        make.width.mas_equalTo(ws.table.tableHeaderView);
        make.top.mas_equalTo(labAddress.mas_bottom);
        make.height.mas_equalTo(@(59));
    }];
    // 送货地址
    UILabel *labList = [UILabel new];
    labList.backgroundColor = [UIColor clearColor];
    labList.text = @"购买清单";
    labList.font = fontWithSize(16);
    labList.textColor = FontColor;
    labList.textAlignment = NSTextAlignmentLeft;
    [self.table.tableHeaderView addSubview:labList];
    [labList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnAddress.mas_bottom).with.offset(12);
        make.right.mas_equalTo(@0);
        make.height.mas_equalTo(@40);
        make.left.mas_equalTo(@20);
    }];
    
    [self getDataFromPlist];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.dicAddress.count) {
        _strAddressId = self.dicAddress[@"_id"];
        [_btnAddress setTitle:self.dicAddress[@"address"] forState:UIControlStateNormal];
    }
    else {
        _strAddressId = @"";
        [_btnAddress setTitle:@"请选择地址" forState:UIControlStateNormal];
    }
}

#pragma mark - function

- (void)getDataFromPlist
{
    float totle = 0;
    NSMutableDictionary *dictPlist = [NSMutableDictionary dictionaryWithContentsOfFile:self.strPlistPath];
    NSMutableArray *ary = [NSMutableArray new];
    NSString *ids = @"";
    for (NSString *key in dictPlist) {
        if ([dictPlist[key][@"num"] intValue]) {
            [ary addObject:dictPlist[key]];
            totle += [dictPlist[key][@"price"] floatValue] * [dictPlist[key][@"num"] intValue];
            if ([ids isEqualToString:@""]) {
                ids = dictPlist[key][@"_id"];
            }
            else {
                ids = [NSString stringWithFormat:@"%@,%@",ids,dictPlist[key][@"_id"]];
            }
            _labTotle.text = [NSString stringWithFormat:@"￥%.2f",totle];
        }
    }
    self.arrData = [NSArray arrayWithArray:ary];
    [self.table reloadData];
}


#pragma mark - button

- (IBAction)pay:(UIButton *)sender
{
    if ([_strAddressId isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择地址" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        return;
    }
    NSString *product = @"";
    for (NSDictionary *dic in _arrData) {
        if ([product isEqualToString:@""]) {
            product = [NSString stringWithFormat:@"%@,%@",dic[@"_id"],dic[@"num"]];
        }
        else {
            product = [NSString stringWithFormat:@"%@/%@,%@",product,dic[@"_id"],dic[@"num"]];
        }
    }
    NSDictionary *postDic = @{
                              @"projectAndNum": product,
                              @"addressID": _strAddressId,
                              @"total": [[_labTotle.text componentsSeparatedByString:@"￥"] lastObject],
                              @"command": @"initOrder"
                              };
    [self addLoadingViewWithTop:0 bottom:0];
    [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:postDic complete:^(BOOL successed, NSDictionary *result) {
        if (![self.activity isAnimating]) {
            return;
        }
        if (successed) {
            if (result[@"isSuccess"]) {
                NSLog(@"code---->>>%@",result[@"id"]);
                _orderid = result[@"id"];
                NSString *strPlistPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:@"BuyList.plist"];
                [[NSMutableDictionary new] writeToFile:strPlistPath atomically:NO];
                [[[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"暂不支付" destructiveButtonTitle:nil otherButtonTitles:@"支付宝支付", @"微信支付", nil] showInView:self.view];
                // destructiveButtonTitle   为红色字
                // otherButtonTitles        为蓝色字
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

- (IBAction)clickAddress:(UIButton *)sender
{
    AddressListViewController *viewController = [AddressListViewController new];
    viewController.stateOfAddress = StateOfSelect;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return 0;
    }
    return 12;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                else if ([item tag] == 122) {
                    ((UITextView *)item).text = [NSString stringWithFormat:@"%@\n%@",dic[@"intro"], dic[@"spe"]];
                }
                else if ([item tag] == 123) {
                    ((UILabel *)item).text = [NSString stringWithFormat:@"￥%@",dic[@"price"]];
                }
                else if ([item tag] == 124) {
                    ((UILabel *)item).text = [NSString stringWithFormat:@"x %@",dic[@"num"]];
                }
                if ([item isKindOfClass:[UIButton class]]) {
                    [item setTag:indexPath.section + 500];
                }
            }
        }
    }
    
    return cell;
}

#pragma mark - alert

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *paymentType = @"";
    if (buttonIndex == 0) {
        // 支付宝
        NSLog(@"支付宝");
        paymentType = @"1";
    }
    else if (buttonIndex == 1) {
        // 微信
        NSLog(@"微信");
        paymentType = @"2";
    }
    else {
        // 取消
        HomeViewController *home;
        for (id viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[HomeViewController class]]) {
                home = viewController;
            }
        }
        [self.navigationController popToViewController:home animated:YES];
        return;
    }
    // PaymentType 1支付宝 2微信
    NSDictionary *postDic = @{
                              @"command": @"changeOrder",
                              @"state": @"4",
                              @"orderId": _orderid,
                              @"payType": paymentType
                              };
    [self addLoadingViewWithTop:0 bottom:0];
    [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:postDic complete:^(BOOL successed, NSDictionary *result) {
        if (successed) {
            PaySuccessViewController *viewController = [PaySuccessViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else {
            // 失败，弹提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"错误：%@",result[@"message"]] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self removeLoadingView];
    }];
}

@end
