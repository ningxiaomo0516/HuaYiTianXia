//
//  TXChoosePayTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXChoosePayTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView   *imagesView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIView        *linerView;
/// 支付宝
@property (nonatomic, strong) UIButton      *alipayBtn;
/// 微信
@property (nonatomic, strong) UIButton      *wechatBtn;
@end

NS_ASSUME_NONNULL_END
