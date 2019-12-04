//
//  YKPassengersCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/13.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXTicketModel.h"

NS_ASSUME_NONNULL_BEGIN

@class YKPassengersCollectionViewCell;
@protocol YKPassengersCollectionViewCellDelegate <NSObject>
/**
 * 动态改变UITableViewCell的高度
 */
- (void)updateSecondTableViewCellHeight:(YKPassengersCollectionViewCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath;


/**
 * 点击UICollectionViewCell的代理方法
 */
- (void)didPassengerSelectItemAtIndexPath:(NSIndexPath *)indexPath withModel:(PassengerModel *)model;
@end
@interface YKPassengersCollectionViewCell : UITableViewCell
/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, weak) id<YKPassengersCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end


@interface YKTemplateSecondCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) UIButton *addButton;
/// 方块视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取方块视图对象
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@end
NS_ASSUME_NONNULL_END
