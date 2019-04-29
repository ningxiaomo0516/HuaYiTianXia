//
//  UIDevice+Extension.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/27.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/utsname.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Extension)
/// 1.手机系统版本：9.1
+ (NSString *)phoneVersion;
/// 2.手机系统：iPhone OS
+ (NSString *)systemName;
/// 3.获取当前手机型号iPhone X
+ (NSString *)getCurrentDeviceModel;
@end

NS_ASSUME_NONNULL_END
