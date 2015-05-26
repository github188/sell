//
//  CommonTool.h
//  sell
//
//  Created by 韩冲 on 15/4/23.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject

+ (void)setProductCell:(UIView *)cell detailView:(void (^)(UIView *detailView))view;

@end
