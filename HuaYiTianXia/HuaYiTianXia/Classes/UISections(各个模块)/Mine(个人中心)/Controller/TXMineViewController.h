//
//  TXMineViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTBaseTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface TXMineViewController : TTBaseTableViewController

@end

@interface TXMineViewCell : UITableViewCell
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 副标题
@property (nonatomic, strong) UILabel *subtitleLabel;
/// 图片
@property (nonatomic, strong) UIImageView *imagesView;
/// 右边箭头
@property (nonatomic, strong) UIImageView *imagesArrow;
@end

NS_ASSUME_NONNULL_END
