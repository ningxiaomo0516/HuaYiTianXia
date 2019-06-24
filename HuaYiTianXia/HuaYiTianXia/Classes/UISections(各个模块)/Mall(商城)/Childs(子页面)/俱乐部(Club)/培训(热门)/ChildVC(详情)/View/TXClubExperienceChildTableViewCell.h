//
//  TXClubExperienceChildTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TXClubExperienceChildTableViewCell;
@protocol TXClubExperienceChildTableViewCellDelegate <NSObject>

/**
 * 动态改变UITableViewCell的高度
 */
- (void)updateTableViewCellHeight:(TXClubExperienceChildTableViewCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath;

@end


@interface TXClubExperienceChildTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TXClubExperienceChildTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSMutableArray<FlightCourseModel *> *courseModel;

/// 课程标题
@property (nonatomic, strong) UILabel * courseLabel;

@end

NS_ASSUME_NONNULL_END
