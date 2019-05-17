//
//  UIAlertController+SCExtension.m
//  LZExtension
//
//  Created by 寕小陌 on 2016/12/9.
//  Copyright © 2016年 寕小陌. All rights reserved.
//

#import "UIAlertController+SCExtension.h"

@implementation UIAlertController (SCExtension)

+(UIAlertController*)addAlertReminderText:(NSString*)reminderText
                                  message:(NSString*)message
                              cancelTitle:(NSString*)cancelTitle
                                  doTitle:(NSString*)doTitle
                           preferredStyle:(UIAlertControllerStyle)preferredStyle
                              cancelBlock:(void (^)())cancelBlock
                                  doBlock:(void (^)())doBlock {
    
    UIAlertController *alerController = [UIAlertController  alertControllerWithTitle:reminderText message:message preferredStyle:preferredStyle];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelBlock];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:doTitle style:UIAlertActionStyleDestructive handler:doBlock];
    if (kVersion > 8.3 ) {
        [cancelAction setValue:kTextColor51 forKey:@"_titleTextColor"];
//        [deleteAction setValue:kTextColor51 forKey:@"_titleTextColor"];
    }
    if (cancelTitle.length!=0) {
        [alerController addAction:cancelAction];
    }
    if (doTitle.length!=0) {
        [alerController addAction:deleteAction];
    }
    return alerController;
}



@end
