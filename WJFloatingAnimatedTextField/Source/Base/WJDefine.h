//
//  WJKeyBoardDefine.h
//  WJKeyBoardTest
//
//  Created by VanJay on 2019/5/25.
//  Copyright © 2019 VanJay. All rights reserved.
//

#ifndef WJKeyBoardDefine_h
#define WJKeyBoardDefine_h

#import <UIKit/UIKit.h>

#define HexColor(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1]
#define WJColor(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a) / 1.0]
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

// 是否为空对象
#define WJIsObjectNil(__object) ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define WJIsStringEmpty(__string) ((__string.length == 0) || WJIsObjectNil(__string))

// 字符串不为空
#define WJIsStringNotEmpty(__string) (!WJIsStringEmpty(__string))

#define kWidthCoefficientTo6S kScreenWidth / 375.0
#define kHeightCoefficientTo6S (kScreenHeight == 812.0 ? 667.0 / 667.0 : kScreenHeight / 667.0)

// 根据ip6s的屏幕来拉伸，向下取整
#define kRealWidth(with) (floor((with) * (kWidthCoefficientTo6S)))
#define kRealHeight(with) (floor((with) * (kHeightCoefficientTo6S)))

#define iPhoneXSeries (([UIScreen mainScreen].bounds.size.height == 812) || ([UIScreen mainScreen].bounds.size.height == 896))
/** 适配顶部状态栏高度 */
#define kStatusBarH (iPhoneXSeries ? 44 : 20)

/** iphoneX底部安全区域高度 */
#define kiPhoneXSeriesSafeBottomHeight (iPhoneXSeries ? 34 : 0)

#endif /* WJKeyBoardDefine_h */
