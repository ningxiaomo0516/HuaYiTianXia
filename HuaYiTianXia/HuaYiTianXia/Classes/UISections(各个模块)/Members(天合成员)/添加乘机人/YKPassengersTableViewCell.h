//
//  YKPassengersTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/11.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface YKPassengersTableViewCell : UITableViewCell
/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) SCTextField *sc_textField;

@end

@interface YKPassengersTableViewCellArrow : UITableViewCell
/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UIImageView *imagesArrow;

@end

NS_ASSUME_NONNULL_END
