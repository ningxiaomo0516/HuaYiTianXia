//
//  SCLoadFailedView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^reminderBtnBlock) (void);
@interface SCLoadFailedView : UIView
/// 可以自定义文字和图片，不设置就会使用默认值
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName labelText:(NSString *)labelText;
//定义一个block
@property (nonatomic, copy) reminderBtnBlock reminderBlock;
@end

NS_ASSUME_NONNULL_END
