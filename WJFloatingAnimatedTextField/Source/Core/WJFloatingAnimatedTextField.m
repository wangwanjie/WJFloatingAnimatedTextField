//
//  WJFloatingAnimatedTextField.m
//  WJFloatingAnimatedTextField
//
//  Created by VanJay on 2019/4/8.
//  Copyright © 2019 VanJay. All rights reserved.
//

#import "WJFloatingAnimatedTextField.h"
#import "FBKVOController+Extension.h"
#import "NSString+Size.h"
#import "WJDefine.h"
#import "WJFrameLayout.h"
#import "WJTextField.h"

#define MAS_SHORTHAND_GLOBALS

#import <Masonry/Masonry.h>

@interface WJFloatingAnimatedTextField () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *leftLabel;                                      ///< 左边 Label
@property (nonatomic, strong) UILabel *rightLabel;                                     ///< 右边 Label
@property (nonatomic, strong) UIImageView *leftImageView;                              ///< 左边图片
@property (nonatomic, strong) UIImageView *rightImageView;                             ///< 右边图片
@property (nonatomic, strong) WJTextField *textField;                                  ///< 输入框
@property (nonatomic, strong) UILabel *placeholderLabel;                               ///< 占位文字 Label
@property (nonatomic, strong) UILabel *floatingLabel;                                  ///< 悬浮文字 Label
@property (nonatomic, strong) UIView *lineView;                                        ///< 线条
@property (nonatomic, strong) UIView *downPartContainer;                               ///< 下部分容器，设计便于维护
@property (nonatomic, assign, getter=isPlaceholderFloating) BOOL placeholderFloating;  ///< 占位文字是否已经悬浮
@property (nonatomic, assign, getter=isBottomLineFocusing) BOOL bottomLineFocusing;    ///<  底部横线是否聚焦
@property (nonatomic, strong) WJFloatingAnimatedTextFieldConfig *config;               ///< 配置模型
@property (nonatomic, assign) BOOL isSimulateInput;                                    ///< 标志是否模拟输入，用于判断
@property (nonatomic, strong) UIView *customRightView;                                 ///< 自定义的右边视图
@end

@implementation WJFloatingAnimatedTextField {
    FBKVOController *_KVOController;
}

#pragma mark - life cycle
+ (instancetype)floatingAnimatedTextFieldWithPlaceholder:(NSString *)placeholder rightIconImage:(UIImage *)rightIconImage {
    return [[self alloc] initWithPlaceholder:placeholder rightIconImage:rightIconImage];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder rightIconImage:(UIImage *)rightIconImage {
    self = [super init];
    if (!self) return nil;

    _config.placeholder = placeholder;
    _config.rightIconImage = rightIconImage;

    [self commonInit];

    return self;
}

+ (instancetype)floatingAnimatedTextFieldWithPlaceholder:(NSString *)placeholder rightLabelString:(NSString *)rightLabelString {
    return [[self alloc] initWithPlaceholder:placeholder rightLabelString:rightLabelString];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder rightLabelString:(NSString *)rightLabelString {
    self = [super init];
    if (!self) return nil;

    _config.placeholder = placeholder;
    _config.rightLabelString = rightLabelString;

    [self commonInit];

    return self;
}

+ (instancetype)floatingAnimatedTextFieldWithPlaceholder:(NSString *)placeholder leftIconImage:(UIImage *)leftIconImage {
    return [[self alloc] initWithPlaceholder:placeholder leftIconImage:leftIconImage];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder leftIconImage:(UIImage *)leftIconImage {
    self = [super init];
    if (!self) return nil;

    _config.placeholder = placeholder;
    _config.leftIconImage = leftIconImage;

    [self commonInit];

    return self;
}

+ (instancetype)floatingAnimatedTextFieldWithPlaceholder:(NSString *)placeholder leftLabelString:(NSString *)leftLabelString {
    return [[self alloc] initWithPlaceholder:placeholder leftLabelString:leftLabelString];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder leftLabelString:(NSString *)leftLabelString {
    self = [super init];
    if (!self) return nil;

    _config.placeholder = placeholder;
    _config.leftLabelString = leftLabelString;

    [self commonInit];

    return self;
}

- (void)commonInit {
    NSAssert(!_config.leftLabelString || !_config.leftIconImage, @"同一侧图片和文字不能共存");
    NSAssert(!_config.rightLabelString || !_config.rightIconImage, @"同一侧图片和文字不能共存");

    [self addPartContainer];

    if (_config.leftLabelString) {
        [self addLeftLabel];
    }

    if (_config.leftIconImage) {
        [self addLeftImageView];
    }

    if (_config.rightLabelString) {
        [self addRightLabel];
    }

    if (_config.rightIconImage) {
        [self addRightImageView];
    }

    [self addTextField];

    [self addFloatingLabel];

    _floatingLabel.hidden = !_config.floatingText;

    [self addPlaceHolderLabel];

    [self addBottomLineView];

    // 添加约束
    [self activeOrUpdateConstraints];
}

- (void)addPartContainer {

    if (!_downPartContainer) {
        _downPartContainer = [[UIView alloc] init];
        [self addSubview:_downPartContainer];
    }
}

- (void)addLeftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        [_downPartContainer addSubview:_leftLabel];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftLabel:)];
        [_leftLabel addGestureRecognizer:recognizer];
    }
    if (WJIsStringEmpty(_textField.text) && _config.hideLeftViewWhenEmptyInputUnFoucused && WJIsStringEmpty(_config.floatingText)) {
        _leftLabel.hidden = YES;
    } else {
        _leftLabel.hidden = NO;
    }

    _leftLabel.userInteractionEnabled = YES;
    _leftLabel.font = _config.leftLabelFont;
    _leftLabel.text = _config.leftLabelString;
    _leftLabel.textColor = _config.leftLabelColor;
    _leftLabel.textAlignment = NSTextAlignmentLeft;
}

- (void)addLeftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:_config.leftIconImage];
        [_downPartContainer addSubview:_leftImageView];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftImageView:)];
        [_leftImageView addGestureRecognizer:recognizer];
    }
    if (WJIsStringEmpty(_textField.text) && _config.hideLeftViewWhenEmptyInputUnFoucused && WJIsStringEmpty(_config.floatingText)) {
        _leftImageView.hidden = YES;
    } else {
        _leftImageView.hidden = NO;
    }
    _leftImageView.userInteractionEnabled = YES;
}

