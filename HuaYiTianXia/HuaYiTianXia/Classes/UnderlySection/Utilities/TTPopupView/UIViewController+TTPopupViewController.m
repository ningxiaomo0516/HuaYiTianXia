//
//  UIViewController+TTPopupViewController.m
//  SEZB
//
//  Created by 寕小陌 on 2017/1/5.
//  Copyright © 2017年 寜小陌. All rights reserved.
//

#import "UIViewController+TTPopupViewController.h"
#import "TTPopupBackgroundView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#define kPopupModalAnimationDuration 0.35
#define kTTPopupViewController @"kTTPopupViewController"
#define kTTPopupBackgroundView @"kTTPopupBackgroundView"
#define kTTSourceViewTag 23941
#define kTTPopupViewTag 23942
#define kTTOverlayViewTag 23945

@interface UIViewController (TTPopupViewControllerPrivate)
- (UIView*)topView;
- (void)presentPopupView:(UIView*)popupView;
@end

static NSString *TTPopupViewDismissedKey = @"TTPopupViewDismissed";

////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

@implementation UIViewController (TTPopupViewController)

static void * const keypath = (void*)&keypath;

- (UIViewController*)tt_popupViewController {
    return objc_getAssociatedObject(self, kTTPopupViewController);
}

- (void)setTt_popupViewController:(UIViewController *)tt_popupViewController {
    objc_setAssociatedObject(self, kTTPopupViewController, tt_popupViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (TTPopupBackgroundView*)tt_popupBackgroundView {
    return objc_getAssociatedObject(self, kTTPopupBackgroundView);
}

- (void)setTt_popupBackgroundView:(TTPopupBackgroundView *)tt_popupBackgroundView {
    objc_setAssociatedObject(self, kTTPopupBackgroundView, tt_popupBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(TTPopupViewAnimation)animationType dismissed:(void(^)(void))dismissed{
    self.tt_popupViewController = popupViewController;
    [self presentPopupView:popupViewController.view animationType:animationType dismissed:dismissed];
}

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(TTPopupViewAnimation)animationType{
    [self presentPopupViewController:popupViewController animationType:animationType dismissed:nil];
}

- (void)dismissPopupViewControllerWithanimationType:(TTPopupViewAnimation)animationType{
    UIView *sourceView = [self topView];
    UIView *popupView = [sourceView viewWithTag:kTTPopupViewTag];
    UIView *overlayView = [sourceView viewWithTag:kTTOverlayViewTag];
    
    switch (animationType) {
        case TTPopupViewAnimationSlideBottomTop:
        case TTPopupViewAnimationSlideBottomBottom:
        case TTPopupViewAnimationSlideTopTop:
        case TTPopupViewAnimationSlideTopBottom:
        case TTPopupViewAnimationSlideLeftLeft:
        case TTPopupViewAnimationSlideLeftRight:
        case TTPopupViewAnimationSlideRightLeft:
        case TTPopupViewAnimationSlideRightRight:
            [self slideViewOut:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
            break;
            
        default:
            [self fadeViewOut:popupView sourceView:sourceView overlayView:overlayView];
            break;
    }
}



////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Handling

- (void)presentPopupView:(UIView*)popupView animationType:(TTPopupViewAnimation)animationType {
    [self presentPopupView:popupView animationType:animationType dismissed:nil];
}

- (void)presentPopupView:(UIView*)popupView animationType:(TTPopupViewAnimation)animationType dismissed:(void(^)(void))dismissed {
    UIView *sourceView = [self topView];
    sourceView.tag = kTTSourceViewTag;
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popupView.tag = kTTPopupViewTag;
    
    // 检查源视图控制器是否位于目标位置
    if ([sourceView.subviews containsObject:popupView]) return;
    
    // 定制 popupView
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
    popupView.layer.shadowOpacity = 0.5;
    popupView.layer.shouldRasterize = YES;
    popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // 添加透明背景
    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlayView.tag = kTTOverlayViewTag;
    overlayView.backgroundColor = [UIColor clearColor];
    
    // BackgroundView
    self.tt_popupBackgroundView = [[TTPopupBackgroundView alloc] initWithFrame:sourceView.bounds];
    self.tt_popupBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tt_popupBackgroundView.backgroundColor = [UIColor blackColor];
    self.tt_popupBackgroundView.alpha = 0.5f;
    [overlayView addSubview:self.tt_popupBackgroundView];
    
    // 弹出框点击背景消失
    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = sourceView.bounds;
    [overlayView addSubview:dismissButton];
    
    popupView.alpha = 0.0f;
    [overlayView addSubview:popupView];
    [sourceView addSubview:overlayView];
    
//    [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimation:) forControlEvents:UIControlEventTouchUpInside];
    switch (animationType) {
        case TTPopupViewAnimationSlideBottomTop:
        case TTPopupViewAnimationSlideBottomBottom:
        case TTPopupViewAnimationSlideTopTop:
        case TTPopupViewAnimationSlideTopBottom:
        case TTPopupViewAnimationSlideLeftLeft:
        case TTPopupViewAnimationSlideLeftRight:
        case TTPopupViewAnimationSlideRightLeft:
        case TTPopupViewAnimationSlideRightRight:
            dismissButton.tag = animationType;
            [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
            break;
        default:
            dismissButton.tag = TTPopupViewAnimationFade;
            [self fadeViewIn:popupView sourceView:sourceView overlayView:overlayView];
            break;
    }
    
    [self setDismissedCallback:dismissed];
}

-(UIView*)topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

- (void)dismissPopupViewControllerWithanimation:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton* dismissButton = sender;
        switch (dismissButton.tag) {
            case TTPopupViewAnimationSlideBottomTop:
            case TTPopupViewAnimationSlideBottomBottom:
            case TTPopupViewAnimationSlideTopTop:
            case TTPopupViewAnimationSlideTopBottom:
            case TTPopupViewAnimationSlideLeftLeft:
            case TTPopupViewAnimationSlideLeftRight:
            case TTPopupViewAnimationSlideRightLeft:
            case TTPopupViewAnimationSlideRightRight:
                [self dismissPopupViewControllerWithanimationType:(TTPopupViewAnimation)dismissButton.tag];
                break;
            default:
                [self dismissPopupViewControllerWithanimationType:TTPopupViewAnimationFade];
                break;
        }
    } else {
        [self dismissPopupViewControllerWithanimationType:TTPopupViewAnimationFade];
    }
}

//////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Animations

#pragma mark --- Slide

- (void)slideViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(TTPopupViewAnimation)animationType {
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupStartRect;
    switch (animationType) {
        case TTPopupViewAnimationSlideBottomTop:
        case TTPopupViewAnimationSlideBottomBottom:
            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                        sourceSize.height,
                                        popupSize.width,
                                        popupSize.height);
            
            break;
        case TTPopupViewAnimationSlideLeftLeft:
        case TTPopupViewAnimationSlideLeftRight:
            popupStartRect = CGRectMake(-sourceSize.width,
                                        (sourceSize.height - popupSize.height) / 2,
                                        popupSize.width,
                                        popupSize.height);
            break;
            
        case TTPopupViewAnimationSlideTopTop:
        case TTPopupViewAnimationSlideTopBottom:
            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                        -popupSize.height,
                                        popupSize.width,
                                        popupSize.height);
            break;
            
        default:
            popupStartRect = CGRectMake(sourceSize.width,
                                        (sourceSize.height - popupSize.height) / 2,
                                        popupSize.width,
                                        popupSize.height);
            break;
    }
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    
    // 设置初始属性
    popupView.frame = popupStartRect;
    popupView.alpha = 1.0f;
    [UIView animateWithDuration:kPopupModalAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.tt_popupViewController viewWillAppear:NO];
        self.tt_popupBackgroundView.alpha = 0.5f;
        popupView.frame = popupEndRect;
    } completion:^(BOOL finished) {
        [self.tt_popupViewController viewDidAppear:NO];
    }];
}

