//
//  TXBecomeVipTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TXBecomeVipTableViewCell;
@protocol TXBecomeVipTableViewCellDelegate <NSObject>

/**
 * 动态改变UITableViewCell的高度
 */
- (void)updateTableViewCellHeight:(TXBecomeVipTableViewCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath;


/**
 * 点击UICollectionViewCell的代理方法
 */
- (void)didToolsSelectItemAtIndexPath:(NSIndexPath *)indexPath withContent:(NSString *)content;
@end

@interface TXBecomeVipTableViewCell : UITableViewCell
@property (nonatomic, weak) id<TXBecomeVipTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UILabel *subtitlelabel1;
@property (nonatomic, strong) UILabel *subtitlelabel2;
@property (nonatomic, strong) UITextField *textField;

- (void) setDataCell:(NSString *)amountText amountText1:(NSString *)amountText1 amountText2:(NSString *)amountText2;
@property (nonatomic, strong) TXGeneralModel *model;

@end

NS_ASSUME_NONNULL_END
