//
//  YKBaseNavigationView.h
//  YiKao
//
//  Created by 宁小陌 on 2019/8/22.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKBaseNavigationView : UIView
/// navView
@property (nonatomic, strong) UIView *boxView;
/// 设置按钮
@property (nonatomic, strong) UIButton *setupButton;
/// 设置按钮
@property (nonatomic, strong) UIImageView *imagesView;
@end

NS_ASSUME_NONNULL_END
