//
//  TXReceiveGiftListTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXReceiveGiftListTableViewCell : UITableViewCell
/// 昵称
@property (nonatomic, strong) UILabel *titleLabel;
/// 昵称
@property (nonatomic, strong) UILabel *dateLabel;
/// 昵称
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) NewsRecordsModel *model;
@end

NS_ASSUME_NONNULL_END
