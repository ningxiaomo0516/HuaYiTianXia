//
//  TTPasswordView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/4.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TTTextFeild;
typedef void(^TTTextViewPassBlock)(NSString *passwordText);

@interface TTPasswordView : UIView<UITextFieldDelegate>
/**
 *  清除密码
 */
- (void)clearUpPassword;
/*验证码的最大长度*/
@property (nonatomic, assign) NSInteger maxLenght;
@property (nonatomic, copy) TTTextViewPassBlock passwordBlock;
@end


//// 自定义 UITextField, 重写其禁止菜单弹出
@interface TTTextFeild : UITextField

@end

NS_ASSUME_NONNULL_END
