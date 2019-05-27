//
//  WJFloatingAnimatedTextField.h
//  WJFloatingAnimatedTextField
//
//  Created by VanJay on 2019/4/8.
//  Copyright © 2019 VanJay. All rights reserved.
//

#import "WJFloatingAnimatedTextFieldConfig.h"
#import <UIKit/UIKit.h>

typedef void (^ClickViewBlock)(void);

typedef void (^ValueChangedBlock)(NSString *text);

@protocol WJFloatingAnimatedTextFieldDelegate <NSObject>

@optional
- (BOOL)floatingAnimatedTextFieldShouldBeginEditing:(UITextField *)textField;
- (void)floatingAnimatedTextFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)floatingAnimatedTextFieldShouldEndEditing:(UITextField *)textField;
- (void)floatingAnimatedTextFieldDidEndEditing:(UITextField *)textField;
- (void)floatingAnimatedTextFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0);
- (BOOL)floatingAnimatedTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (BOOL)floatingAnimatedTextFieldShouldClear:(UITextField *)textField;
- (BOOL)floatingAnimatedTextFieldShouldReturn:(UITextField *)textField;
@end

@interface WJFloatingAnimatedTextField : UIView
@property (nonatomic, copy) ClickViewBlock clickLeftLabelBlock;                ///< 点击左边 Label 回调
@property (nonatomic, copy) ClickViewBlock clickLeftImageViewBlock;            ///< 点击左边 Image 回调
@property (nonatomic, copy) ClickViewBlock clickRightLabelBlock;               ///< 点击右边 Label 回调
@property (nonatomic, copy) ClickViewBlock clickRightImageViewBlock;           ///< 点击右边 Image 回调
@property (nonatomic, copy) ClickViewBlock clickFloatingLabelBlock;            ///< 点击固定的标题 Label 回调
@property (nonatomic, copy) ValueChangedBlock textFieldDidChangeBlock;         ///< 输入框内容改变回调
@property (nonatomic, weak) id<WJFloatingAnimatedTextFieldDelegate> delegate;  ///< 代理
@property (nonatomic, strong, readonly) UITextField *inputTextField;           ///< 输入框，不要用此设置 text

+ (instancetype)floatingAnimatedTextFieldWithPlaceholder:(NSString *)placeholder rightIconImage:(UIImage *)rightIconImage;
- (instancetype)initWithPlaceholder:(NSString *)placeholder rightIconImage:(UIImage *)rightIconImage;
+ (instancetype)floatingAnimatedTextFieldWithPlaceholder:(NSString *)placeholder rightLabelString:(NSString *)rightLabelString;
- (instancetype)initWithPlaceholder:(NSString *)placeholder rightLabelString:(NSString *)rightLabelString;
+ (instancetype)floatingAnimatedTextFieldWithPlaceholder:(NSString *)placeholder leftIconImage:(UIImage *)leftIconImage;
- (instancetype)initWithPlaceholder:(NSString *)placeholder leftIconImage:(UIImage *)leftIconImage;
+ (instancetype)floatingAnimatedTextFieldWithPlaceholder:(NSString *)placeholder leftLabelString:(NSString *)leftLabelString;
- (instancetype)initWithPlaceholder:(NSString *)placeholder leftLabelString:(NSString *)leftLabelString;

- (void)becomeFirstResponder;
- (void)resignFirstResponder;

/**
 设置配置模型

 @param config 模型
 */
- (void)setConfig:(WJFloatingAnimatedTextFieldConfig *)config;

/**
 获取当前配置，用于二次更新

 @return 配置模型
 */
- (WJFloatingAnimatedTextFieldConfig *)getCurrentConfig;

/**
 用于代码填写输入框，请务必使用此方法设置文本框内容以触发代理方法

 @param text 填入内容
 */
- (void)setTextFieldText:(NSString *)text;

/**
 获取当前有效输入信息（忽略分隔符）
 */
- (NSString *)validInputText;

/**
 提供接口给外部控制输入框有效字符集输入
 
 @param range 变化的范围
 @param string 变化的字符
 */
- (BOOL)shouldChangeCharactersForCharacterSetInRange:(NSRange)range replacementString:(NSString *)string;

/**
 提供接口给外部控制控制输入框最大长度输入
 
 @param range 变化的范围
 @param string 变化的字符
 */
- (BOOL)shouldChangeCharactersForInputLengthMaxInRange:(NSRange)range replacementString:(NSString *)string;

/**
 提供接口给外部控制输入框小数点输入与小数位数

 @param range 变化的范围
 @param string 变化的字符
 */
- (BOOL)shouldChangeCharactersForDecimalPointLimitInRange:(NSRange)range replacementString:(NSString *)string;

/**
 提供接口给外部控制字符分隔

 @param willSetString 欲设置的文本内容
 @param location 赋值前光标的位置
 @param string 赋值前操作的字符
 */
- (BOOL)shouldChangeCharactersForSeparationWithWillSetString:(NSString *)willSetString lastEditLocation:(NSUInteger)location replacementString:(NSString *)string;

/**
 提供接口给外部控制输入是否超过设定的最大值
 
 @param range 变化的范围
 @param string 变化的字符
 */
- (BOOL)shouldChangeCharactersForForMaxInputNumberLimitInRange:(NSRange)range replacementString:(NSString *)string;

/**
 提供接口给外部控制光标修正
 
 @param text 欲设置的文本内容
 @param location 赋值前光标的位置
 @param string 赋值前操作的字符
 */
- (void)setText:(NSString *)text lastEditLocation:(NSUInteger)location replacementString:(NSString *)string;

/**
 右侧 view 自定义
 */
- (void)setCustomRightView:(UIView *)rightView;

/**
 如果右侧是个 UIImageView，此接口用于动态更改其图片
 */
- (void)setRightImageViewImage:(UIImage *)image;

/**
 设置悬浮标题属性内容
 */
- (void)setFloatingLabelAttrText:(id)attrText;

/**
 更新当前配置，此方法更新 UI 属性不做处理

 @param dict 键值对
 */
- (void)updateConfigWithDict:(NSDictionary<NSString *, id> *)dict;
@end
