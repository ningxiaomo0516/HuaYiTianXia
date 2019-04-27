//
//  TTRollLabel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/27.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTRollLabel : UIScrollView
/// 设置文字
@property (nonatomic, strong) NSString *text;
/// 设置文字颜色
@property (nonatomic, strong) UIColor  *textColor;
/// 设置文字字体
@property (nonatomic, strong) UIFont   *font;

/// 滚动速度，默认0.5
@property(nonatomic, assign) float rollSpeed;
/// 自动开始，默认YES
@property(nonatomic, assign) BOOL  autoStart;

@property (nonatomic, assign, readonly) BOOL isRolling;

/**
 *  初始化方法
 *  @param font  设置字体
 *  @param color 字体颜色
 */
-(instancetype)initWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color;

- (instancetype)initWithFrame:(CGRect)frame;

/// 开始滚动
- (void)startRolling;

/// 停止滚动
- (void)stopRolling;

@end


NS_ASSUME_NONNULL_END