- (void)addRightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        [_downPartContainer addSubview:_rightLabel];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightLabel:)];
        [_rightLabel addGestureRecognizer:recognizer];
    }
    _rightLabel.userInteractionEnabled = YES;
    _rightLabel.font = _config.rightLabelFont;
    _rightLabel.text = _config.rightLabelString;
    _rightLabel.textColor = _config.rightLabelColor;
    _rightLabel.textAlignment = NSTextAlignmentRight;
}

- (void)addRightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithImage:_config.rightIconImage];
        [_downPartContainer addSubview:_rightImageView];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightImageView:)];
        [_rightImageView addGestureRecognizer:recognizer];
    }
    _rightImageView.userInteractionEnabled = YES;
}

- (void)addTextField {
    if (!_textField) {
        _textField = [[WJTextField alloc] init];
        [_downPartContainer addSubview:_textField];
        [_textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
        [self addTextFieldObserver];
    }
    _textField.font = _config.font;
    _textField.tintColor = HexColor(0xf83460);
    _textField.clearButtonMode = _config.clearButtonMode;
    _textField.textColor = _config.textColor;
    _textField.delegate = self;
    _textField.keyboardType = _config.keyboardType;
    _textField.secureTextEntry = _config.secureTextEntry;
}

- (void)addPlaceHolderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        [_downPartContainer addSubview:_placeholderLabel];
    }
    if (_config.placeholder) {
        _placeholderLabel.text = _config.placeholder;
    } else if (_config.attributedPlaceholder) {
        _placeholderLabel.attributedText = _config.attributedPlaceholder;
    }
    // 设置图层锚点
    _placeholderLabel.layer.anchorPoint = CGPointMake(0, 0.5);
    _placeholderLabel.userInteractionEnabled = NO;
    _placeholderLabel.font = _config.placeholderFont;
    _placeholderLabel.textColor = self.isPlaceholderFloating ? _config.floatingLabelColor : _config.placeholderColor;
}

- (void)addFloatingLabel {
    if (!_floatingLabel) {
        _floatingLabel = [[UILabel alloc] init];
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedFloatingLabel:)];
        [_floatingLabel addGestureRecognizer:recognizer];
        [self addSubview:_floatingLabel];
    }
    _floatingLabel.userInteractionEnabled = YES;
    _floatingLabel.text = _config.floatingText ?: @"占位文字";
    _floatingLabel.textColor = _config.floatingLabelColor;
    _floatingLabel.font = _config.floatingLabelFont;
}

- (void)addBottomLineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        [self addSubview:_lineView];
    }
    _lineView.backgroundColor = self.isBottomLineFocusing ? _config.bottomLineSelectedColor : _config.bottomLineNormalColor;
}

- (void)activeOrUpdateConstraints {
    CGFloat constVMargin = self.config.marginFloatingLabelToTextField + (self.isBottomLineFocusing ? self.config.bottomLineSelectedHeight : self.config.bottomLineNormalHeight) + self.config.marginBottomLineToTextField;

    if (_floatingLabel) {
        [_floatingLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_floatingLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
        }];
    }

    [_downPartContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.floatingLabel.mas_bottom).offset(self.config.marginFloatingLabelToTextField);
        make.bottom.equalTo(self).offset(-constVMargin + self.config.marginFloatingLabelToTextField);
    }];

    if (_leftLabel) {
        [_leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.downPartContainer).offset(self.config.leftViewEdgeInsets.left);
            make.top.equalTo(self.downPartContainer).offset(self.config.leftViewEdgeInsets.top);
            make.bottom.equalTo(self.downPartContainer).offset(-self.config.leftViewEdgeInsets.bottom);
        }];
    }

    if (_leftImageView) {
        CGFloat leftImageWidth = _leftImageView.image.size.width;
        [_leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.downPartContainer).offset(self.config.leftViewEdgeInsets.left);
            make.centerY.equalTo(self.textField);
            make.width.mas_equalTo(leftImageWidth);
        }];
    }

    if (_rightLabel) {
        [_rightLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.downPartContainer).offset(-self.config.rightViewEdgeInsets.right);
            make.top.equalTo(self.downPartContainer).offset(self.config.rightViewEdgeInsets.top);
            make.bottom.equalTo(self.downPartContainer).offset(-self.config.rightViewEdgeInsets.bottom);
        }];
    }

    if (_rightImageView) {
        CGFloat rightImageWidth = _rightImageView.image.size.width;
        [_rightImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.downPartContainer).offset(-self.config.rightViewEdgeInsets.right);
            make.centerY.equalTo(self.textField);
            make.width.mas_equalTo(rightImageWidth);
        }];
    }

    [self activeDefaultTextFieldConstraint];

    if (self.isPlaceholderFloating) {
        [self enterTextFieldFocusCompletion:nil];
    }

    [self activeBottomLineViewConstraintIsFocused:[self shouldBottomLineBeFocused]];
}

- (void)activeDefaultTextFieldConstraint {

    UIView *leftView = _leftImageView ? _leftImageView : _leftLabel;
    UIView *rightView = _rightImageView ? _rightImageView : _rightLabel;

    if (_customRightView) {
        rightView = _customRightView;
        [rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.textField);
            make.right.mas_equalTo(self.downPartContainer);
            make.size.mas_equalTo(rightView.frame.size);
        }];
    }

    if (_textField) {
        [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (leftView && !leftView.isHidden) {
                make.left.equalTo(leftView.mas_right).offset(self.config.leftViewEdgeInsets.right);
            } else {
                make.left.equalTo(self.downPartContainer);
            }
            if (rightView) {
                make.right.equalTo(rightView.mas_left).offset(-self.config.rightViewEdgeInsets.left);
            } else {
                make.right.equalTo(self.downPartContainer);
            }
            make.top.bottom.equalTo(self.downPartContainer);
        }];
    }

    [self activeDefaultPlaceHolderLabelConstraint];
}

