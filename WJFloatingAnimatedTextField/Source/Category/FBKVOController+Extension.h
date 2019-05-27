//
//  FBKVOController+Extension.h
//  WJFloatingAnimatedTextField
//
//  Created by VanJay on 2019/4/29.
//  Copyright © 2019 VanJay. All rights reserved.
//

#import <KVOController/KVOController.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBKVOController (Extension)
- (void)hd_observe:(nullable id)object keyPath:(NSString *_Nullable)keyPath block:(FBKVONotificationBlock _Nullable)block;

- (void)hd_observe:(nullable id)object keyPath:(NSString *_Nullable)keyPath action:(SEL _Nullable)action;
@end

NS_ASSUME_NONNULL_END
