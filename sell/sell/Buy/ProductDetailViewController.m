//
//  ProductDetailViewController.m
//  sell
//
//  Created by 韩冲 on 15/4/25.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()

@property (nonatomic, strong) UITableView *table;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setControllerTitle:self.dicProduct[@"name"]];
    WS(ws);
    
    self.table = [UITableView new];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.tableFooterView = [UIView new];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@64);
        make.left.right.bottom.mas_equalTo(ws.view);
    }];
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return WINDOW_WIDTH;
    }
    return 50;  // 有待商榷
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
    
    if (indexPath.row == 0) {
        UIImageView *img = [UIImageView new];
        [img setImageURL:ImageURL(_dicProduct[@"img"]) defaultImage:ImageNamed(@"buy_img_load_fail.png")];
        [cell.contentView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.width.height.mas_equalTo(cell.contentView);
        }];
    }
    else {
        UILabel *name = [UILabel new];
        name.backgroundColor = [UIColor clearColor];
        name.font = fontWithSize(16);
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = FontColor;
        [cell.contentView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@20);
            make.top.mas_equalTo(@0);
            make.bottom.mas_equalTo(@(-1));
            make.width.mas_equalTo(@105);
        }];
        UILabel *text = [UILabel new];
        text.tag = 600 + indexPath.row - 1;
        text.textAlignment = NSTextAlignmentRight;
        text.textColor = RGBCOLOR(51, 51, 51);
        text.backgroundColor = [UIColor clearColor];
        text.font = fontWithSize(15);
        [cell.contentView addSubview:text];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(cell.contentView);
            make.right.mas_equalTo(@(-20));
            make.left.mas_equalTo(@90);
        }];
        if (indexPath.row == 1) {
            name.text = @"产品名称";
            text.text = _dicProduct[@"name"];
        }
        else if (indexPath.row == 2) {
            name.text = @"产品价格";
            text.text = _dicProduct[@"price"];
        }
        else if (indexPath.row == 3) {
            name.text = @"产品描述";
            text.text = _dicProduct[@"intro"];
        }
        else if (indexPath.row == 4) {
            name.text = @"产品规格";
            text.text = _dicProduct[@"spe"];
        }
    }
    
    return cell;
}

@end
