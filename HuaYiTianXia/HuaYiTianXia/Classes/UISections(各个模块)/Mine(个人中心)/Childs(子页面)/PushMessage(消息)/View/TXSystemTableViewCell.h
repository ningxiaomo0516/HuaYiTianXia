//
//  TXSystemTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXSystemTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIImageView   *imagesView;
@property (nonatomic, strong) UILabel       *subtitleLabel;
@property (nonatomic, strong) UILabel       *amountLabel;
@end

NS_ASSUME_NONNULL_END
