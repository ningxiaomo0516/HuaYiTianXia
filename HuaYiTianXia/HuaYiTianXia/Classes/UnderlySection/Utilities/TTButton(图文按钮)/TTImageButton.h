//
//  TTImageButton.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/15.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TTButtonStyle){
    kTTButtonStyleTop,       // 图片在上，文字在下
    kTTButtonStyleLeft,      // 图片在左，文字在右
    kTTButtonStyleRight,     // 图片在右，文字在左
    kTTButtonStyleBottom,    // 图片在下，文字在上
};

@interface TTImageButton : UIButton

/// LPButton的样式(Top、Left、Right、Bottom)
@property (nonatomic, assign) TTButtonStyle style;

/// 图片和文字的间距
@property (nonatomic, assign) CGFloat space;

/// 整个LPButton(包含ImageV and titleV)的内边距
@property (nonatomic, assign) CGFloat delta;

@end

NS_ASSUME_NONNULL_END
