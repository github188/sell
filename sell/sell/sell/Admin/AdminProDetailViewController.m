//
//  AdminProDetailViewController.m
//  sell
//
//  Created by 韩冲 on 15/5/2.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "AdminProDetailViewController.h"

@interface AdminProDetailViewController ()

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, assign) BOOL showKeyBoard;

@end

@implementation AdminProDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(ws);
    [self setControllerTitle:@"详情"];
    [self.btnRight setTitle:@"保存" forState:UIControlStateNormal];
    [self setRightBtnShow];
    
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

- (void)clickRightBtn:(UIButton *)sender
{
    UITextField *tfName = (UITextField *)[self.table viewWithTag:600];
    UITextField *tfPrice = (UITextField *)[self.table viewWithTag:601];
    UITextField *tfIntro = (UITextField *)[self.table viewWithTag:602];
    UITextField *tfSpe = (UITextField *)[self.table viewWithTag:603];
    [tfName resignFirstResponder];
    [tfPrice resignFirstResponder];
    [tfIntro resignFirstResponder];
    [tfSpe resignFirstResponder];
    if ([tfName.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写名称" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
    else if ([tfPrice.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写价格" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
    else if ([tfIntro.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写详情" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
    else if ([tfSpe.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写规格" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
    }
    // 验证手机号等等
    NSDictionary *postDic = @{
                              @"id": _dicProduct[@"_id"] ? _dicProduct[@"_id"] : @"",
                              @"name": _dicProduct[@"name"] ? _dicProduct[@"name"] : @"",
                              @"price": _dicProduct[@"price"] ? _dicProduct[@"price"] : @"",
                              @"intro": _dicProduct[@"intro"] ? _dicProduct[@"intro"] : @"",
                              @"spe": _dicProduct[@"spe"] ? _dicProduct[@"spe"] : @"",
                              @"img": _dicProduct[@"img"] ? _dicProduct[@"img"] : @"",
                              @"command": @"initProduct"
                              };
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
        }
        [self removeLoadingView];
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
        [_img removeFromSuperview];
        _img = nil;
        _img = [UIImageView new];
        if (_dicProduct.count) {
            [_img setImageURL:ImageURL(_dicProduct[@"img"]) defaultImage:ImageNamed(@"buy_img_load_fail.png")];
        }
        else {
            UILabel *lab = [UILabel new];
            lab.text = @"点击添加图片";
            lab.textColor = FontColor;
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = fontTitleWithSize(20);
            [cell.contentView addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.width.height.mas_equalTo(cell.contentView);
            }];
        }
        [cell.contentView addSubview:_img];
        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
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
        UITextField *text = [UITextField new];
        text.tag = 600 + indexPath.row - 1;
        text.textAlignment = NSTextAlignmentRight;
        text.textColor = RGBCOLOR(51, 51, 51);
        text.backgroundColor = [UIColor clearColor];
        text.font = fontWithSize(15);
        text.borderStyle = UITextBorderStyleNone;
        text.returnKeyType = UIReturnKeyNext;
        text.delegate = self;
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
            text.keyboardType = UIKeyboardTypeNumberPad;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        UIImagePickerController *imgPicker = [UIImagePickerController new];
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imgPicker.allowsEditing = YES;
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
}

#pragma mark - imgPicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *theImage;
    NSLog(@"info--->>>%@",info);
    theImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //    theImage = [theImage fullScreenImage];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(theImage, nil, nil, nil);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    _img.image = theImage;
    [self sendImageToNet];
}

- (void)sendImageToNet
{
    [self addLoadingViewWithTop:0 bottom:0];
    NSDictionary *postDic = @{@"command": @"uploadImage"};
    NSArray *files = @[@{@"file": _img.image ,@"name":@"head.jpg"}];
    [[HttpManager defaultManager] uploadToUrl:HttpUrl params:postDic files:files process:^(NSInteger writedBytes, NSInteger totalBytes) {
        NSLog(@"%@",[NSString stringWithFormat:@"正在上传中 %.2ld%%",100*writedBytes/totalBytes]);
    } complete:^(BOOL successed, NSDictionary *result) {
        NSLog(@"result-->>%@",result);
        if (successed) {
            [_dicProduct setObject:result[@"id"] forKey:@"img"];
        }
        [self removeLoadingView];
    }];
}

#pragma mark - textField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _showKeyBoard = true;
    [self.table setContentOffset:CGPointMake(0, WINDOW_WIDTH) animated:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 600) {
        [_dicProduct setObject:textField.text forKey:@"name"];
    }
    else if (textField.tag == 601) {
        [_dicProduct setObject:textField.text forKey:@"price"];
    }
    else if (textField.tag == 602) {
        [_dicProduct setObject:textField.text forKey:@"intro"];
    }
    else if (textField.tag == 603) {
        [_dicProduct setObject:textField.text forKey:@"spe"];
    }
}


#pragma mark - scroll

// setContentOffset之后的回调
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _showKeyBoard = false;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_showKeyBoard) {
        return;
    }
    for (int i = 0; i < 4; i ++) {
        UITextField *tf = (UITextField *)[self.table viewWithTag:600 + i];
        [tf resignFirstResponder];
    }
}

@end
