//
//  TTBottomShowView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/15.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^TTBottomShowViewBlock) (NSInteger idx);
@interface TTBottomShowView : UIView
//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view;
- (void)disMissView;
/// 默认View的高度
@property(nonatomic,assign) CGFloat     defaultHeight;
@property(nonatomic,strong) UIView      *maskView;
@property(nonatomic,strong) UILabel     *titleLabel;
@property(nonatomic,strong) UILabel     *subtitleLabel;
@property(nonatomic,strong) NSString    *amountText;

- (UIView *) initMaskView;
- (void) addAnimate;

//定义一个block
@property (nonatomic, copy) TTBottomShowViewBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
