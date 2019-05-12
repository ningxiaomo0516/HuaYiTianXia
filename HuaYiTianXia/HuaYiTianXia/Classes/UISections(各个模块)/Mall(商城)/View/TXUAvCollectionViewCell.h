//
//  TXUAvCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/12.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXUAvCollectionViewCell : UICollectionViewCell

/// titleView
@property (nonatomic, strong) UIView *titleView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 更多按钮
@property (nonatomic, strong) UIButton *moreButton;
@end

NS_ASSUME_NONNULL_END
