//
//  WJFloatingAnimatedTextFieldConfig.h
//  WJFloatingAnimatedTextField
//
//  Created by VanJay on 2019/4/12.
//  Copyright © 2019 VanJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *_Nonnull const kCharacterSetStringNumber;
UIKIT_EXTERN NSString *_Nonnull const kCharacterSetStringNumberAndLetter;

typedef void (^EventCallBackBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface WJFloatingAnimatedTextFieldConfig : NSObject
@property (nonatomic, copy) NSString *placeholder;                        ///< 占位文字
@property (nonatomic, copy) NSString *floatingText;                       ///< 悬浮文字
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;  ///< 占位属性文字
@property (nonatomic, strong) UIColor *textColor;                         ///< 输入框文字颜色
@property (nonatomic, strong) UIColor *placeholderColor;                  ///< 占位文字颜色
@property (nonatomic, strong) UIColor *floatingLabelColor;                ///< 悬浮文字颜色
@property (nonatomic, strong) UIImage *leftIconImage;                     ///< 左边icon图片，UIImage 供外部传入不限制
@property (nonatomic, strong) UIImage *rightIconImage;                    ///< 右边icon图片，UIImage 供外部传入不限制
@property (nonatomic, copy) NSString *leftLabelString;                    ///< 左边 Label
@property (nonatomic, copy) NSString *rightLabelString;                   ///< 右边 Label
@property (nonatomic, assign) UIEdgeInsets leftViewEdgeInsets;            ///< 左边 View 内边距
@property (nonatomic, assign) UIEdgeInsets rightViewEdgeInsets;           ///< 右边 View 内边距
@property (nonatomic, assign) UIEdgeInsets placeholderEdgeInsets;         ///< 占位文字内边距
@property (nonatomic, strong) UIColor *bottomLineNormalColor;             ///< 底部线条默认状态颜色
@property (nonatomic, strong) UIColor *bottomLineSelectedColor;           ///< 底部线条选中状态颜色
@property (nonatomic, strong) UIColor *leftLabelColor;                    ///< 左边文字颜色
@property (nonatomic, strong) UIColor *rightLabelColor;                   ///< 右边文字颜色
@property (nonatomic, strong) UIFont *leftLabelFont;                      ///< 左边文字字体
@property (nonatomic, strong) UIFont *rightLabelFont;                     ///< 右边文字字体
@property (nonatomic, strong) UIFont *font;                               ///< 输入框字体
@property (nonatomic, strong) UIFont *placeholderFont;                    ///< 占位文字默认字体
@property (nonatomic, strong) UIFont *floatingLabelFont;                  ///< 占位文字选中字体
@property (nonatomic, assign) CGFloat bottomLineNormalHeight;             ///< 底部线默认高度
@property (nonatomic, assign) CGFloat bottomLineSelectedHeight;           ///< 底部线选中高度
@property (nonatomic, assign) float textFieldHeightRateExceptMargin;      ///< 除固定间距外的输入框占剩余的高度比例
@property (nonatomic, assign) CGFloat marginFloatingLabelToTextField;     ///< 悬浮文字和输入框垂直间距
@property (nonatomic, assign) CGFloat marginBottomLineToTextField;        ///< 线条和输入框垂直间距
@property (nonatomic, assign) NSTimeInterval animationDuration;           ///< 动画时长
@property (nonatomic, assign) BOOL needShowOrHideRightViewAnimation;      ///< 显示\隐藏右边是否需要动画
@property (nonatomic, assign) BOOL hideRightViewWhenEditing;              ///< 编辑时是否隐藏右边的 view，默认为 NO
@property (nonatomic, assign) BOOL hideLeftViewWhenEmptyInputUnFoucused;  ///< 输入为空时未获取输入焦点时是否隐藏左边的 view，默认为 NO
@property (nonatomic, assign) NSInteger maxInputLength;                   ///< 最大输入长度，默认为0，不限制
@property (nonatomic, assign) BOOL shouldLimitInputLength;                ///<  是否限制输入长度，默认开启
@property (nonatomic, copy) NSString *characterSetString;                 ///< 限制输入的字符
@property (nonatomic, assign) double maxInputNumber;                      ///< 最大输入数字，如果输入超过这个数字，并且开启允许修改输入内容为最大输入数字的话，会自动修改输入框内容为为最大数，默认为0，不限制
@property (nonatomic, assign) BOOL allowModifyInputToMaxInputNumber;      ///< 是否开启允许修改输入内容为最大输入数字，默认为 NO
@property (nonatomic, assign) NSInteger maxDecimalsCount;                 ///< 小数点最大位数，默认为0，不限制
@property (nonatomic, assign) BOOL shouldAppendDecimalAfterEndEditing;    ///< 编辑结束后是否自动补齐小数位（根据小数点最大位数补齐），默认关闭
@property (nonatomic, assign) BOOL shouldRemoveDecimalAfterBeginEditing;  ///< 编辑开始后是否自动去除小数位，默认关闭，如果允许输入集中不包含小数点，也将去除
@property (nonatomic, assign) BOOL shouldSeparatedTextWithSymbol;         ///< 是否根据指定分隔符隔开字符，默认为 NO
@property (nonatomic, copy) NSString *separatedFormat;                    ///< 分隔格式，如 xxxx-xxxx-xxxx，xx-xxx-xxxx
@property (nonatomic, copy) NSString *separatedSymbol;                    ///< 分隔符号，如空格 | 等，支持长度不为1，默认为一个空格
@property (nonatomic, assign) UITextFieldViewMode clearButtonMode;        ///< 清除按钮模式，默认 UITextFieldViewModeWhileEditing
@property (nonatomic, assign) UIKeyboardType keyboardType;                ///< 键盘类型，默认数字
@property (nonatomic, assign) BOOL secureTextEntry;                       ///< 是否安全输入，默认 NO
@property (nonatomic, copy) EventCallBackBlock updatePropertyBlock;       ///< 需要更新属性
@property (nonatomic, copy) EventCallBackBlock updateConstraintBlock;     ///< 需要更新布局
@property (nonatomic, copy) EventCallBackBlock showRightViewBlock;        ///< 需要显示右边View

+ (instancetype)defaultConfig;
@end

NS_ASSUME_NONNULL_END
