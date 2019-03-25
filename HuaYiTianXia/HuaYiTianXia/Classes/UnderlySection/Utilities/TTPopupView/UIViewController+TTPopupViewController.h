//
//  UIViewController+TTPopupViewController.h
//  SEZB
//
//  Created by 寕小陌 on 2017/1/5.
//  Copyright © 2017年 寜小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTPopupBackgroundView;

typedef enum {
    TTPopupViewAnimationFade = 0,           // 默认
    TTPopupViewAnimationSlideBottomTop = 1, // 下入上出
    TTPopupViewAnimationSlideBottomBottom,  // 下入下出
    TTPopupViewAnimationSlideTopTop,        // 上入上出
    TTPopupViewAnimationSlideTopBottom,     // 上入下出
    TTPopupViewAnimationSlideLeftLeft,      // 左入左出
    TTPopupViewAnimationSlideLeftRight,     // 左入右出
    TTPopupViewAnimationSlideRightLeft,     // 右入右出
    TTPopupViewAnimationSlideRightRight,    // 右入右出
} TTPopupViewAnimation;

@interface UIViewController(TTPopupViewController)

@property (nonatomic, retain) UIViewController *tt_popupViewController;
@property (nonatomic, retain) TTPopupBackgroundView *tt_popupBackgroundView;

- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(TTPopupViewAnimation)animationType;
- (void)presentPopupViewController:(UIViewController*)popupViewController animationType:(TTPopupViewAnimation)animationType dismissed:(void(^)(void))dismissed;
- (void)dismissPopupViewControllerWithanimationType:(TTPopupViewAnimation)animationType;


@end
