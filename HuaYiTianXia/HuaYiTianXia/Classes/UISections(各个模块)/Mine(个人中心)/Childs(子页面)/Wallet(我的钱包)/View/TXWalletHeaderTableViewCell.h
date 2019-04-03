//
//  TXWalletHeaderTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/3.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXWalletHeaderTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imagesViewBG;
/// 余额
@property (nonatomic, strong) UILabel *balanceLabel;
/// 余额提示
@property (nonatomic, strong) UILabel *balanceTipsLabel;
@end

NS_ASSUME_NONNULL_END
