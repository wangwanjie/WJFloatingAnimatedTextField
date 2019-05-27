//
//  ViewController.m
//  WJFloatingAnimatedTextField
//
//  Created by VanJay on 2019/5/27.
//  Copyright © 2019 VanJay. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Size.h"
#import "UIViewController+YJKeyBoard.h"
#import "WJDefine.h"
#import "WJFloatingAnimatedTextField.h"
#import "WJFrameLayout.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;     ///< 容器
@property (nonatomic, strong) UIView *passwordTFRightView;  ///< 密码输入框右视图容器
@property (nonatomic, strong) WJFloatingAnimatedTextField *passwordTF;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self yj_addKeyBoardHandle];

    self.title = @"输入框";
    self.view.backgroundColor = UIColor.whiteColor;

    [self setUpForTestingTextfield];
}

- (void)setUpForTestingTextfield {

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScrollView)]];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    _scrollView.frame = self.view.bounds;

    [self.scrollView addSubview:self.passwordTF];
    [self.passwordTF setCustomRightView:self.passwordTFRightView];

    WJFloatingAnimatedTextField *textField = [[WJFloatingAnimatedTextField alloc] initWithPlaceholder:@"输入手机号码" leftLabelString:@"+855"];
    WJFloatingAnimatedTextFieldConfig *config = [textField getCurrentConfig];
    config.font = [UIFont systemFontOfSize:23.0f weight:UIFontWeightBold];
    config.leftLabelFont = [UIFont systemFontOfSize:23.0f weight:UIFontWeightBold];
    config.leftLabelColor = HexColor(0x343b4d);
    config.shouldSeparatedTextWithSymbol = YES;
    config.separatedFormat = @"xx-xxx-xxxx";
    config.hideLeftViewWhenEmptyInputUnFoucused = YES;
    config.characterSetString = kCharacterSetStringNumber;
    config.maxInputLength = 9;
    [textField setConfig:config];
    [_scrollView addSubview:textField];

    WJFloatingAnimatedTextField *textField222 = [[WJFloatingAnimatedTextField alloc] initWithPlaceholder:@"输入手机号码" leftLabelString:@"+855"];
    WJFloatingAnimatedTextFieldConfig *config2222 = [textField222 getCurrentConfig];
    config2222.font = [UIFont systemFontOfSize:23.0f weight:UIFontWeightBold];
    config2222.leftLabelFont = [UIFont systemFontOfSize:23.0f weight:UIFontWeightBold];
    config2222.floatingText = @"不动的标题";
    config2222.leftLabelColor = HexColor(0x343b4d);
    config2222.shouldSeparatedTextWithSymbol = YES;
    config2222.separatedFormat = @"xx-xxx-xxxx";
    config2222.hideLeftViewWhenEmptyInputUnFoucused = YES;
    config2222.characterSetString = kCharacterSetStringNumber;
    config2222.maxInputLength = 9;
    [textField222 setConfig:config2222];
    [_scrollView addSubview:textField222];

    WJFloatingAnimatedTextField *textField11 = [[WJFloatingAnimatedTextField alloc] initWithPlaceholder:@"请输入密码，最长16位" rightLabelString:@"忘记了？"];
    WJFloatingAnimatedTextFieldConfig *config111 = [textField11 getCurrentConfig];
    config111.rightLabelColor = UIColor.redColor;
    config111.secureTextEntry = YES;
    config111.maxInputLength = 16;
    config111.keyboardType = UIKeyboardTypeDefault;
    [textField11 setConfig:config111];
    [_scrollView addSubview:textField11];

    WJFloatingAnimatedTextField *textField0 = [[WJFloatingAnimatedTextField alloc] initWithPlaceholder:@"输入国内手机号码" leftLabelString:@"+86"];
    WJFloatingAnimatedTextFieldConfig *config0 = [textField0 getCurrentConfig];
    config0.font = [UIFont systemFontOfSize:23.0f weight:UIFontWeightBold];
    config0.leftLabelFont = [UIFont systemFontOfSize:23.0f weight:UIFontWeightBold];
    config0.leftLabelColor = HexColor(0x343b4d);
    config0.shouldSeparatedTextWithSymbol = YES;
    config0.separatedFormat = @"xxx-xxxx-xxxx";
    config0.characterSetString = kCharacterSetStringNumber;
    config0.maxInputLength = 11;
    [textField0 setConfig:config0];
    [_scrollView addSubview:textField0];

    WJFloatingAnimatedTextField *textField2 = [[WJFloatingAnimatedTextField alloc] initWithPlaceholder:@"输入合同号" rightIconImage:[UIImage imageNamed:@"recharge_password_scan"]];
    WJFloatingAnimatedTextFieldConfig *config22 = [textField2 getCurrentConfig];
    config22.hideRightViewWhenEditing = YES;
    config22.characterSetString = kCharacterSetStringNumber;
    config22.font = [UIFont systemFontOfSize:23.0f weight:UIFontWeightBold];
    config22.needShowOrHideRightViewAnimation = YES;
    config22.maxInputLength = 8;
    config22.floatingText = @"合同号（固定标题，最长8位）";
    [textField2 setConfig:config22];
    [_scrollView addSubview:textField2];

    WJFloatingAnimatedTextField *textField3 = [[WJFloatingAnimatedTextField alloc] initWithPlaceholder:@"输入一个小数" rightLabelString:@"小数"];
    WJFloatingAnimatedTextFieldConfig *config2 = [textField3 getCurrentConfig];
    config2.hideRightViewWhenEditing = YES;
    config2.needShowOrHideRightViewAnimation = YES;
    config2.maxDecimalsCount = 2;
    config2.maxInputNumber = 888888.88;
    config2.characterSetString = @"0123456789.";
    config2.maxInputLength = 9;
    config2.floatingText = @"最大888888.88，小数位两位";
    config2.keyboardType = UIKeyboardTypeDecimalPad;
    [textField3 setConfig:config2];
    [_scrollView addSubview:textField3];

    WJFloatingAnimatedTextField *textField33 = [[WJFloatingAnimatedTextField alloc] initWithPlaceholder:@"输入一个小数" rightLabelString:@"小数"];
    WJFloatingAnimatedTextFieldConfig *config33 = [textField33 getCurrentConfig];
    config33.hideRightViewWhenEditing = YES;
    config33.needShowOrHideRightViewAnimation = YES;
    config33.maxDecimalsCount = 2;
    config33.maxInputNumber = 888888.88;
    config33.characterSetString = @"0123456789.";
    config33.maxInputLength = 9;
    config33.floatingText = @"最大888888.88，小数位两位，强制修改为最大";
    config33.allowModifyInputToMaxInputNumber = YES;
    config33.keyboardType = UIKeyboardTypeDecimalPad;
    [textField33 setConfig:config33];
    [_scrollView addSubview:textField33];

    WJFloatingAnimatedTextField *textField4 = [[WJFloatingAnimatedTextField alloc] initWithPlaceholder:@"只能输入我爱你" leftLabelString:@"宣言"];
    WJFloatingAnimatedTextFieldConfig *config4 = [WJFloatingAnimatedTextFieldConfig defaultConfig];
    config4.rightLabelString = @"设置内边距";
    config4.characterSetString = @"我爱你";
    config4.textColor = UIColor.redColor;
    config4.keyboardType = UIKeyboardTypeDefault;
    config4.rightViewEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 50);
    [textField4 setConfig:config4];
    [_scrollView addSubview:textField4];

    WJFloatingAnimatedTextField *textField5 = [[WJFloatingAnimatedTextField alloc] initWithPlaceholder:@"这样也能限制长度" leftIconImage:[UIImage imageNamed:@"recharge_password_scan"]];
    WJFloatingAnimatedTextFieldConfig *config5 = [textField5 getCurrentConfig];
    config5.floatingText = @"自定分隔符，可多位，a-bb-ccc-dddd-eeeee，最多15位";
    config5.rightIconImage = [UIImage imageNamed:@"recharge_password_scan"];
    config5.shouldSeparatedTextWithSymbol = YES;
    config5.separatedSymbol = @"-";
    config5.separatedFormat = @"x-xx-xxx-xxxx-xxxxx";
    config5.characterSetString = kCharacterSetStringNumber;
    config5.maxInputLength = 15;
    [textField5 setConfig:config5];
    [_scrollView addSubview:textField5];

    CGFloat margin = kRealWidth(50), width = kScreenWidth - margin;

    UIView *refView;
    for (UIView *view in _scrollView.subviews) {
        [view wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
            if (!refView) {
                make.top.equalToValue(20);
            } else {
                make.top.wj_equalTo(refView.bottom).offset(30);
            }
            make.height.equalTo(@50);
            make.width.equalToValue(width);
            make.centerX.wj_equalTo(self.view.width * 0.5);
        }];
        refView = view;
    }

    UIView *lastView = _scrollView.subviews.lastObject;
    _scrollView.contentSize = CGSizeMake(self.view.width, lastView.bottom + margin);
}

