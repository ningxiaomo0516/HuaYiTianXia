//
//  TXPaintView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXPaintView : UIView
/**
 The line width of the path. Default is `5.0f`.
 */
@property (nonatomic, assign) float lineWidth;
/**
 The line color of the path. Default is `[UIColor whiteColor]`.
 */
@property (nonatomic, strong) UIColor *lineColor;
/// 是否已签名
@property (nonatomic, assign) BOOL hasSignature;
/**
 Clear all paths.
 */
- (void)clear;
/**
 Undo.
 */
- (void)undo;
@end

NS_ASSUME_NONNULL_END
