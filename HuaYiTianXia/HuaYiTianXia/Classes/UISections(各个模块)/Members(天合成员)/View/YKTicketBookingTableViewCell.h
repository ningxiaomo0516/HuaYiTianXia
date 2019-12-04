//
//  YKTicketBookingTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/6.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKTicketBookingTableViewCell : UITableViewCell
/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UIButton *reservationBtn;

/// 分割线
@property (nonatomic, strong) UIView *linerView1;
/// 自营
@property (nonatomic, strong) UILabel *zyLabel;
@property (nonatomic, strong) UIView *linerView2;
/// 放心服务
@property (nonatomic, strong) UIButton *fwButton;

@end

NS_ASSUME_NONNULL_END
