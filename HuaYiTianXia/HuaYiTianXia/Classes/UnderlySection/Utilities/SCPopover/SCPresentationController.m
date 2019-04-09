//
//  SCPresentationController.m
//  SCPopover
//
//  Created by 宁小陌 on 2018/7/3.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import "SCPresentationController.h"

@interface SCPresentationController()
@end
@implementation SCPresentationController

- (void)containerViewWillLayoutSubviews{
    [super containerViewWillLayoutSubviews];
    /// 设置弹出视图尺寸
    if (_popoverType == SCPopoverTypeAlert) {
        CGFloat left = self.containerView.center.x - self.presentedSize.width * 0.5;
        CGFloat top = self.containerView.center.y - self.presentedSize.height * 0.5;
        CGFloat width = self.presentedSize.width;
        CGFloat height = self.presentedSize.height;
        if (self.presentedTop) { /// 默认为居中设置,presentedTop:NO
            top = self.containerView.center.y - self.presentedSize.height * 0.8;
        }
        self.presentedView.frame = CGRectMake(left, top, width, height);
    }else{
        self.presentedView.frame = CGRectMake(0, self.containerView.bounds.size.height - self.presentedHeight, self.containerView.bounds.size.width, self.presentedHeight);
        /// 不为SCPopoverTypeAlert的时候添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewClick)];
        [_coverView addGestureRecognizer:tap];
    }
    /// 添加蒙版
    [self.containerView insertSubview:self.coverView atIndex:0];
}

- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
    }
    return _coverView;
}

- (void)dismissViewClick{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
