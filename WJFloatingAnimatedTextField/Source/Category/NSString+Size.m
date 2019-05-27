//
//  NSString+Size.m
//  WJKeyBoard
//
//  Created by VanJay on 2017/7/15.
//  Copyright © 2017年 VanJay. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)boundingALLRectWithSize:(CGSize)size font:(UIFont *)font {
    //    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:2.0f];
    //    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [self length])];

    CGSize realSize = CGSizeZero;

    CGRect textRect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName: font,
                                                   NSParagraphStyleAttributeName: style}
                                         context:nil];
    realSize = textRect.size;

    realSize.width = ceilf(realSize.width);
    realSize.height = ceilf(realSize.height);
    return realSize;
}

@end