- (void)activeDefaultPlaceHolderLabelConstraint {
    UIView *leftView = _leftImageView ? _leftImageView : _leftLabel;

    if (_placeholderLabel) {
        [_placeholderLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.textField).offset(-(self.config.placeholderEdgeInsets.left + self.config.placeholderEdgeInsets.right));
            make.height.equalTo(self.textField).offset(-(self.config.placeholderEdgeInsets.top + self.config.placeholderEdgeInsets.bottom));
            make.top.equalTo(self.textField).offset(self.config.placeholderEdgeInsets.top);

            if (WJIsStringEmpty(self.config.floatingText) && leftView && self.config.hideLeftViewWhenEmptyInputUnFoucused && !leftView.isHidden) {
                make.centerX.equalTo(leftView.mas_left).offset(self.config.placeholderEdgeInsets.left);
            } else {
                make.centerX.equalTo(self.textField.mas_left).offset(self.config.placeholderEdgeInsets.left);
            }
        }];
    }
}

- (void)activeBottomLineViewConstraintIsFocused:(BOOL)focusing {

    _lineView.backgroundColor = focusing ? _config.bottomLineSelectedColor : _config.bottomLineNormalColor;
    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.downPartContainer);
        make.height.equalTo(focusing ? @(self.config.bottomLineSelectedHeight) : @(self.config.bottomLineNormalHeight));
        make.bottom.equalTo(self);
    }];
}

- (void)setDefaultValue {
    _config = [self defaultConfig];
    __weak __typeof(self) weakSelf = self;
    _config.updatePropertyBlock = ^() {
        [weakSelf commonInit];
    };
    _config.updateConstraintBlock = ^() {
        [weakSelf activeOrUpdateConstraints];
    };
    _config.showRightViewBlock = ^() {
        [weakSelf showRightView];
    };
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValue];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setDefaultValue];
    }
    return self;
}

#pragma mark - event response
- (void)tappedLeftLabel:(UITapGestureRecognizer *)recognizer {
    !self.clickLeftLabelBlock ?: self.clickLeftLabelBlock();
}

- (void)tappedRightLabel:(UITapGestureRecognizer *)recognizer {
    !self.clickRightLabelBlock ?: self.clickRightLabelBlock();
}

- (void)tappedLeftImageView:(UITapGestureRecognizer *)recognizer {
    !self.clickLeftImageViewBlock ?: self.clickLeftImageViewBlock();
}

- (void)tappedRightImageView:(UITapGestureRecognizer *)recognizer {
    !self.clickRightImageViewBlock ?: self.clickRightImageViewBlock();
}

- (void)tappedFloatingLabel:(UITapGestureRecognizer *)recognizer {
    !self.clickFloatingLabelBlock ?: self.clickFloatingLabelBlock();
}

- (void)textFieldDidChange:(UITextField *)textField {
    !self.textFieldDidChangeBlock ?: self.textFieldDidChangeBlock(textField.text);

    // 判断是否要悬浮
    if (!_floatingLabel.isHidden) {
        if (textField.text.length) {
            _placeholderLabel.hidden = YES;
        } else {
            _placeholderLabel.hidden = NO;
        }
    }
}

#pragma mark - private methods
- (void)addTextFieldObserver {
    // 添加观察者
    if (!_KVOController) {
        _KVOController = [FBKVOController controllerWithObserver:self];

        [_KVOController hd_observe:self.textField
                           keyPath:@"text"
                             block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
                                 if (object == self.textField) {
                                     NSString *oldText = change[NSKeyValueChangeOldKey];
                                     NSString *newText = change[NSKeyValueChangeNewKey];
                                     if (![newText isEqualToString:oldText]) {
                                         [self.textField sendActionsForControlEvents:UIControlEventEditingChanged];
                                     }
                                 }
                             }];
    }
}

- (void)enterTextFieldFocusCompletion:(void (^)(BOOL finished))completion {

    __weak __typeof(self) weakSelf = self;

    [self setNeedsLayout];

    if (!self.isSimulateInput) {
        [UIView animateWithDuration:_config.animationDuration
            animations:^{
                weakSelf.lineView.backgroundColor = weakSelf.config.bottomLineSelectedColor;
                [self activeBottomLineViewConstraintIsFocused:YES];

                [self layoutIfNeeded];
            }
            completion:^(BOOL finished) {
                weakSelf.bottomLineFocusing = YES;
                // 已经在上部了就不执行动画但是要传回回调触发外部方法
                if (![self shouldPlaceholderLabelBeFocused]) {
                    if (completion) {
                        completion(finished);
                    }
                }
            }];
    }

    // 已经在上部了就不执行动画
    if (![self shouldPlaceholderLabelBeFocused]) return;

    if (!_floatingLabel.isHidden) return;

    [self showLeftView];

    // 执行占位文字动画
    [self addPlaceHolderLabelSelectedAnimationCompletion:completion];
}

- (void)exitTextFieldFocus {

    __weak __typeof(self) weakSelf = self;
    [self setNeedsLayout];

    [UIView animateWithDuration:_config.animationDuration
        animations:^{
            [self activeBottomLineViewConstraintIsFocused:NO];

            [self layoutIfNeeded];
        }
        completion:^(BOOL finished) {
            weakSelf.bottomLineFocusing = NO;
        }];

    // 有内容不执行，只改线条
    if (![self shouldPlaceholderLabelBeUnFocused]) return;

    if (!_floatingLabel.isHidden) return;

    [self hideLeftView];

    // 执行占位文字动画
    [self addPlaceHolderLabelUnSelectedAnimation];
}

