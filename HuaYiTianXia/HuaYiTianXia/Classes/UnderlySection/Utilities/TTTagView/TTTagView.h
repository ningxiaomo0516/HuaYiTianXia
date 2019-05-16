//
//  TTTagView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTTagViewDelegate <NSObject>

@optional

/// 点击标签的事件
- (void)handleSelectTag:(NSString *)keyWord;

@end
@interface TTTagView : UIView
@property (nonatomic ,weak)id <TTTagViewDelegate>delegate;
/// 文字数组
@property (nonatomic ,strong) NSArray *dataArray;
/// 边框颜色
@property (nonatomic ,strong) UIColor *borderColor;
/// 字体颜色
@property (nonatomic ,strong) UIColor *textColor;
/// 边框宽度
@property (nonatomic ,strong) UIColor *borderWidth;
/// 字体
@property (nonatomic ,strong) UIFont *font;
@property (nonatomic ,strong) UIButton *selectBtn;
/// 默认显示多个
@property (nonatomic ,assign) BOOL isShowMore;
/// 是否需要点击事件
@property (nonatomic ,assign) BOOL isOnClick;

@end

//self.tagView.dataArray = @[@"锤子",@"见过",@"膜拜单车",@"微信支付",@"Q",@"王者荣耀",@"蓝淋网",@"阿珂",@"半生",@"猎场",@"QQ空间",@"王者荣耀助手",@"斯卡哈复健科",@"安抚",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味"];
//TTLog(@"----- %f",CGRectGetHeight(self.tagView.frame));

NS_ASSUME_NONNULL_END
