//
//  TXUAVExperienceTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXUAVExperienceTableViewCell.h"

@implementation TXUAVExperienceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
    
    [self.signupLabel setBackgroundImage:imageHexString(@"#F56C36") forState:UIControlStateNormal];
    [self.signupLabel lz_setCornerRadius:11.0];
}

- (void)setListModel:(CourseListModel *)listModel{
    _listModel = listModel;
    if (self.listModel.hot==0) {
        self.imagesViewHot.hidden = NO;
    }else{
        self.imagesViewHot.hidden = YES;
    }
    self.titleLabel.text = self.listModel.title;
    if (self.listModel.flightcourse.count>0) {
        FlightCourseModel *flightcourse = self.listModel.flightcourse[0];
        self.modelsLabel.text = flightcourse.courseTitle;
        self.theoryTimeLabel.text = flightcourse.theoryTime;
        self.practiceTimeLabel.text = flightcourse.practiceTime;
        self.cycleLabel.text = flightcourse.cycle;
    }else{
        self.modelsLabel.text = @"";
        self.modelsLabel.text = @"";
        self.modelsLabel.text = @"";
        self.modelsLabel.text = @"";
    }
}

@end
