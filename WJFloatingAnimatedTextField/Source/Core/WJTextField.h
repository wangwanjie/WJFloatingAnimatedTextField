//
//  WJTextField.h
//  WJFloatingAnimatedTextField
//
//  Created by VanJay on 2018/8/13.
//  Copyright © 2018年 VanJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJTextField : UITextField

/**
 取消编辑功能
 */
@property (nonatomic, assign) BOOL canelEdit;
/**
 *  光标选择的范围
 *
 *  @return 获取光标选择的范围
 */
- (NSRange)selectedRange;

/**
 *  设置光标选择的范围
 *
 *  @param range 光标选择的范围
 */
- (void)setSelectedRange:(NSRange)range;
@end
