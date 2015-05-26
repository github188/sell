//
//  BuyListViewController.m
//  sell
//
//  Created by 韩冲 on 15/4/25.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "BuyListViewController.h"
#import "ProductDetailViewController.h"
#import "ConfirmOrderViewController.h"

@interface BuyListViewController ()

@property (nonatomic, strong) UITableView *table;    // 列表
@property (nonatomic, strong) NSArray *arrData;             // 数据
@property (nonatomic, strong) NSString *strPlistPath;       // plist地址
@property (nonatomic, strong) UILabel *labTotle;            // 总价
@property (nonatomic, assign) BOOL showKeyBoard;

@end

@implementation BuyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllerTitle:@"购买清单"];
    WS(ws);
    _arrData = @[];
    _strPlistPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:@"BuyList.plist"];
    
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
        make.left.mas_equalTo(@(Design_Width(40.0)));
    }];
    // 结算按钮
    UIButton *pay = [UIButton new];
    pay.backgroundColor = OrangeColor;
    pay.titleLabel.font = fontTitleWithSize(18);
    [pay setTitle:@"立刻结算" forState:UIControlStateNormal];
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
    // 历史列表
    self.table = [UITableView new];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.tableFooterView = [UIView new];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@65);
        make.bottom.mas_equalTo(payView.mas_top);
        make.left.right.mas_equalTo(ws.view);
    }];
    
    [self getDataFromPlist];
}

#pragma mark - button

- (IBAction)pay:(UIButton *)sender
{
    BOOL sure = false;
    NSMutableDictionary *dictPlist = [NSMutableDictionary dictionaryWithContentsOfFile:self.strPlistPath];
    for (NSString *key in dictPlist) {
        if ([dictPlist[key][@"num"] intValue]) {
            sure = true;
        }
    }
    if (sure) {
        ConfirmOrderViewController *viewController = [ConfirmOrderViewController new];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else {
        // 失败 弹提示
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择商品数量" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
}

// 数量加减
- (IBAction)changeNum:(UIButton *)sender
{
    UITextField *tfNum = (UITextField *)[self.table viewWithTag:(int)sender.tag/1000 + 150];
    if ([tfNum.text intValue] == 0 && sender.tag % 2 == 1) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"数量已为最小值" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        return;
    } else if ([tfNum.text intValue] >= 99) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"数量已为最大值" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
        return;
    }
    tfNum.text = [NSString stringWithFormat:@"%d",(sender.tag % 2 == 1 ? [tfNum.text intValue] - 1 : [tfNum.text intValue] + 1)];
    
    NSMutableDictionary *dictPlist = [NSMutableDictionary dictionaryWithContentsOfFile:_strPlistPath];
    NSString *key = [NSString stringWithFormat:@"%@",_arrData[(int)sender.tag/1000][@"_id"]];
    NSMutableDictionary *dic = [dictPlist[key] mutableCopy];
    [dic setObject:tfNum.text forKey:@"num"];
    [dictPlist setObject:dic forKey:key];
    [dictPlist writeToFile:_strPlistPath atomically:NO];
    [self changeTotle];
}

#pragma mark - function

- (void)getDataFromPlist
{
    NSMutableDictionary *dictPlist = [NSMutableDictionary dictionaryWithContentsOfFile:self.strPlistPath];
    NSMutableArray *ary = [NSMutableArray new];
    for (NSString *key in dictPlist) {
        [ary addObject:dictPlist[key]];
    }
    self.arrData = [NSArray arrayWithArray:ary];
    if (self.arrData.count) {
        [self changeTotle];
    }
    [self.table reloadData];
}

