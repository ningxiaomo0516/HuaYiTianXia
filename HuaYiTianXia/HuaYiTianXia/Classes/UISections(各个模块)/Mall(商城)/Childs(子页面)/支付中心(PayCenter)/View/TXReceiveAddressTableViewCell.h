//
//  TXReceiveAddressTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTImageButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXReceiveAddressTableViewCell : UITableViewCell
/// 图标
@property (nonatomic, strong) UIImageView *imagesView;
/// 昵称
@property (nonatomic, strong) UILabel *nicknameLabel;
/// 电话
@property (nonatomic, strong) UILabel *telphoneLabel;
/// 地址
@property (nonatomic, strong) UILabel *addressLabel;
/// 图标
@property (nonatomic, strong) UIImageView *imagesArrow;
@property (nonatomic, strong) TTImageButton *addButton;
@end

NS_ASSUME_NONNULL_END
