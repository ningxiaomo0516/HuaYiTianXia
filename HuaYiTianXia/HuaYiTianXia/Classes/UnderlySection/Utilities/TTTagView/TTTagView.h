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

@end


NS_ASSUME_NONNULL_END