- (void)addPlaceHolderLabelSelectedAnimationCompletion:(void (^)(BOOL finished))completion {
    // 计算上部分高度
    CGFloat currentBottomLineHeight = self.isBottomLineFocusing ? self.config.bottomLineSelectedHeight : self.config.bottomLineNormalHeight;

    CGFloat floatingLabelTextHeight = [@"占位文字，计算高度" boundingALLRectWithSize:CGSizeMake(CGFLOAT_MAX, 10) font:self.config.floatingLabelFont].height;
    CGFloat placeholderLabelTextHeight = [@"占位文字，计算高度" boundingALLRectWithSize:CGSizeMake(CGFLOAT_MAX, 10) font:self.config.placeholderFont].height;

    CGFloat heightScale = floatingLabelTextHeight / placeholderLabelTextHeight;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(heightScale, heightScale);

    CGFloat transHeight = self.placeholderLabel.bounds.size.height * 0.5 + self.config.marginFloatingLabelToTextField + floatingLabelTextHeight * 0.5;
    CGAffineTransform transTransform = CGAffineTransformMakeTranslation(-_placeholderLabel.frame.origin.x, -transHeight + currentBottomLineHeight);

    _placeholderFloating = YES;
    [UIView animateWithDuration:_config.animationDuration
                     animations:^{
                         self.placeholderLabel.transform = CGAffineTransformConcat(scaleTransform, transTransform);
                     }
                     completion:completion];
}

- (void)addPlaceHolderLabelUnSelectedAnimation {

    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, 1);
    CGAffineTransform transTransform = CGAffineTransformMakeTranslation(0, 0);

    _placeholderFloating = NO;
    [UIView animateWithDuration:_config.animationDuration
                     animations:^{
                         self.placeholderLabel.transform = CGAffineTransformConcat(scaleTransform, transTransform);
                     }];
}

- (void)showLeftView {
    UIView *leftView = _leftImageView ? _leftImageView : _leftLabel;
    BOOL shouldOperaForLeftView = leftView && leftView.isHidden && _config.hideLeftViewWhenEmptyInputUnFoucused && [self shouldPlaceholderLabelBeFocused];
    if (shouldOperaForLeftView) {
        leftView.hidden = NO;
        leftView.alpha = 0;
        [self activeDefaultTextFieldConstraint];

        [UIView animateWithDuration:_config.animationDuration
                         animations:^{
                             leftView.alpha = 1;
                         }];
    }
}

- (void)hideLeftView {
    UIView *leftView = _leftImageView ? _leftImageView : _leftLabel;
    BOOL shouldOperaForLeftView = leftView && !leftView.isHidden && _config.hideLeftViewWhenEmptyInputUnFoucused && [self shouldPlaceholderLabelBeUnFocused];
    if (shouldOperaForLeftView) {
        leftView.alpha = 1;

        [UIView animateWithDuration:_config.animationDuration
            animations:^{
                leftView.alpha = 0;
            }
            completion:^(BOOL finished) {
                leftView.hidden = YES;
            }];
    }
}

- (void)showRightView {

    UIView *rightView = _rightImageView ? _rightImageView : _rightLabel;

    if (!rightView.isHidden) return;

    // 不要动画
    if (!_config.needShowOrHideRightViewAnimation) {
        rightView.hidden = NO;
        [self activeDefaultTextFieldConstraint];
        return;
    }

    // 要动画
    rightView.hidden = NO;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:_config.animationDuration
        animations:^{
            rightView.transform = scaleTransform;
        }
        completion:^(BOOL finished) {
            [self activeDefaultTextFieldConstraint];
        }];
}

- (void)hideRightView {

    __weak __typeof(self) weakSelf = self;

    UIView *leftView = _leftImageView ? _leftImageView : _leftLabel;
    UIView *rightView = _rightImageView ? _rightImageView : _rightLabel;

    if (rightView.isHidden && _textField.right == self.width) return;

    void (^UpdateTextFieldContraints)(void) = ^(void) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (leftView) {
                make.left.equalTo(leftView.mas_right).offset(strongSelf.config.leftViewEdgeInsets.right);
            } else {
                make.left.equalTo(strongSelf.downPartContainer);
            }
            make.right.equalTo(strongSelf.downPartContainer);
            make.top.bottom.equalTo(strongSelf.downPartContainer);
        }];
    };

    // 不要动画
    if (!_config.needShowOrHideRightViewAnimation) {
        rightView.hidden = YES;
        UpdateTextFieldContraints();
        return;
    }

    // 要动画
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.1, 0.1);

    void (^ConstrainAnimation)(void) = ^(void) {
        // 解决重新布局时内容闪动
        [self setNeedsLayout];
        [UIView animateWithDuration:weakSelf.config.animationDuration * 0.5
                         animations:^{
                             UpdateTextFieldContraints();
                             [self layoutIfNeeded];
                         }];
    };

    [UIView animateWithDuration:_config.animationDuration * 0.5
        animations:^{
            rightView.transform = scaleTransform;
        }
        completion:^(BOOL finished) {
            rightView.hidden = YES;

            ConstrainAnimation();
        }];
}

/**
 模拟触发代理方法
 
 @param text 要设置的字符串
 */
- (void)simulateCallShouldChangeCharactersMethodWithText:(NSString *)text {
    // 模拟触发 shouldChangeCharactersInRange 代理方法即使返回 YES，也是不会增加最后一个字符的，所以模拟时应当模拟输入一个字符集中的的字符即可
    if (text) {

        if (self.config.shouldSeparatedTextWithSymbol) {
            [self shouldChangeCharactersForSeparationWithWillSetString:text lastEditLocation:text.length replacementString:@""];
        } else {
            [self setText:text lastEditLocation:text.length replacementString:@""];
        }

        /*
        self.textField.text = text;
        NSString *replacementString = @"x";
        if (self.config.characterSetString && self.config.characterSetString.length > 0) {
            replacementString = [self.config.characterSetString substringToIndex:1];
        }
        NSRange range = NSMakeRange(text.length, 0);
        [self textField:self.textField shouldChangeCharactersInRange:range replacementString:replacementString];
         */
    }
}

- (void)setProceduralChangedTextFieldText {
    NSString *replacementString = @"x";
    if (self.config.characterSetString && self.config.characterSetString.length > 0) {
        replacementString = [self.config.characterSetString substringToIndex:1];
    }
    if (self.config.shouldSeparatedTextWithSymbol) {  // 需要分隔才进入
        [self shouldChangeCharactersForSeparationWithWillSetString:self.textField.text lastEditLocation:self.textField.text.length replacementString:replacementString];
    } else {
        [self setText:self.textField.text lastEditLocation:self.textField.text.length replacementString:replacementString];
    }
}

#pragma mark - judge
- (BOOL)shouldBottomLineBeFocused {
    BOOL ret = NO;
    if (_textField.isEditing) {
        ret = YES;
    }
    return ret;
}

