//
//  TXReceiveAddressTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTImageButton.h"
#import "TXAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXReceiveAddressTableViewCell : UITableViewCell
/// 人-图标
@property (nonatomic, strong) UIImageView *imagesFace;
/// 地址-图标
@property (nonatomic, strong) UIImageView *imagesAddr;
/// 右边箭头
@property (nonatomic, strong) UIImageView *imagesArrow;
/// 昵称
@property (nonatomic, strong) UILabel *nicknameLabel;
/// 电话
@property (nonatomic, strong) UILabel *telphoneLabel;
/// 默认标签
@property (nonatomic, strong) UILabel *defaultLabel;
/// 地址
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) TTImageButton *addButton;

@property (nonatomic, strong) AddressModel *addrModel;
@end

NS_ASSUME_NONNULL_END
