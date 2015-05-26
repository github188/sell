//
//  AddressListViewController.m
//  eAinng
//
//  Created by tmachc on 15/3/4.
//  Copyright (c) 2015年 CCWOnline. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressDetailViewController.h"
#import "ConfirmOrderViewController.h"

@interface AddressListViewController ()

@property (nonatomic, strong) UIView *viewNoList;           // 没有列表时候的提示内容
@property (nonatomic, strong) UITableView *table;           // 历史列表
@property (nonatomic, strong) NSArray *arrData;             // 历史数据

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllerTitle:@"收货地址"];
    WS(ws);
    [self.btnRight setBackgroundImage:ImageNamed(@"buy_icon_new-address.png") forState:UIControlStateNormal];
    [self.btnRight mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@21);
        make.right.mas_equalTo(@(-10));
        make.top.mas_equalTo(@31);
    }];
    [self setRightBtnShow];
    
    // 没有列表时候的提示内容
    self.viewNoList = [UIView new];
    self.viewNoList.hidden = YES;
    self.viewNoList.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.viewNoList];
    [self.viewNoList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.bottom.mas_equalTo(ws.view);
        make.top.mas_equalTo(@64);
    }];
    UIImageView *img = [UIImageView new];
    img.image = ImageNamed(@"buy_img_address.png");
    [self.viewNoList addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws.viewNoList);
        make.top.mas_equalTo(@(Design_Width(200.0)));
    }];
    UILabel *lab = [UILabel new];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = @"您还没有添加地址呦";
    lab.font = fontWithSize(22);
    lab.textColor = FontColor;
    lab.textAlignment = NSTextAlignmentCenter;
    [self.viewNoList addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.mas_equalTo(ws.viewNoList);
        make.top.mas_equalTo(img.mas_bottom).with.offset(Design_Width(44.0));
        make.height.mas_equalTo(@(Design_Width(60.0)));
    }];
    UIButton *add = [UIButton new];
    add.backgroundColor = OrangeColor;
    add.titleLabel.font = fontTitleWithSize(18);
    [add setTitle:@"新增地址" forState:UIControlStateNormal];
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    add.layer.cornerRadius = Design_Width(40.0);
    [self.viewNoList addSubview:add];
    [add addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lab.mas_bottom).with.offset(Design_Width(44.0));
        make.width.mas_equalTo(@(Design_Width(232.0)));
        make.height.mas_equalTo(@(Design_Width(80.0)));
        make.centerX.mas_equalTo(ws.viewNoList);
    }];
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
    NSDictionary *postDic = @{
                              @"command": @"addressList",
                              };
    [self addLoadingViewWithTop:64 bottom:0];
    [[HttpManager defaultManager] getRequestToUrl:HttpUrl params:postDic complete:^(BOOL successed, NSDictionary *result) {
        if (![self.activity isAnimating]) {
            return;
        }
        if (successed) {
            self.arrData = result[@"list"];
            if (self.arrData.count) {
                self.arrData = result[@"list"];
                self.viewNoList.hidden = YES;
                self.table.hidden = NO;
                [self.table reloadData];
            }
            else {
                self.viewNoList.hidden = NO;
                self.table.hidden = YES;
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

#pragma mark - button

- (IBAction)clickRightBtn:(UIButton *)sender
{
    AddressDetailViewController *viewController = [AddressDetailViewController new];
    viewController.stateOfAddress = StateNewAddress;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)editAddress:(UIButton *)sender
{
    AddressDetailViewController *viewController = [AddressDetailViewController new];
    viewController.stateOfAddress = StateChangeAddress;
    viewController.dicData = [_arrData[sender.tag - 1200] mutableCopy];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;  // 有待商榷
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor whiteColor];
        
        UILabel *labName = [UILabel new];
        labName.tag = 110;
        labName.backgroundColor = [UIColor clearColor];
        labName.font = fontWithSize(22);
        labName.textColor = FontColor;
        labName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:labName];
        [labName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@53);
            make.right.mas_equalTo(@(-110));
            make.top.mas_equalTo(@19);
            make.height.mas_equalTo(@32);
        }];
        UILabel *labAddress = [UILabel new];
        labAddress.tag = 111;
        labAddress.backgroundColor = [UIColor clearColor];
        labAddress.font = fontWithSize(16);
        labAddress.textColor = RGBCOLOR(102, 102, 102);
        labAddress.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:labAddress];
        [labAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(labName.mas_bottom);
            make.right.mas_equalTo(@(-60));
            make.left.mas_equalTo(@53);
            make.height.mas_equalTo(@22);
        }];
        UILabel *labPhone = [UILabel new];
        labPhone.tag = 112;
        labPhone.backgroundColor = [UIColor clearColor];
        labPhone.font = fontWithSize(22);
        labPhone.textColor = FontColor;
        labPhone.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:labPhone];
        [labPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(labAddress.mas_bottom);
            make.right.mas_equalTo(@(-110));
            make.left.mas_equalTo(@53);
            make.height.mas_equalTo(@32);
        }];
        
        UIImageView *sure = [UIImageView new];
        sure.tag = 113;
        sure.tag = indexPath.row * 1000 + 401;
        sure.backgroundColor = [UIColor clearColor];
        sure.image = ImageNamed(@"buy_img_on.png");
        [cell.contentView addSubview:sure];
        [sure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView);
            make.left.mas_equalTo(18.0);
            make.width.height.mas_equalTo(@(24.0));
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
        if (indexPath.row == 0) {
            // 线
            UIView *line = [UIView new];
            line.backgroundColor = RGBCOLOR(221, 221, 221);
            [cell.contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.width.top.mas_equalTo(cell.contentView);
                make.height.mas_equalTo(@1);
            }];
        }
        // 线
        UIView *line = [UIView new];
        line.backgroundColor = RGBCOLOR(221, 221, 221);
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.bottom.mas_equalTo(cell.contentView);
            make.height.mas_equalTo(@1);
        }];
        
        // 编辑
        UIButton *btnEdit = [UIButton new];
        btnEdit.backgroundColor = [UIColor clearColor];
        [btnEdit addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnEdit];
        [btnEdit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(cell.contentView);
            make.width.mas_equalTo(@50);
        }];
    }
    
    for (UIButton *btn in cell.contentView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.tag = indexPath.row + 1200;
        }
    }
    NSDictionary *dic = self.arrData[indexPath.row];
    UILabel *labName = (UILabel *)[cell.contentView viewWithTag:110];
    UILabel *labAddress = (UILabel *)[cell.contentView viewWithTag:111];
    UILabel *labPhone = (UILabel *)[cell.contentView viewWithTag:112];
    UIImageView *sure = (UIImageView *)[cell.contentView viewWithTag:113];
    labName.text = dic[@"name"];
    labAddress.text = dic[@"address"];
    labPhone.text = dic[@"phone"];
    // 我的 里面不需要选择
    if (self.stateOfAddress == StateOfJustEdit) {
        sure.hidden = YES;
    }
    else {
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.stateOfAddress == StateOfJustEdit) {
        // 直接去编辑
        UIButton *btn = [UIButton new];
        btn.tag = indexPath.row + 1200;
        [self editAddress:btn];
    }
    else {
        for (NSUInteger i = 0; i < _arrData.count; i ++) {
            UIImageView *sure = (UIImageView *)[self.table viewWithTag:i * 1000 + 401];
            sure.hidden = indexPath.row != i;
        }
        
        // 选中 传到上一页面
        int i = (int)self.navigationController.viewControllers.count;
        ConfirmOrderViewController *viewController = self.navigationController.viewControllers[i - 2];
        viewController.dicAddress = _arrData[indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