- (BOOL)shouldPlaceholderLabelBeFocused {
    return !self.isPlaceholderFloating;
}

- (BOOL)shouldPlaceholderLabelBeUnFocused {
    return !_textField.text.length && self.isPlaceholderFloating;
}

#pragma mark - public methods
- (void)becomeFirstResponder {
    [_textField becomeFirstResponder];
}

- (void)resignFirstResponder {
    [_textField resignFirstResponder];
}

- (UITextField *)inputTextField {
    return _textField;
}

- (void)setTextFieldText:(NSString *)text {

    self.isSimulateInput = YES;

    if (!_floatingLabel.isHidden) {
        [self simulateCallShouldChangeCharactersMethodWithText:text];
    } else {
        __weak __typeof(self) weakSelf = self;
        [self enterTextFieldFocusCompletion:^(BOOL finished) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf simulateCallShouldChangeCharactersMethodWithText:text];
            strongSelf.isSimulateInput = NO;
        }];
    }
}

- (NSString *)validInputText {
    NSString *text = self.textField.text;
    if (self.config.shouldSeparatedTextWithSymbol) {
        text = [text stringByReplacingOccurrencesOfString:self.config.separatedSymbol withString:@""];
    }
    return text;
}

- (WJFloatingAnimatedTextFieldConfig *)defaultConfig {
    if (!_config) {
        _config = [WJFloatingAnimatedTextFieldConfig defaultConfig];
    }
    return _config;
}

- (BOOL)shouldChangeCharactersForCharacterSetInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL res = YES;

    if ([string isEqualToString:@""]) return res;

    if (self.config.characterSetString && self.config.characterSetString.length > 0) {
        NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:self.config.characterSetString];
        int i = 0;
        while (i < string.length) {
            NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
            NSRange range = [str rangeOfCharacterFromSet:tmpSet];
            if (range.location == NSNotFound) {
                res = NO;
                break;
            }
            i++;
        }
    }
    return res;
}

- (BOOL)shouldChangeCharactersForInputLengthMaxInRange:(NSRange)range replacementString:(NSString *)string {

    BOOL res = YES;

    if ([string isEqualToString:@""]) return res;
    // 处理位数输入限制
    if (self.config.shouldLimitInputLength && self.config.maxInputLength > 0) {
        NSInteger compareLength = self.config.maxInputLength;
        // 获取位数应该去除分隔符
        if (self.config.shouldSeparatedTextWithSymbol) {
            // 比较长度忽略分隔符的长度
            NSArray *sepArr = [self.textField.text componentsSeparatedByString:self.config.separatedSymbol];
            compareLength = compareLength + (sepArr.count - 1) * self.config.separatedSymbol.length;
        }

        // 如果在判断之前位数已经超出了，则设置为最大位数
        if (self.textField.text.length > compareLength) {
            NSString *text = [self.textField.text substringToIndex:self.config.maxInputLength];
            [self setText:text lastEditLocation:range.location replacementString:string];
            res = NO;
        }

        NSUInteger proposedNewLength = self.textField.text.length - range.length + string.length;
        if (proposedNewLength > compareLength) {
            res = NO;
        }
    }
    return res;
}

- (BOOL)shouldChangeCharactersForDecimalPointLimitInRange:(NSRange)range replacementString:(NSString *)string {

    BOOL res = YES;

    if ([string isEqualToString:@""]) return res;

    NSString *text = self.textField.text;
    NSMutableString *mutableWillSetString = [NSMutableString stringWithString:text];
    [mutableWillSetString insertString:string atIndex:range.location];

    // 判断将要输入的数字小数位是否超出，解决从中间插入小数点
    if ([mutableWillSetString containsString:@"."]) {
        NSArray *textSplitArr = [mutableWillSetString componentsSeparatedByString:@"."];
        if (textSplitArr.count == 2) {
            NSString *decimalString = textSplitArr[1];
            // 这里注意处理删除动作
            if (string.length > 0 && self.config.maxDecimalsCount > 0 && decimalString.length > self.config.maxDecimalsCount) {
                res = NO;
            }
        } else if (textSplitArr.count > 2) {  // 大于2就是多个小数点了
            res = NO;
        }
    }
    return res;
}

- (BOOL)shouldChangeCharactersForSeparationWithWillSetString:(NSString *)willSetString lastEditLocation:(NSUInteger)location replacementString:(NSString *)string {

    // 处理分割
    if (self.config.shouldSeparatedTextWithSymbol) {
        NSString *currText = willSetString;
        NSString *originText = [currText copy];
        if ([currText rangeOfString:self.config.separatedSymbol].location != NSNotFound) {
            // 已经分隔过，先还原拿到原值
            originText = [currText stringByReplacingOccurrencesOfString:self.config.separatedSymbol withString:@""];
        }
        // 获取分隔格式数组
        NSArray<NSString *> *formattedStrArr = [self.config.separatedFormat componentsSeparatedByString:@"-"];
        NSMutableString *newStr = [NSMutableString string];
        NSInteger lastIndex = 0;

        for (short i = 0; i < formattedStrArr.count; i++) {
            NSString *subStr = formattedStrArr[i];
            NSInteger length = lastIndex + subStr.length;
            if (originText.length >= length) {
                NSString *subStr2 = [originText substringWithRange:NSMakeRange(lastIndex, subStr.length)];
                if (i == formattedStrArr.count - 1) {
                    subStr2 = [originText substringFromIndex:lastIndex];
                }
                if (lastIndex == 0) {
                    [newStr appendString:subStr2];
                } else {
                    [newStr appendString:[self.config.separatedSymbol stringByAppendingString:subStr2]];
                }
                lastIndex = lastIndex + subStr.length;
            } else {
                NSString *lastPartStr = [originText substringFromIndex:lastIndex];
                if (lastPartStr.length > 0) {
                    if (lastIndex == 0) {
                        [newStr appendString:lastPartStr];
                    } else {
                        [newStr appendString:[self.config.separatedSymbol stringByAppendingString:lastPartStr]];
                    }
                }
                // 跳出循环
                break;
            }
        }
        [self setText:newStr lastEditLocation:location replacementString:string];
    }
    return NO;
}

