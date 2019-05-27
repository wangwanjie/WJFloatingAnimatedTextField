//
//  NSString+Size.h
//  WJKeyBoard
//
//  Created by VanJay on 2017/7/15.
//  Copyright © 2017年 VanJay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Size)

- (CGSize)boundingALLRectWithSize:(CGSize)size font:(UIFont *)font;

@end
