//
//  TXMallUAVAdTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TXMallUAVAdTableViewCell;
@protocol TXMallUAVAdTableViewCellDelegate <NSObject>

/**
 * 点击UICollectionViewCell的代理方法
 */
- (void)didRecommendVideoSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface TXMallUAVAdTableViewCell : UICollectionViewCell
@property (nonatomic, weak) id<TXMallUAVAdTableViewCellDelegate> delegate;
@property (nonatomic, strong) MallUAVModel *listModel;
@end

NS_ASSUME_NONNULL_END
