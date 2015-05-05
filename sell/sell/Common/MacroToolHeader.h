//
//  MacroToolHeader.h
//  eAinng
//
//  Created by tmachc on 9/4/14.
//  Copyright (c) 2014 tmachc. All rights reserved.
//


#ifndef MacroToolHeader_h
#define MacroToolHeader_h


#ifdef DEBUG
#define FLOG(str, args...) NSLog(@"\t[%s][%d][%s]  %@", strrchr(__FILE__, '/'), __LINE__, sel_getName(_cmd), [NSString stringWithFormat:str , ##args])
#define FASSERT(condition, str, args...) NSAssert(condition, @"[%s][%d][%s] %@",\
strrchr(__FILE__, '/'), __LINE__, sel_getName(_cmd), [NSString stringWithFormat:str , ##args ]); assert(condition);
#else
#define FASSERT(condition, str, args...) ((void)0)
#endif


#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IOS_7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7)

#define WINDOW_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define WINDOW_WIDTH [UIScreen mainScreen].bounds.size.width

#define KeyWindow        [[[UIApplication sharedApplication] delegate] window]

#define ImageNamed(name) [UIImage imageWithContentsOfFile:[ResourcePath stringByAppendingPathComponent:name]]
#define userDefaults     [NSUserDefaults standardUserDefaults]
#define ResourcePath     [[NSBundle mainBundle] resourcePath]    //获取自定义文件的bundle路径
#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]         //RGB进制颜色值
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]       //RGBA进制颜色值
#define HexColor(hexValue)  [UIColor colorWithRed:((float)(((hexValue) & 0xFF0000) >> 16))/255.0 green:((float)(((hexValue) & 0xFF00) >> 8))/255.0 blue:((float)((hexValue) & 0xFF))/255.0 alpha:1.0]   //16进制颜色值，如：#000000 , 注意：在使用的时候hexValue写成：0x000000

#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue] // 系统当前版本
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define fontTitleWithSize(r)  [UIFont fontWithName:@"STHeitiSC-Medium" size:(r)]
#define fontWithSize(r)  [UIFont fontWithName:@"STHeitiSC-Light" size:(r)]
#define SystemColor  RGBCOLOR(222,240,198)
#define FontColor  RGBCOLOR(90, 184, 1)
#define OrangeColor  RGBCOLOR(247, 78, 3)
//#define Design_Height(r)  ((r)/1334*WINDOW_HEIGHT)  // r按照设计的psd中的像素来计算
#define Design_Width(r)  ((r)/750*WINDOW_WIDTH)

#define ViewPickerHeight (162 + 40)

#endif
