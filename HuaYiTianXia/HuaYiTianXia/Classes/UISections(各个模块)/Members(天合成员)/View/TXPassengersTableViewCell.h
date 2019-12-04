//
//  TXPassengersTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/9.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 组1
@interface TXPassengersTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *date_label;
@property (nonatomic, strong) UILabel *week_label;
@property (nonatomic, strong) UILabel *time_label;
@property (nonatomic, strong) UILabel *seat_label;
@property (nonatomic, strong) UIImageView *imagesArrow;
/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

@end

/// 组二
@interface TXPassengersTableViewCell2 : UITableViewCell

/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;


@property (nonatomic, strong) UIImageView *imagesView;
@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) UILabel *subtitle_label;

@end

/// 组三
@interface TXPassengersTableViewCell3 : UITableViewCell

/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) UIImageView *imagesView;
@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) UILabel *subtitle_label;

@end

/// 组四
@interface TXPassengersTableViewCell4 : UITableViewCell

/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
/// 姓名
@property (nonatomic, strong) UILabel *username_label;
/// 身份证
@property (nonatomic, strong) UILabel *idcard_label;
/// 票类型
@property (nonatomic, strong) UILabel *ticket_type_label;

@end


/// 组五
@interface TXPassengersTableViewCell5 : UITableViewCell

/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
/// 姓名
@property (nonatomic, strong) UILabel *title_label;
/// 身份证
@property (nonatomic, strong) UITextField *textField;

@end

/// 组六
@interface TXPassengersTableViewCell6 : UITableViewCell

/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) UILabel *subtitle_label;
@end

/// 组七
@interface TXPassengersTableViewCell7 : UITableViewCell

/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) UILabel *subtitle_label;

@end

NS_ASSUME_NONNULL_END
