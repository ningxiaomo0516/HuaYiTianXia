//
//  TXCourseReservationView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTagView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXCourseReservationView : UIView
//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view;
//@property (nonatomic, weak) id<ZBGivingSheetViewDelegate> delegate;  //实现代理

/// 显示内容高度
@property (nonatomic, assign) CGFloat    viewHeight;
/// 视图top值
@property (nonatomic, assign) CGFloat    viewY;
@property (nonatomic, assign) CGFloat     difference;
@property (nonatomic, strong) UIView *lineView;     // 分割线
@property (nonatomic, strong) TTTagView * tagView1;
@property (nonatomic, strong) TTTagView * tagView2;

@property (nonatomic, strong) UIView * boxView1;
@property (nonatomic, strong) UIView * boxView2;

@property (nonatomic, strong) UILabel * usernameLabel;
@property (nonatomic, strong) UILabel * telphoneLabel;

@property (nonatomic, strong) UITextField * usernameTextField;
@property (nonatomic, strong) UITextField * telphoneTextField;

@end

NS_ASSUME_NONNULL_END
