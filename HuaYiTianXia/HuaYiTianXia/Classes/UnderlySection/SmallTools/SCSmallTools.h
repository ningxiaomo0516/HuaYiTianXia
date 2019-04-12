//
//  SCSmallTools.h
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/7/24.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSmallTools : NSObject

/**
 *  获取当前时间
 */
+(NSString *)getModelTime;

/**
 *   iOS 服务器返回的时间戳转换为时间
 *
 *  @param timeStamp 当前的时间戳
 *  @return 返回已转的日期时间
 */
+(NSString *)timeStampConvertDateTime:(NSInteger)timeStamp;

/**
 富文本
 
 @param text 文本
 @param color1 颜色
 @param color2 颜色
 @param length color1颜色的文本长度
 */
+ (NSMutableAttributedString *)attributed:(NSString *)text color1:(UIColor *)color1 color2:(UIColor *)color2 length:(NSUInteger)length;


/**
 电话号码正则判断
 
 @param telNumber 电话号码
 @return 是否正确
 */
+ (BOOL)checkTelNumber:(NSString *) telNumber;


/**
 传入秒，得到xx:xx:xx
 
 @param totalTime 秒数
 @return 小时：分：秒
 */
+ (NSString *)getHHMMSSFromSS:(NSInteger)totalTime;

+ (int)convertToInt:(NSString *)strtemp;

/**
 表情符号的判断
 
 @param string 字符串
 @return 返回结果
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

/**
 *  通过富文本添加图标
 *  @param textStr 当前文字
 *  @param imageName 需要设置的图标
 *  @return 返回已经设置好的富文本
 */
+ (NSAttributedString *) sc_initImageWithText:(NSString *) textStr imageName:(NSString *)imageName fontWithSize:(UIFont *)fontSize;

/**
 *  获取验证码倒计时
 *
 *  @param sender 按钮
 */
+ (void) countdown:(UIButton *) sender;
/**
 *  为保护用户隐私，身份证号码中间用（*）号替换
 *
 *  @param idCardNumber 完整的身份证号码串 （idCard）
 *
 *  @return 隐私身份证号码
 */
+ (NSString *)idCardNumber:(NSString *)idCardNumber;
/**
 *  简单的身份证有效性
 *
 */
+ (BOOL)tt_simpleVerifyIdentityCardNum:(NSString *)idCardNumber;
@end