#pragma mark - event response
- (void)tappedScrollView {
    [self.view endEditing:YES];
}

- (void)clickedPasswordShowBtn:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    self.passwordTF.inputTextField.secureTextEntry = !btn.isSelected;
}

- (void)clickedForgotPassword {
    [self.view endEditing:YES];

    NSLog(@"忘记密码");
}

#pragma mark - lazy load
- (WJFloatingAnimatedTextField *)passwordTF {
    if (!_passwordTF) {

        _passwordTF = [[WJFloatingAnimatedTextField alloc] initWithPlaceholder:@"请输入密码，自定义 rightView" rightLabelString:nil];
        WJFloatingAnimatedTextFieldConfig *config = [_passwordTF getCurrentConfig];
        config.font = [UIFont systemFontOfSize:17.0f weight:UIFontWeightRegular];
        config.textColor = HexColor(0x343b4d);
        config.maxInputLength = 16;
        config.secureTextEntry = YES;
        config.characterSetString = kCharacterSetStringNumberAndLetter;
        config.rightLabelFont = [UIFont systemFontOfSize:15.0f weight:UIFontWeightRegular];
        config.rightLabelColor = HexColor(0xf83460);
        config.keyboardType = UIKeyboardTypeDefault;
        [_passwordTF setConfig:config];

        // __weak __typeof(self) weakSelf = self;
        _passwordTF.textFieldDidChangeBlock = ^(NSString *text) {
            //  __strong __typeof(weakSelf) strongSelf = weakSelf;
            NSLog(@"输入内容改变");
        };
    }
    return _passwordTF;
}

