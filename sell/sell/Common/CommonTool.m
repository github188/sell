//
//  CommonTool.m
//  sell
//
//  Created by 韩冲 on 15/4/23.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "CommonTool.h"

@implementation CommonTool


+ (void)setProductCell:(UIView *)cell detailView:(void (^)(UIView *detailView))view
{
    UIView *imgView = [UIView new];
    imgView.tag = 21;
    imgView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(Design_Width(20.0));
        make.width.height.mas_equalTo(Design_Width(238.0));
    }];
    UIImageView *img = [UIImageView new];
    img.backgroundColor = [UIColor whiteColor];
    [imgView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(imgView).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    UIView *detailView = [UIView new];
    detailView.tag = 22;
    detailView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).with.offset(2);
        make.top.bottom.mas_equalTo(imgView);
        make.right.mas_equalTo(Design_Width(-20.0));
    }];
    // 标题
    UILabel *title = [UILabel new];
    title.tag = 121;
    title.backgroundColor = [UIColor clearColor];
    title.font = fontWithSize(17);
    title.textColor = FontColor;
    title.textAlignment = NSTextAlignmentLeft;
    [detailView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(detailView);
        make.height.mas_equalTo(@(Design_Width(50.0)));
        make.left.mas_equalTo(@(Design_Width(34.0)));
        make.top.mas_equalTo(@(Design_Width(15.0)));
    }];
    // 简介
    UITextView *info = [UITextView new];
    info.tag = 122;
    info.backgroundColor = [UIColor clearColor];
    info.font = fontWithSize(14);
    info.textColor = [UIColor blackColor];
    info.textAlignment = NSTextAlignmentLeft;
    info.editable = false;
    info.userInteractionEnabled = NO;
    [detailView addSubview:info];
    [info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@(-5));
        make.height.mas_equalTo(@(Design_Width(238.0-68-78-24)));
        make.left.mas_equalTo(title.mas_left).with.offset(-2);
        make.top.mas_equalTo(title.mas_bottom).with.offset(-3);
    }];
    // 价钱
    UILabel *price = [UILabel new];
    price.tag = 123;
    price.backgroundColor = [UIColor clearColor];
    price.font = fontWithSize(17);
    price.textColor = OrangeColor;
    price.textAlignment = NSTextAlignmentLeft;
    [detailView addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(Design_Width(200.0)));
        make.height.mas_equalTo(@(Design_Width(50.0)));
        make.left.mas_equalTo(info.mas_left);
        make.bottom.mas_equalTo(@(Design_Width(-28.0)));
    }];
    view(detailView);
}

@end