- (void)slideViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(TTPopupViewAnimation)animationType {
    // 生成开始位置和结束位置
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect;
    switch (animationType) {
        case TTPopupViewAnimationSlideBottomTop:
        case TTPopupViewAnimationSlideTopTop:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                      -popupSize.height,
                                      popupSize.width,
                                      popupSize.height);
            break;
        case TTPopupViewAnimationSlideBottomBottom:
        case TTPopupViewAnimationSlideTopBottom:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                      sourceSize.height,
                                      popupSize.width,
                                      popupSize.height);
            break;
        case TTPopupViewAnimationSlideLeftRight:
        case TTPopupViewAnimationSlideRightRight:
            popupEndRect = CGRectMake(sourceSize.width,
                                      popupView.frame.origin.y,
                                      popupSize.width,
                                      popupSize.height);
            break;
        default:
            popupEndRect = CGRectMake(-popupSize.width,
                                      popupView.frame.origin.y,
                                      popupSize.width,
                                      popupSize.height);
            break;
    }
    
    [UIView animateWithDuration:kPopupModalAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.tt_popupViewController viewWillDisappear:NO];
        popupView.frame = popupEndRect;
        self.tt_popupBackgroundView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        [self.tt_popupViewController viewDidDisappear:NO];
        self.tt_popupViewController = nil;
        
        id dismissed = [self dismissedCallback];
        if (!dismissed){
            ((void(^)(void))dismissed)();
            [self setDismissedCallback:nil];
        }
    }];
}

#pragma mark --- Fade
- (void)fadeViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView {
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    /// 此处修改中间弹框的位置
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 3,
                                     popupSize.width,
                                     popupSize.height);
    
    // Set starting properties
    popupView.frame = popupEndRect;
    popupView.alpha = 0.0f;
    
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        [self.tt_popupViewController viewWillAppear:NO];
        self.tt_popupBackgroundView.alpha = 0.5f;
        popupView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.tt_popupViewController viewDidAppear:NO];
    }];
}

- (void)fadeViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView {
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        [self.tt_popupViewController viewWillDisappear:NO];
        self.tt_popupBackgroundView.alpha = 0.0f;
        popupView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        [self.tt_popupViewController viewDidDisappear:NO];
        self.tt_popupViewController = nil;
        
        id dismissed = [self dismissedCallback];
        if (dismissed != nil) {
            ((void(^)(void))dismissed)();
            [self setDismissedCallback:nil];
        }
    }];
}

#pragma mark -
#pragma mark Category Accessors

#pragma mark --- Dismissed
- (void)setDismissedCallback:(void(^)(void))dismissed {
    objc_setAssociatedObject(self, &TTPopupViewDismissedKey, dismissed, OBJC_ASSOCIATION_RETAIN);
}

- (void(^)(void))dismissedCallback {
    return objc_getAssociatedObject(self, &TTPopupViewDismissedKey);
}

@end
