//
//  TXWalletTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TXWalletTableViewCell;
@protocol TXWalletTableViewCellDelegate <NSObject>

/**
 * 动态改变UITableViewCell的高度
 */
- (void)updateTableViewCellHeight:(TXWalletTableViewCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath;


/**
 * 点击UICollectionViewCell的代理方法
 */
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withTitle:(NSString *)title withShowClass:(NSString *)showClass;
@end


@interface TXWalletTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TXWalletTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
