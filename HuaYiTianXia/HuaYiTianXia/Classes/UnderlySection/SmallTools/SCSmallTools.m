//
//  SCSmallTools.m
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/7/24.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import "SCSmallTools.h"

@implementation SCSmallTools

+(NSString *)getModelTime {
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    
    return dateTime;
}

/**
 *   iOS 服务器返回的时间戳转换为时间
 *
 *  @param timeStamp 当前的时间戳
 *  @return 返回已转的日期时间
 */
+(NSString *)timeStampConvertDateTime:(NSInteger)timeStamp{
    CGFloat timeStamp_ = timeStamp / 1000.0;
    NSString *dateTime = [NSString stringWithFormat:@"%f",timeStamp_];
    return [Utils lz_timeWithTimeIntervalString:dateTime formatter:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSMutableAttributedString *)attributed:(NSString *)text color1:(UIColor *)color1 color2:(UIColor *)color2 length:(NSUInteger)length {
    NSRange range0;
    range0.location = 0;
    range0.length = text.length - length;
    
    NSRange range1;
    range1.location = text.length - length;
    range1.length = length;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedText addAttribute:NSForegroundColorAttributeName value:color1 range:range0];
    [attributedText addAttribute:NSForegroundColorAttributeName value:color2 range:range1];
    
    return attributedText;
}

+ (BOOL)checkTelNumber:(NSString *) telNumber{
    if (telNumber.length != 11) {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    /**
     25     * 大陆地区固话及小灵通
     26     * 区号：010,020,021,022,023,024,025,027,028,029
     27     * 号码：七位或八位
     28     */
    //  NSString * PHS = @"^(0[0-9]{2})\\d{8}$|^(0[0-9]{3}(\\d{7,8}))$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:telNumber] == YES)
        || ([regextestcm evaluateWithObject:telNumber] == YES)
        || ([regextestct evaluateWithObject:telNumber] == YES)
        || ([regextestcu evaluateWithObject:telNumber] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)getHHMMSSFromSS:(NSInteger)totalTime {
    NSInteger seconds = totalTime;
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

+ (int)convertToInt:(NSString *)strtemp {
    int length = 0;
    char *p = (char *)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i ++) {
        if (*p) {
            p ++;
            length ++;
        }else {
            p ++;
        }
    }
    return length;
}
//表情符号的判断
+ (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}


// 实现图文混排的方法
+ (NSAttributedString *) sc_initImageWithText:(NSString *) textStr imageName:(NSString *)imageName fontWithSize:(UIFont *)fontSize{
    
    // NSTextAttachment可以将图片转换为富文本内容
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = kGetImage(imageName);
    // 通过NSTextAttachment创建富文本
    // 图片的富文本
    NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 文字的富文本
    NSAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",textStr] attributes:@{NSFontAttributeName:fontSize}];
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    // 将图片、文字拼接
    // 如果要求图片在文字的后面只需要交换下面两句的顺序
    [mutableAttr appendAttributedString:imageAttr];
    [mutableAttr appendAttributedString:textAttr];
    
    return [mutableAttr copy];
}

/**
 *  点击获取验证码
 *
 *  倒计时
 */
+ (void) countdown:(UIButton *) sender {
//    [self.pwdField becomeFirstResponder];
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:@"重新获取" forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
                //                [self.codeButton setBackgroundImage:[Utils imageWithColor:kColorWithRGB(107, 152, 254)] forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:[NSString stringWithFormat:@"%@秒后获取",strTime] forState:UIControlStateNormal];
                sender.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

/**
 *  为保护用户隐私，身份证号码中间用（*）号替换
 *
 *  @param idCardNumber 完整的身份证号码串 （idCard）
 *
 *  @return 隐私身份证号码
 */
+ (NSString *)idCardNumber:(NSString *)idCardNumber {
    NSString *tempStr = @"";
    for (int i  = 0; i < idCardNumber.length - 7; i++) {
        tempStr = [tempStr stringByAppendingString:@"*"];
    }
    //身份证号取前三位和后四位 中间拼接 tempSt（*）
    idCardNumber = [NSString stringWithFormat:@"%@%@%@", [idCardNumber substringToIndex:3], tempStr, [idCardNumber substringFromIndex:idCardNumber.length - 4]];
    return idCardNumber;
}

+ (BOOL)tt_simpleVerifyIdentityCardNum:(NSString *)idCardNumber{
    if (idCardNumber.length <= 0) {
        return NO;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:idCardNumber];
}

/**
 *  替换文本字符串
 *
 *  @param currentText 当前的字符串
 *  @param parameter1 需要替换的字符串
 *  @param parameter2 需要替换成的字符串
 */
+ (NSString *) tt_replaceText:(NSString *)currentText parameter1:(NSString *)parameter1 parameter2:(NSString *)parameter2{
    NSString *replaceText = [currentText stringByReplacingOccurrencesOfString:parameter1 withString:parameter2];
    return replaceText;
}

/**
 *  富文本设置文字颜色
 *
 *  @param currentText 当前的字符串
 *  @param color 文字颜色
 *  @param index 开始下标
 *  @param endIndex 结束下标
 */
+ (NSMutableAttributedString *) setupTextColor:(UIColor *)color currentText:(NSString *)currentText index:(NSInteger)index endIndex:(NSInteger)endIndex{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:currentText];
    /// 后面文字颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:color
                          range:NSMakeRange(index, endIndex)];
    return attributedStr;
}

+ (NSString *)tt_dateWeekWithDateString:(NSString *)dateString{
    NSTimeInterval time=[dateString doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger _weekday = [weekdayComponents weekday];
    NSString *weekStr;
    if (_weekday == 1) {
        weekStr = @"星期日";
    }else if (_weekday == 2){
        weekStr = @"星期一";
    }else if (_weekday == 3){
        weekStr = @"星期二";
    }else if (_weekday == 4){
        weekStr = @"星期三";
    }else if (_weekday == 5){
        weekStr = @"星期四";
    }else if (_weekday == 6){
        weekStr = @"星期五";
    }else if (_weekday == 7){
        weekStr = @"星期六";
    }
    return weekStr;
}

/**
 *  字符串转星期几
 *
 *  @param currentDate 当前日期(2019-04-30)
 *  @return 返回星期-到星期天中的某一天
 */
+ (NSString*)tt_weekdayStringFromDate:(NSString*)currentDate {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    NSDate*inputDate =[dateFormat dateFromString:currentDate];
    
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}
@end