- (void)changeTotle
{
    NSMutableDictionary *dictPlist = [NSMutableDictionary dictionaryWithContentsOfFile:_strPlistPath];
    if (dictPlist.count) {
        float num = 0;
        for (NSString *key in dictPlist) {
            num += [dictPlist[key][@"price"] floatValue] * [dictPlist[key][@"num"] intValue];
        }
        _labTotle.text = [NSString stringWithFormat:@"￥%.2f",num];
    }
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
            // 加
            UIButton *btn2 = [UIButton new];
            btn2.tag = 132;
            [btn2 setBackgroundImage:ImageNamed(@"buy_btn_plus.png") forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
            [detailView addSubview:btn2];
            [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(@(Design_Width(-28.0)));
                make.right.mas_equalTo(@(Design_Width(-22.0)));
                make.width.height.mas_equalTo(25);
            }];
            // 数量
            UITextField *num = [UITextField new];
            num.backgroundColor = [UIColor clearColor];
            num.textAlignment = NSTextAlignmentCenter;
            num.textColor = FontColor;
            num.font = fontWithSize(13);
            num.borderStyle = UITextBorderStyleNone;
            num.background = ImageNamed(@"buy_img_input_bg.png");
            num.returnKeyType = UIReturnKeyDone;
            num.keyboardType = UIKeyboardTypeNumberPad;
            num.delegate = self;
            num.tag = 150;
            [detailView addSubview:num];
            [num mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(btn2).with.offset(-1);
                make.right.equalTo(btn2.mas_left).with.offset(-3.0);
                make.width.mas_equalTo(37);
                make.height.mas_equalTo(27);
            }];
            // 减
            UIButton *btn1 = [UIButton new];
            btn1.tag = 131;
            [btn1 setBackgroundImage:ImageNamed(@"buy_btn_minus.png") forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(changeNum:) forControlEvents:UIControlEventTouchUpInside];
            [detailView addSubview:btn1];
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(btn2);
                make.right.equalTo(num.mas_left).with.offset(-3.0);
                make.width.height.mas_equalTo(25);
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
                    ((UILabel *)item).text = [NSString stringWithFormat:@"￥%@",dic[@"price"]];
                }
                if ([item isKindOfClass:[UIButton class]]) {
                    if ([item tag] % 2 == 1) {
                        [item setTag:indexPath.section * 1000 + 131];  // 减
                    }
                    else {
                        [item setTag:indexPath.section * 1000 + 132];
                    }
                }
                if ([item isKindOfClass:[UITextField class]]) {
                    ((UITextField *)item).text = dic[@"num"];
                    [item setTag:indexPath.section + 150];
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
/*改变删除按钮的title*/
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
/*删除用到的函数*/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 请求接口删除课程
        NSMutableDictionary *dictPlist = [NSMutableDictionary dictionaryWithContentsOfFile:self.strPlistPath];
        [dictPlist removeObjectForKey:[NSString stringWithFormat:@"%@",_arrData[indexPath.section][@"_id"]]];
        [dictPlist writeToFile:_strPlistPath atomically:NO];
        [self getDataFromPlist];
    }
}

#pragma mark - UITextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _showKeyBoard = YES;
    [self.table setContentOffset:CGPointMake(0, (Design_Width(238.0) + 10) * (textField.tag - 150)) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        textField.text = @"0";
    }
    textField.text = [NSString stringWithFormat:@"%d",[textField.text intValue]];
    
    NSMutableDictionary *dictPlist = [NSMutableDictionary dictionaryWithContentsOfFile:_strPlistPath];
    NSString *key = [NSString stringWithFormat:@"%@",_arrData[textField.tag - 150][@"_id"]];
    NSMutableDictionary *dic = [dictPlist[key] mutableCopy];
    [dic setObject:textField.text forKey:@"num"];
    [dictPlist setObject:dic forKey:key];
    [dictPlist writeToFile:_strPlistPath atomically:NO];
    
    [self changeTotle];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789\n"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    // 是否为数字， 是否超出范围， 是否为0
    if (!basicTest || [[NSString stringWithFormat:@"%@%@",textField.text,string] intValue] > 99 || ([textField.text isEqualToString:@"0"] && [string isEqualToString:@"0"])) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - scroll
/**
 *  setContentOffset之后的回调
 *
 *  @param scrollView 滑动的页面
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _showKeyBoard = false;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_showKeyBoard) {
        return;
    }
    for (int i = 150; i < 150 + _arrData.count; i ++) {
        UITextField *tf = (UITextField *)[self.table viewWithTag:i];
        [tf resignFirstResponder];
    }
}


@end
