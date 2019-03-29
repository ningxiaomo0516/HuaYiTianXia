//
//  TXMallGoodsSpecTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCCustomMarginLabel.h"
#import "TTTagView.h"

NS_ASSUME_NONNULL_BEGIN

@class TXMallGoodsSpecTableViewCell;
@protocol TXMallGoodsSpecTableViewCellDelegate <NSObject>

/**
 * 动态改变UITableViewCell的高度
 */
//- (void)updateTableViewCellHeight:(TXMallGoodsSpecTableViewCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath;

- (void)updateTableViewCellHeight:(TXMallGoodsSpecTableViewCell *)cell andheight:(CGFloat)height;
/**
 * 点击UICollectionViewCell的代理方法
 */
- (void)didToolsSelectItemAtIndexPath:(NSIndexPath *)indexPath withContent:(NSString *)content;
@end


@interface TXMallGoodsSpecTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TXMallGoodsSpecTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic ,strong) TTTagView * tagView;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 标题
@property (nonatomic, strong) SCCustomMarginLabel *subtitleLabel;
@end

NS_ASSUME_NONNULL_END
