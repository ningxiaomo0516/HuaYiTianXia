//
//  UIViewController+SCPopover.h
//  SCPopover
//
//  Created by 宁小陌 on 2018/7/3.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPopoverMacro.h"
#import "SCPopoverAnimator.h"

@interface UIViewController (SCPopover)

@property(nonatomic,strong)SCPopoverAnimator        *popoverAnimator;

/**
 *  从底部弹出一个控制器
 *
 *  @param vc 需要弹出的控制器
 *  @param height 弹出的高度
 *  @param completion 弹出消失的回调
 */
- (void)sc_bottomPresentController:(UIViewController *)vc presentedHeight:(CGFloat)height completeHandle:(SCCompleteHandle)completion;

/**
 *  从当前屏幕中间弹出一个控制器
 *
 *  @param vc 需要弹出的控制器
 *  @param size 设置size大小
 *  @param completion completion 弹出消失的回调
 */
- (void)sc_centerPresentController:(UIViewController *)vc presentedSize:(CGSize)size completeHandle:(SCCompleteHandle)completion;
/// 关闭VC
- (void)sc_dismissVC;
@end