- (BOOL)shouldChangeCharactersForForMaxInputNumberLimitInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL res = YES;

    if (![string isEqualToString:@""]) {  // 输入
        // 判断是否超出最大数
        if (self.config.maxInputNumber > 0.f) {

            NSString *willSetString = self.textField.text;
            NSMutableString *mutableWillSetString = [NSMutableString stringWithString:willSetString];
            [mutableWillSetString insertString:string atIndex:range.location];
            willSetString = mutableWillSetString;

            if (self.config.shouldSeparatedTextWithSymbol) {
                willSetString = [willSetString stringByReplacingOccurrencesOfString:self.config.separatedSymbol withString:@""];
            }
            double willSetStringValue = [willSetString doubleValue];

            if (willSetStringValue > self.config.maxInputNumber) {
                res = NO;
                // 如果超过了最大数则来判断是否需要修改
                if (self.config.allowModifyInputToMaxInputNumber) {
                    NSString *maxInputNumberStr = [self getMaxInputNumberStrForString:willSetString];
                    [self setText:maxInputNumberStr lastEditLocation:range.location replacementString:string];
                }
            }
        }
    } else {
        // 删除动作
        NSString *deleteString = [self.textField.text substringWithRange:range];
        if ([deleteString isEqualToString:@"."]) {
            if ([[self.textField.text stringByReplacingOccurrencesOfString:deleteString withString:@""] doubleValue] > self.config.maxInputNumber) {
                // 获取原来的整数字符串
                NSString *intergerStr = [self.textField.text componentsSeparatedByString:deleteString][0];

                // 删除小数点后的值大于最大数，去掉去小数点之前小数点后面的小数
                [self setText:intergerStr lastEditLocation:intergerStr.length replacementString:@""];
                res = NO;
            }
        }
    }

    return res;
}

- (void)setText:(NSString *)text lastEditLocation:(NSUInteger)location replacementString:(NSString *)string {

    // 先判断是否正在编辑，因为有可能是直接代码模拟触发的 shouldChange 方法，这种情况直接设置，不用处理光标
    if (!self.textField.isEditing) {
        self.textField.text = text;
        return;
    }

    NSRange selectedRange = [self.textField selectedRange];

    // 判断光标是否在尾部
    if (selectedRange.location == self.textField.text.length) {  // 光标在尾部
        self.textField.text = text;
        // 移动光标到尾部
        NSRange fixedRange = NSMakeRange(text.length, 0);
        [self.textField setSelectedRange:fixedRange];
    } else {                                              // 光标不在尾部
        if (self.config.shouldSeparatedTextWithSymbol) {  // 开启了分割
            if (![string isEqualToString:@""]) {          // 插入
                BOOL hasTextChanged = ![self.textField.text isEqualToString:text];
                self.textField.text = text;
                if (hasTextChanged) {
                    // 判断插入的为止是不是刚好在分隔符前面，如果是，就要后移一个分隔符的长度
                    NSString *stringAfterLocationLengthEqualToSymbol = [text substringWithRange:NSMakeRange(location, self.config.separatedSymbol.length)];

                    NSUInteger fixLocation = location + string.length;
                    if ([stringAfterLocationLengthEqualToSymbol isEqualToString:self.config.separatedSymbol]) {
                        fixLocation = fixLocation + self.config.separatedSymbol.length;
                    }
                    // 移动光标到插入后的字符后
                    NSRange fixedRange = NSMakeRange(fixLocation, 0);
                    [self.textField setSelectedRange:fixedRange];
                }
            } else {
                self.textField.text = text;
                // 移动光标到删除后的字符位置
                NSRange fixedRange = NSMakeRange(location, 0);
                [self.textField setSelectedRange:fixedRange];
            }
        } else {
            BOOL hasTextChanged = ![self.textField.text isEqualToString:text];

            self.textField.text = text;

            if (![string isEqualToString:@""]) {  // 插入
                // 如果新值旧值不一样才移动光标
                if (hasTextChanged) {
                    NSRange fixedRange = NSMakeRange(location + string.length, 0);
                    [self.textField setSelectedRange:fixedRange];
                }
            }
        }
    }
}

- (void)setCustomRightView:(UIView *)rightView {

    [self addSubview:rightView];
    _customRightView = rightView;

    [self activeDefaultTextFieldConstraint];
}

- (void)setRightImageViewImage:(UIImage *)image {
    if (_rightImageView) {
        _rightImageView.image = image;
    }
}

- (void)setFloatingLabelAttrText:(id)attrText {
    if (_floatingLabel) {

        if ([attrText isKindOfClass:NSString.class]) {
            _floatingLabel.text = attrText;
        } else if ([attrText isKindOfClass:NSAttributedString.class]) {
            _floatingLabel.attributedText = attrText;
        }
    }
}

