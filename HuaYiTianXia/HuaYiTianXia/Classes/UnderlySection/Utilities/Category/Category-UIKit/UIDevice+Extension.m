//
//  UIDevice+Extension.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/27.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "UIDevice+Extension.h"

@implementation UIDevice (Extension)

/// 1.手机系统版本：9.1
+ (NSString *)phoneVersion{
    return [[UIDevice currentDevice] systemVersion];
}
/// 手机系统：iPhone OS
+ (NSString *)systemName{
    return [[UIDevice currentDevice] systemName];
}

+ (NSString *)getCurrentDeviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *phoneModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([phoneModel isEqualToString:@"iPhone1,1"])    return @"Apple#iPhone 1G";
    if ([phoneModel isEqualToString:@"iPhone1,2"])    return @"Apple#iPhone 3G";
    if ([phoneModel isEqualToString:@"iPhone2,1"])    return @"Apple#iPhone 3GS";
    if ([phoneModel isEqualToString:@"iPhone3,1"])    return @"Apple#iPhone 4";
    if ([phoneModel isEqualToString:@"iPhone3,2"])    return @"Apple#iPhone 4 Verizon";
    if ([phoneModel isEqualToString:@"iPhone4,1"])    return @"Apple#iPhone 4S";
    if ([phoneModel isEqualToString:@"iPhone5,2"])    return @"Apple#iPhone 5";
    if ([phoneModel isEqualToString:@"iPhone5,3"])    return @"Apple#iPhone 5c";
    if ([phoneModel isEqualToString:@"iPhone5,4"])    return @"Apple#iPhone 5c";
    if ([phoneModel isEqualToString:@"iPhone6,1"])    return @"Apple#iPhone 5s";
    if ([phoneModel isEqualToString:@"iPhone6,2"])    return @"Apple#iPhone 5s";
    if ([phoneModel isEqualToString:@"iPhone7,1"])    return @"Apple#iPhone 6 Plus";
    if ([phoneModel isEqualToString:@"iPhone7,2"])    return @"Apple#iPhone 6";
    if ([phoneModel isEqualToString:@"iPhone8,1"])    return @"Apple#iPhone 6s";
    if ([phoneModel isEqualToString:@"iPhone8,2"])    return @"Apple#iPhone 6s Plus";
    if ([phoneModel isEqualToString:@"iPhone8,4"])    return @"Apple#iPhone SE";
    if ([phoneModel isEqualToString:@"iPhone9,1"])    return @"Apple#iPhone 7";
    if ([phoneModel isEqualToString:@"iPhone9,2"])    return @"Apple#iPhone 7 Plus";
    if ([phoneModel isEqualToString:@"iPhone9,3"])    return @"Apple#iPhone 7";
    if ([phoneModel isEqualToString:@"iPhone9,4"])    return @"Apple#iPhone 7 Plus";
    if ([phoneModel isEqualToString:@"iPhone10,1"])   return @"Apple#iPhone 8 Global";
    if ([phoneModel isEqualToString:@"iPhone10,2"])   return @"Apple#iPhone 8 Plus Global";
    if ([phoneModel isEqualToString:@"iPhone10,3"])   return @"Apple#iPhone X Global";
    if ([phoneModel isEqualToString:@"iPhone10,4"])   return @"Apple#iPhone 8 GSM";
    if ([phoneModel isEqualToString:@"iPhone10,5"])   return @"Apple#iPhone 8 Plus GSM";
    if ([phoneModel isEqualToString:@"iPhone10,6"])   return @"Apple#iPhone X GSM";

    if ([phoneModel isEqualToString:@"iPhone11,2"])   return @"Apple#iPhone XS";
    if ([phoneModel isEqualToString:@"iPhone11,4"])   return @"Apple#iPhone XS Max (China)";
    if ([phoneModel isEqualToString:@"iPhone11,6"])   return @"Apple#iPhone XS Max";
    if ([phoneModel isEqualToString:@"iPhone11,8"])   return @"Apple#iPhone XR";

    if ([phoneModel isEqualToString:@"i386"])         return @"Apple#Simulator 32";
    if ([phoneModel isEqualToString:@"x86_64"])       return @"Apple#Simulator 64";

    if ([phoneModel isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([phoneModel isEqualToString:@"iPad2,1"] ||
        [phoneModel isEqualToString:@"iPad2,2"] ||
        [phoneModel isEqualToString:@"iPad2,3"] ||
        [phoneModel isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([phoneModel isEqualToString:@"iPad3,1"] ||
        [phoneModel isEqualToString:@"iPad3,2"] ||
        [phoneModel isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([phoneModel isEqualToString:@"iPad3,4"] ||
        [phoneModel isEqualToString:@"iPad3,5"] ||
        [phoneModel isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([phoneModel isEqualToString:@"iPad4,1"] ||
        [phoneModel isEqualToString:@"iPad4,2"] ||
        [phoneModel isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([phoneModel isEqualToString:@"iPad5,3"] ||
        [phoneModel isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([phoneModel isEqualToString:@"iPad6,3"] ||
        [phoneModel isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7-inch";
    if ([phoneModel isEqualToString:@"iPad6,7"] ||
        [phoneModel isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9-inch";
    if ([phoneModel isEqualToString:@"iPad6,11"] ||
        [phoneModel isEqualToString:@"iPad6,12"]) return @"iPad 5";
    if ([phoneModel isEqualToString:@"iPad7,1"] ||
        [phoneModel isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
    if ([phoneModel isEqualToString:@"iPad7,3"] ||
        [phoneModel isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";

    if ([phoneModel isEqualToString:@"iPad2,5"] ||
        [phoneModel isEqualToString:@"iPad2,6"] ||
        [phoneModel isEqualToString:@"iPad2,7"]) return @"iPad mini";
    if ([phoneModel isEqualToString:@"iPad4,4"] ||
        [phoneModel isEqualToString:@"iPad4,5"] ||
        [phoneModel isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    if ([phoneModel isEqualToString:@"iPad4,7"] ||
        [phoneModel isEqualToString:@"iPad4,8"] ||
        [phoneModel isEqualToString:@"iPad4,9"]) return @"iPad mini 3";
    if ([phoneModel isEqualToString:@"iPad5,1"] ||
        [phoneModel isEqualToString:@"iPad5,2"]) return @"iPad mini 4";

    if ([phoneModel isEqualToString:@"iPod1,1"]) return @"iTouch";
    if ([phoneModel isEqualToString:@"iPod2,1"]) return @"iTouch2";
    if ([phoneModel isEqualToString:@"iPod3,1"]) return @"iTouch3";
    if ([phoneModel isEqualToString:@"iPod4,1"]) return @"iTouch4";
    if ([phoneModel isEqualToString:@"iPod5,1"]) return @"iTouch5";
    if ([phoneModel isEqualToString:@"iPod7,1"]) return @"iTouch6";

#ifdef  DEBUG
    NSLog(@"NOTE: Unknown device type: %@", phoneModel);
#endif
    return [NSString stringWithFormat:@"Apple#%@",phoneModel];
}
@end
