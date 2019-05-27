//
//  FBKVOController+Extension.m
//  WJFloatingAnimatedTextField
//
//  Created by VanJay on 2019/4/29.
//  Copyright © 2019 VanJay. All rights reserved.
//

#import "FBKVOController+Extension.h"

@implementation FBKVOController (Extension)
- (void)hd_observe:(id)object keyPath:(NSString *)keyPath block:(FBKVONotificationBlock)block {
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew block:block];
}

- (void)hd_observe:(id)object keyPath:(NSString *)keyPath action:(SEL)action {
    [self observe:object keyPath:keyPath options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew action:action];
}
@end
