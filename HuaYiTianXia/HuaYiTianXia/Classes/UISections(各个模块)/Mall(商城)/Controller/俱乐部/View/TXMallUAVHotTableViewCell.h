//
//  TXMallUAVHotTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCourseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TXMallUAVHotTableViewCell;
@protocol TXMallUAVHotTableViewCellDelegate <NSObject>

/**
 * 点击UICollectionViewCell的代理方法
 */
- (void)didRecommendVideoSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^TXMallUAVHotTableViewCellBlock) (CourseListModel *model);
@interface TXMallUAVHotTableViewCell : UICollectionViewCell
@property (nonatomic, weak) id<TXMallUAVHotTableViewCellDelegate> delegate;

@property (nonatomic, strong) MallUAVModel *listModel;
//定义一个block
@property (nonatomic, copy) TXMallUAVHotTableViewCellBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
