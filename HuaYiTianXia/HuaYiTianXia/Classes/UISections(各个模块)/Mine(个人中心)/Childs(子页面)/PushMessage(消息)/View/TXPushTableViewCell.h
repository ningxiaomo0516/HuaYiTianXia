//
//  TXPushTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXPushTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView    *boxView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *dateLabel;
@property (nonatomic, strong) UIView    *linerView;
@property (nonatomic, strong) UILabel   *contenLabel;
@end

NS_ASSUME_NONNULL_END
