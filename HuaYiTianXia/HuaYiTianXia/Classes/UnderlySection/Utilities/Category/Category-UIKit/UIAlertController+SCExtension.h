//
//  UIAlertController+SCExtension.h
//  LZExtension
//
//  Created by 寕小陌 on 2016/12/9.
//  Copyright © 2016年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (SCExtension)


/**
 *  UIAlertController
 *
 *  @param reminderText 文字提示
 *  @param message 消息内容
 *  @param cancelTitle 取消文字
 *  @param doTitle 完成文字
 *  @param preferredStyle 类型
 *  @param cancelBlock 取消回调
 *  @param doBlock 完成回调
 *  @return 返回 AlertController
 */
+ (UIAlertController*)addAlertReminderText:(NSString*)reminderText
                                   message:(NSString*)message
                               cancelTitle:(NSString*)cancelTitle
                                   doTitle:(NSString*)doTitle
                            preferredStyle:(UIAlertControllerStyle)preferredStyle
                               cancelBlock:(void (^)())cancelBlock
                                   doBlock:(void (^)())doBlock;

@end
