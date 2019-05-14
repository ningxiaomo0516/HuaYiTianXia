//
//  TXUAVExperienceChildCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXUAVExperienceChildCollectionViewCell : UICollectionViewCell
/// 课程标题
@property (nonatomic, strong) UILabel *titleLable;
/// 机型
@property (nonatomic, strong) UILabel *modelLable;
@property (nonatomic, strong) UILabel *modelTitleLable;
/// 理论培训
@property (nonatomic, strong) UILabel *theoryLable;
@property (nonatomic, strong) UILabel *theoryTitleLable;
/// 实践培训
@property (nonatomic, strong) UILabel *practiceLable;
@property (nonatomic, strong) UILabel *practiceTitleLable;
/// 培训周期
@property (nonatomic, strong) UILabel *cycleLable;
@property (nonatomic, strong) UILabel *cycleTitleLable;
/// 资费
@property (nonatomic, strong) UILabel *costLable;
@property (nonatomic, strong) UILabel *costTitleLable;


@property (nonatomic, strong) FlightCourseModel *courseModel;
@end

NS_ASSUME_NONNULL_END