- (void)updateConfigWithDict:(NSDictionary<NSString *, id> *)dict {
    for (id key in dict.allKeys) {
        id value = [dict valueForKey:key];
        // 判断是否响应 get 方法
        if (self.config && [self.config respondsToSelector:NSSelectorFromString([NSString stringWithFormat:@"%@", key])]) {
            [self.config setValue:value forKey:key];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (self.delegate && [self.delegate respondsToSelector:@selector(floatingAnimatedTextFieldShouldBeginEditing:)]) {
        return [self.delegate floatingAnimatedTextFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self enterTextFieldFocusCompletion:nil];

    if (self.config.hideRightViewWhenEditing) {
        if (textField.text.length) {
            [self hideRightView];
        }
    }

    NSString *text = self.textField.text;
    // 前提是输入集不为空并且当前有输入
    if (text.length > 0 && self.config.characterSetString && self.config.characterSetString.length > 0) {
        // 如果需要允许输入集必须包含小数点才补齐请解开注释
        NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:self.config.characterSetString];
        // 开始编辑后判断是否要自动去除小数位
        if (self.config.shouldRemoveDecimalAfterBeginEditing || [@"." rangeOfCharacterFromSet:tmpSet].location == NSNotFound) {
            // 去除小数点
            if ([text containsString:@"."]) {
                NSArray *textSplitArr = [text componentsSeparatedByString:@"."];
                if (textSplitArr.count >= 2) {
                    NSString *stringLeftAtDecimalPoint = textSplitArr[0];
                    self.textField.text = stringLeftAtDecimalPoint;
                }
            }
        }
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(floatingAnimatedTextFieldDidBeginEditing:)]) {
        [self.delegate floatingAnimatedTextFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(floatingAnimatedTextFieldShouldEndEditing:)]) {
        return [self.delegate floatingAnimatedTextFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self dealingWithTextFieldDidEndEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) {
    [self dealingWithTextFieldDidEndEditing:textField];
}

- (void)dealingWithTextFieldDidEndEditing:(UITextField *)textField {
    [self exitTextFieldFocus];

    if (self.config.hideRightViewWhenEditing) {
        if (textField.text.length) {
            [self showRightView];
        }
    }

    if (!self.config.shouldSeparatedTextWithSymbol) {
        NSString *text = self.textField.text;
        // 结束编辑后判断是否要自动补齐小数位，前提是输入集不为空并且当前有输入
        if (text.length > 0 && self.config.characterSetString && self.config.characterSetString.length > 0) {
            // 如果需要允许输入集必须包含小数点才补齐请解开注释
            // NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:self.config.characterSetString];
            // if ([@"." rangeOfCharacterFromSet:tmpSet].location != NSNotFound) {
            NSString *decimalString = @"";
            NSInteger zeroCount = 0;
            NSString *stringLeftAtDecimalPoint = @"";
            // 判断小数点位数，把当前输入以小数点分隔
            if ([text containsString:@"."]) {
                NSArray<NSString *> *textSplitArr = [text componentsSeparatedByString:@"."];
                if (textSplitArr.count >= 2) {
                    stringLeftAtDecimalPoint = textSplitArr[0];
                    // 如果小数点左边没数字，则自动补0
                    stringLeftAtDecimalPoint = stringLeftAtDecimalPoint.length <= 0 ? @"0" : stringLeftAtDecimalPoint;
                    decimalString = textSplitArr[1];
                }
            } else {
                stringLeftAtDecimalPoint = text;
            }

            if (self.config.shouldAppendDecimalAfterEndEditing) {  // 需要补齐
                // 判断小数点位数，把当前输入以小数点分隔
                if ([text containsString:@"."]) {
                    if (decimalString.length < self.config.maxDecimalsCount) {
                        zeroCount = self.config.maxDecimalsCount - decimalString.length;
                    }
                } else {
                    stringLeftAtDecimalPoint = text;
                    zeroCount = self.config.maxDecimalsCount;
                }
                // 补齐
                for (short i = 0; i < zeroCount; i++) {
                    decimalString = [decimalString stringByAppendingString:@"0"];
                }
                self.textField.text = [NSString stringWithFormat:@"%@.%@", stringLeftAtDecimalPoint, decimalString];
            } else {
                if (decimalString.length <= 0) {
                    // 不需要拼接，最后一位又是小数点，则去掉
                    self.textField.text = stringLeftAtDecimalPoint;
                }
            }
        }
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(floatingAnimatedTextFieldDidEndEditing:)]) {
        [self.delegate floatingAnimatedTextFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    // 处理右边 view 隐藏与否
    if (self.config.hideRightViewWhenEditing) {
        if (range.location == 0 && [string isEqualToString:@""] && textField.text.length <= 1) {
            [self showRightView];
        } else {
            [self hideRightView];
        }
    }

    // 如果代理实现了该方法，全由代理决定
    if (self.delegate && [self.delegate respondsToSelector:@selector(floatingAnimatedTextField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate floatingAnimatedTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }

    BOOL res = YES;

    // 获取要删除的字符
    NSString *deleteString = [textField.text substringWithRange:range];
    if (![string isEqualToString:@""]) {  // 输入
        res = [self shouldChangeCharactersForCharacterSetInRange:range replacementString:string];
        if (res) {  // 输入字符集合法，判断长度
            res = [self shouldChangeCharactersForInputLengthMaxInRange:range replacementString:string];
            if (res) {  // 长度合法，判断小数点相关
                res = [self shouldChangeCharactersForDecimalPointLimitInRange:range replacementString:string];
                if (res) {  // 小数点相关合法，判断原字符有没有被大小限制改变
                    res = [self shouldChangeCharactersForForMaxInputNumberLimitInRange:range replacementString:string];
                    if (res) {  // 大小合法
                        NSString *willSetString = textField.text;
                        NSMutableString *mutableWillSetString = [NSMutableString stringWithString:willSetString];

                        [mutableWillSetString insertString:string atIndex:range.location];
                        willSetString = mutableWillSetString;

                        if (self.config.shouldSeparatedTextWithSymbol) {  // 需要分隔才进入
                            res = [self shouldChangeCharactersForSeparationWithWillSetString:willSetString lastEditLocation:range.location replacementString:string];
                        } else {
                            res = YES;
                        }
                    }
                } else {  // 小数点相关不合法
                    [self setProceduralChangedTextFieldText];
                }
            } else {  // 长度不合法
                [self setProceduralChangedTextFieldText];
            }
        } else {  // 输入字符集不合法
            [self setProceduralChangedTextFieldText];
        }
    } else {  // 删除
        // 删除的话如果是删小数点，要判断删除后的值有没有超过最大数
        if ([deleteString isEqualToString:@"."]) {
            res = [self shouldChangeCharactersForForMaxInputNumberLimitInRange:range replacementString:string];
        } else {
            if (self.config.shouldSeparatedTextWithSymbol) {  // 开启分割才处理
                NSRange selectedRange = [self.textField selectedRange];
                // 判断光标是否在尾部
                if (selectedRange.location == textField.text.length) {  // 光标在尾部
                    // 删除动作，如果最后一位是分隔符就去除
                    NSInteger location = textField.text.length - self.config.separatedSymbol.length - deleteString.length;
                    if (location >= 0) {
                        NSString *lastStringAfterDelete = [textField.text substringWithRange:NSMakeRange(location, self.config.separatedSymbol.length)];

                        if ([lastStringAfterDelete isEqualToString:self.config.separatedSymbol]) {
                            res = [self shouldChangeCharactersForSeparationWithWillSetString:[textField.text substringToIndex:location] lastEditLocation:range.location replacementString:string];
                        }
                    }
                } else {  // 光标不在尾部
                    NSInteger location = range.location - self.config.separatedSymbol.length;
                    if (location >= 0) {
                        NSString *willDeleteStringLengthEqualToSymbol = [textField.text substringWithRange:NSMakeRange(location + deleteString.length, self.config.separatedSymbol.length)];
                        if ([willDeleteStringLengthEqualToSymbol isEqualToString:self.config.separatedSymbol]) {  // 用户点击光标去了分隔符右边，主动删除分隔符
                            // 获取光标前后字符
                            NSString *stringBeforeCursor = [textField.text substringToIndex:location];
                            NSString *stringAfterCursor = [textField.text substringFromIndex:range.location + deleteString.length];
                            res = [self shouldChangeCharactersForSeparationWithWillSetString:[stringBeforeCursor stringByAppendingString:stringAfterCursor] lastEditLocation:location replacementString:string];
                        } else {
                            NSMutableString *mutableStr = [NSMutableString stringWithString:textField.text];
                            [mutableStr deleteCharactersInRange:NSMakeRange(range.location, deleteString.length)];

                            res = [self shouldChangeCharactersForSeparationWithWillSetString:mutableStr lastEditLocation:range.location replacementString:string];
                        }
                    } else {
                        // 删除了第一个字符
                        NSMutableString *mutableStr = [NSMutableString stringWithString:textField.text];
                        [mutableStr deleteCharactersInRange:NSMakeRange(range.location, deleteString.length)];

                        res = [self shouldChangeCharactersForSeparationWithWillSetString:mutableStr lastEditLocation:range.location replacementString:string];
                    }
                }
            }
        }
    }
    return res;
}

- (NSString *)getMaxInputNumberStrForString:(NSString *)willSetString {

    // 首先判断有没有超过最大数，没有的话返回原字符串
    if (willSetString.doubleValue <= self.config.maxInputNumber) return willSetString;

    // 来到这里说明已经超过了
    // 先判断要输入的数本身的小数位，本身输了几位最大就补齐到几位
    NSInteger inputDecimalPointCount = 0;
    NSInteger inputIntergerLength = willSetString.length;
    if ([willSetString containsString:@"."]) {
        NSArray<NSString *> *textSplitArr = [willSetString componentsSeparatedByString:@"."];
        if (textSplitArr.count >= 2) {
            inputIntergerLength = textSplitArr[0].length;
            inputDecimalPointCount = textSplitArr[1].length;
        }
    }

    // 防止 stringWithFormat 在取小数位数转 string 时四舍五入
    NSString *out = @"";

    if (inputDecimalPointCount > 0) {
        out = [[NSString stringWithFormat:@"%f", self.config.maxInputNumber] substringToIndex:inputIntergerLength + inputDecimalPointCount];
    } else {
        // - 1 是本身没有小数点就去掉
        out = [[NSString stringWithFormat:@"%f", self.config.maxInputNumber] substringToIndex:inputIntergerLength - 1];
    }

    return out;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    BOOL shouldClear = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(floatingAnimatedTextFieldShouldClear:)]) {
        shouldClear = [self.delegate floatingAnimatedTextFieldShouldClear:textField];
    }
    if (shouldClear) {
        if (self.config.hideRightViewWhenEditing) {
            if (textField.text.length) {
                [self showRightView];
            }
        }
    }
    return shouldClear;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(floatingAnimatedTextFieldShouldReturn:)]) {
        return [self.delegate floatingAnimatedTextFieldShouldReturn:textField];
    }
    return YES;
}

#pragma mark - getters and setters
- (void)setConfig:(WJFloatingAnimatedTextFieldConfig *)config {
    if ([_config isEqual:config]) return;

    BOOL needUpdateConstraints =
        ![_config.leftIconImage isEqual:config.leftIconImage] ||
        ![_config.rightIconImage isEqual:config.rightIconImage] ||
        ![_config.placeholder isEqualToString:config.placeholder] ||
        ![_config.floatingText isEqualToString:config.floatingText] ||
        ![_config.leftLabelString isEqualToString:config.leftLabelString] ||
        ![_config.rightLabelString isEqualToString:config.placeholder] ||
        ![_config.placeholder isEqualToString:config.rightLabelString] ||
        ![_config.attributedPlaceholder isEqual:config.attributedPlaceholder] ||
        ![_config.leftLabelFont isEqual:config.leftLabelFont] ||
        ![_config.rightLabelFont isEqual:config.rightLabelFont] ||
        ![_config.font isEqual:config.font] ||
        ![_config.placeholderFont isEqual:config.placeholderFont] ||
        ![_config.floatingLabelFont isEqual:config.floatingLabelFont] ||
        !UIEdgeInsetsEqualToEdgeInsets(_config.leftViewEdgeInsets, config.leftViewEdgeInsets) ||
        !UIEdgeInsetsEqualToEdgeInsets(_config.rightViewEdgeInsets, config.rightViewEdgeInsets) ||
        !UIEdgeInsetsEqualToEdgeInsets(_config.placeholderEdgeInsets, config.placeholderEdgeInsets) ||
        _config.bottomLineNormalHeight != config.bottomLineNormalHeight ||
        _config.bottomLineSelectedHeight != config.bottomLineSelectedHeight ||
        _config.textFieldHeightRateExceptMargin != config.textFieldHeightRateExceptMargin;

    BOOL needUpdateValue = needUpdateConstraints ||
        ![_config.placeholderColor isEqual:config.placeholderColor] ||
        ![_config.floatingLabelColor isEqual:config.floatingLabelColor] ||
        ![_config.bottomLineNormalColor isEqual:config.bottomLineNormalColor] ||
        ![_config.bottomLineSelectedColor isEqual:config.bottomLineSelectedColor] ||
        ![_config.leftLabelColor isEqual:config.leftLabelColor] ||
        ![_config.rightLabelColor isEqual:config.rightLabelColor];

    _config = config;

    if (needUpdateValue) {
        [self commonInit];
    }
    if (needUpdateConstraints) {
        // 需要更新约束
        [self activeOrUpdateConstraints];
    }
}

- (WJFloatingAnimatedTextFieldConfig *)getCurrentConfig {
    return _config;
}
@end
