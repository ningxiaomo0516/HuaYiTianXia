//
//  TXBezierPath.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/5.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (TXBezierPath)
/**
 The line color of the path. Default is `[UIColor whiteColor]`.
 */
@property (nonatomic, strong) UIColor *lineColor;
@end

NS_ASSUME_NONNULL_END
