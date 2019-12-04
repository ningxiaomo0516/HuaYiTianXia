//
//  YXTicketOrderChildTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/10.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXTicketOrderChildTableViewCell : UITableViewCell
/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic,strong) UILabel *title_label;
@property (nonatomic,strong) UILabel *username_label;
@property (nonatomic,strong) UILabel *ticketno_label;
@property (nonatomic,strong) UILabel *identityno_label;

@end

NS_ASSUME_NONNULL_END
