//
//  NSObject+Toast.h
//  SEZB
//
//  Created by 寕小陌 on 2016/12/15.
//  Copyright © 2016年 寜小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

//上下左右距离
#define TOAST_TEXT_MARGIN_TOP_BOTTOM  12.0f
#define TOAST_TEXT_MARGIN_LEFT_RIGHT  15.0f
//默认toast位置Y
#define TOAST_POSITION_Y   (kCrossScreenHeight/2)

//字体
#define TOAST_TEXT_FONTSIZE         kFontSizeMedium13
//动画时间
#define TOAST_ANIMATION_DURATION    4.8f
//显示和消失时间
#define TOAST_ANI_STARTEND_DURATION 2.0f

@interface NSObject (Toast)

- (void)tt_make:(NSString*)text duration:(CGFloat)duration backgroundColor:(UIColor*)color position:(CGPoint)point;

- (void)tt_make:(NSString*)text duration:(CGFloat)duration position:(CGPoint)point;

- (void)tt_make:(NSString*)text;

@end