- (UIView *)passwordTFRightView {
    if (!_passwordTFRightView) {
        _passwordTFRightView = [[UIView alloc] init];

        UIFont *font = [UIFont systemFontOfSize:15.0f weight:UIFontWeightRegular];
        NSString *text = @"忘记了？";
        CGFloat marginEyeIconToSepLine = kRealWidth(10), marginStplineToForgotBtn = kRealWidth(10);
        UIImage *image = [UIImage imageNamed:@"password_hide"];
        CGSize size = [text boundingALLRectWithSize:CGSizeMake(MAXFLOAT, 10) font:font];

        CGFloat lineWidth = 1.f, rightViewHeight = MAX(image.size.height, size.height), rightViewWidth = image.size.width + lineWidth + size.width + marginEyeIconToSepLine + marginStplineToForgotBtn;

        _passwordTFRightView.frame = CGRectMake(0, 0, rightViewWidth, rightViewHeight);

        UIButton *passwordShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        [passwordShowBtn setImage:image forState:UIControlStateNormal];
        [passwordShowBtn setImage:[UIImage imageNamed:@"password_show"] forState:UIControlStateSelected];
        [passwordShowBtn addTarget:self action:@selector(clickedPasswordShowBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_passwordTFRightView addSubview:passwordShowBtn];
        [passwordShowBtn wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
            make.size.wj_equalTo(image.size);
            make.left.wj_equalTo(0);
            make.centerY.wj_equalTo(rightViewHeight * 0.5);
        }];

        UIView *separatedLine = [[UIView alloc] init];
        separatedLine.backgroundColor = HexColor(0xadb6c8);
        [_passwordTFRightView addSubview:separatedLine];

        [separatedLine wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
            make.left.wj_equalTo(passwordShowBtn.right).offset(marginEyeIconToSepLine);
            make.size.wj_equalTo(CGSizeMake(lineWidth, rightViewHeight));
            make.centerY.wj_equalTo(rightViewHeight * 0.5);
        }];

        UILabel *forgetPwdLB = [[UILabel alloc] init];
        forgetPwdLB.textColor = HexColor(0xf83460);
        forgetPwdLB.font = font;
        forgetPwdLB.text = text;
        forgetPwdLB.userInteractionEnabled = YES;
        UITapGestureRecognizer *recngnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedForgotPassword)];
        [forgetPwdLB addGestureRecognizer:recngnizer];
        [_passwordTFRightView addSubview:forgetPwdLB];

        [forgetPwdLB wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
            make.left.wj_equalTo(separatedLine.right).offset(marginStplineToForgotBtn);
            make.size.wj_equalTo(size);
            make.centerY.wj_equalTo(rightViewHeight * 0.5);
        }];
    }
    return _passwordTFRightView;
}
@end
