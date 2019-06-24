//
//  TXClubExperienceTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXCourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXClubExperienceTableViewCell : UITableViewCell

/// 标题
@property (strong, nonatomic) IBOutlet UIImageView *imagesViewHot;
/// 标题
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
/// 机型
@property (strong, nonatomic) IBOutlet UILabel *modelsLabel;
/// 理论时间
@property (strong, nonatomic) IBOutlet UILabel *theoryTimeLabel;
/// 实践时间
@property (strong, nonatomic) IBOutlet UILabel *practiceTimeLabel;
/// 周期
@property (strong, nonatomic) IBOutlet UILabel *cycleLabel;
/// 立即报名
@property (strong, nonatomic) IBOutlet UIButton *signupLabel;

@property (strong, nonatomic) CourseListModel *listModel;
@end

NS_ASSUME_NONNULL_END
