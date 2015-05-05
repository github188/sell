//
//  ProductListViewController.m
//  sell
//
//  Created by 韩冲 on 15/4/25.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductDetailViewController.h"
#import "BuyListViewController.h"

@interface ProductListViewController ()

@property (nonatomic, strong) UITableView *table;       // 产品列表
@property (nonatomic, strong) NSArray *arrData;           // 列表数据
@property (nonatomic, strong) UILabel *labNum;            // 列表数
@property (nonatomic, strong) NSString *strPlistPath;     // plist地址

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllerTitle:@"商品"];
    WS(ws);
    _strPlistPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:@"BuyList.plist"];
    [[NSMutableDictionary new] writeToFile:_strPlistPath atomically:NO]; // 清空购买列表
    _arrData = @[];
    
    // 购物清单view
    UIView *payListView = [UIView new];
    payListView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payListView];
    [payListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(ws.view);
        make.height.mas_equalTo(@(65));
    }];
    // 列表图标
    UIImageView *icon = [UIImageView new];
    icon.image = ImageNamed(@"common_icon_order_normal.png");
    [payListView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(Design_Width(40.0)));
        make.centerY.mas_equalTo(payListView);
        make.width.height.mas_equalTo(@(21));
    }];
    // 列表内的数量
    _labNum = [UILabel new];
    _labNum.backgroundColor = OrangeColor;
    _labNum.font = fontWithSize(13);
    _labNum.textAlignment = NSTextAlignmentCenter;
    _labNum.textColor = [UIColor whiteColor];
    _labNum.layer.masksToBounds = YES;
    _labNum.layer.cornerRadius = 12;
    [payListView addSubview:_labNum];
    [_labNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(icon.mas_centerX).with.offset(Design_Width(25.0));
        make.centerY.mas_equalTo(icon.mas_centerY).with.offset(Design_Width(-21.0));
        make.width.height.mas_equalTo(@(23.0));
    }];
    // 返回列表按钮
    UIButton *list = [UIButton new];
    [list setTitle:@"购物清单" forState:UIControlStateNormal];
    [list setTitleColor:FontColor forState:UIControlStateNormal];
    list.titleLabel.font = fontWithSize(17);
    [list addTarget:self action:@selector(goToList:) forControlEvents:UIControlEventTouchUpInside];
    [payListView addSubview:list];
    [list mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.mas_equalTo(payListView);
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
        make.bottom.mas_equalTo(payListView.mas_top);
        make.left.right.mas_equalTo(ws.view);
    }];
    [self setNum];
    [self getDataFromNet];
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
            UIButton *add = [UIButton new];
            add.backgroundColor = SystemColor;
            [add setTitle:@"加入清单" forState:UIControlStateNormal];
            [add setTitleColor:FontColor forState:UIControlStateNormal];
            add.titleLabel.font = fontWithSize(14);
            [add addTarget:self action:@selector(addToList:) forControlEvents:UIControlEventTouchUpInside];
            [detailView addSubview:add];
            [add mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.mas_equalTo(@(Design_Width(-20.0)));
                make.width.mas_equalTo(@70);
                make.height.mas_equalTo(@25);
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
                if ([item tag] == 122) {
                    ((UITextView *)item).text = [NSString stringWithFormat:@"%@\n%@",dic[@"intro"], dic[@"spe"]];
                }
                if ([item tag] == 123) {
                    ((UILabel *)item).text = [NSString stringWithFormat:@"￥%.2f",[dic[@"price"] floatValue]];
                }
                if ([item isKindOfClass:[UIButton class]]) {
                    [item setTag:indexPath.section + 500];
                }
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ProductDetailViewController *productDetailViewController = [ProductDetailViewController new];
    productDetailViewController.dicProduct = self.arrData[indexPath.section];
    [self.navigationController pushViewController:productDetailViewController animated:YES];
}

#pragma mark - button

- (void)clickLeftBtn:(UIButton *)sender
{
    NSMutableDictionary *dictPlist = [NSMutableDictionary dictionaryWithContentsOfFile:_strPlistPath];
    if (dictPlist.count) { // 判断购物清单中是否有商品（字典内的数量为0 或者不为0 为0的时候进else）
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"返回首页后，购物清单将清空\n是否继续购物？" delegate:self cancelButtonTitle:@"回首页" otherButtonTitles:@"再逛逛", nil];
        alert.tag = 382;
        [alert show];
    }
    else {
        [super clickLeftBtn:sender]; // 直接调用父类的点击左导航（回上一页）
    }
}

- (IBAction)addToList:(UIButton *)sender
{
    NSMutableDictionary *dictPlist = [NSMutableDictionary dictionaryWithContentsOfFile:_strPlistPath];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.arrData[(int)sender.tag - 500]];
    int num = [dictPlist[[NSString stringWithFormat:@"%@",dic[@"_id"]]][@"num"] intValue];
    if (num) {
        [dic setObject:[NSString stringWithFormat:@"%d",num + 1] forKey:@"num"];
    }
    else {
        [dic setObject:@"1" forKey:@"num"];
    }
    [dictPlist setObject:dic forKey:[NSString stringWithFormat:@"%@",self.arrData[(int)sender.tag - 500][@"_id"]]];
    [dictPlist writeToFile:_strPlistPath atomically:NO];
    [self setNum];
}

- (IBAction)goToList:(UIButton *)sender
{
    NSMutableDictionary *dictPlist = [NSMutableDictionary dictionaryWithContentsOfFile:_strPlistPath];
    if (dictPlist.count) { // 判断购物清单中是否有商品
        BuyListViewController *viewController = [BuyListViewController new];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品，点击加入清单" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
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
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"暂时没有产品，敬请期待！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
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

- (void)setNum
{
    NSMutableDictionary *dictPlist = [NSMutableDictionary dictionaryWithContentsOfFile:_strPlistPath];
    if (dictPlist.count) {
        _labNum.text = [NSString stringWithFormat:@"%d",(int)dictPlist.count];
        _labNum.hidden = NO;
    }
    else {
        _labNum.hidden = YES;
    }
}

#pragma mark - alert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 382 && buttonIndex == 0) { // 判断弹出框的tag 并且如果点击的是第一个按钮（回首页）
        [self.navigationController popViewControllerAnimated:YES]; // 回上一页
    }
}

@end
