//
//  TXUAVExperienceChildCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXUAVExperienceChildCollectionViewCell.h"

@implementation TXUAVExperienceChildCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kWhiteColor;
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.contentView.backgroundColor = kWhiteColor;
        [self initView];
    }
    return self;
}

- (void)setCourseModel:(FlightCourseModel *)courseModel{
    _courseModel = courseModel;
    /// 课程标题
    self.titleLable.text = self.courseModel.courseTitle;
    /// 机型
    self.modelLable.text = self.courseModel.modelName;//@"罗宾逊R22/R44";
    self.modelTitleLable.text = @"机型";
    /// 理论培训
    self.theoryLable.text = self.courseModel.practiceTime;//@"109小时";
    self.theoryTitleLable.text = @"理论培训";
    /// 实践培训
    self.practiceLable.text = self.courseModel.theoryTime;//@"飞行50小时";
    self.practiceTitleLable.text = @"实践培训";
    /// 培训周期
    self.cycleLable.text = self.courseModel.courseSynopsis;//@"3~6个月";
    self.cycleTitleLable.text = @"培训周期";
    /// 资费
    self.costLable.text = @"￥19.8万元起";
    NSString *icon = @"￥";
    NSString *unit = self.courseModel.unit;
    NSString *amountText1 = self.courseModel.money;
    NSString *amountText11 = [NSString stringWithFormat:@"%@%@%@",icon,amountText1,unit];
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:amountText11];
    /// 前面文字颜色
    [mutableAttr addAttribute:NSForegroundColorAttributeName
                        value:HexString(@"#FC9B33")
                        range:NSMakeRange(0, amountText11.length-unit.length)];
    // 前面文字大小
    [mutableAttr addAttribute:NSFontAttributeName
                        value:kFontSizeMedium15
                        range:NSMakeRange(0, icon.length)];
    // 前面文字大小
    [mutableAttr addAttribute:NSFontAttributeName
                        value:kFontSizeMedium19
                        range:NSMakeRange(icon.length, amountText11.length-unit.length-icon.length)];
    self.costLable.attributedText = mutableAttr;
}

- (void) initView{
    [self.contentView lz_setCornerRadius:7.0];
    [self.contentView setBorderColor:kTextColor112];
    [self.contentView setBorderWidth:0.7];
    
    /// 课程标题
    [self.contentView addSubview:self.titleLable];
    /// 机型
    [self.contentView addSubview:self.modelLable];
    [self.contentView addSubview:self.modelTitleLable];
    /// 理论培训
    [self.contentView addSubview:self.theoryLable];
    [self.contentView addSubview:self.theoryTitleLable];
    /// 实践培训
    [self.contentView addSubview:self.practiceLable];
    [self.contentView addSubview:self.practiceTitleLable];
    /// 培训周期
    [self.contentView addSubview:self.cycleLable];
    [self.contentView addSubview:self.cycleTitleLable];
    /// 资费
    [self.contentView addSubview:self.costLable];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(10));
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [self.modelTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable);
        make.top.equalTo(self.titleLable.mas_bottom);
    }];
    [self.theoryTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable);
        make.top.equalTo(self.modelTitleLable.mas_bottom);
    }];
    [self.practiceTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable);
        make.top.equalTo(self.theoryTitleLable.mas_bottom);
    }];
    [self.cycleTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable);
        make.top.equalTo(self.practiceTitleLable.mas_bottom);
    }];
    
    [self.modelLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(70)));
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.modelTitleLable);
    }];
    [self.theoryLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.modelLable);
        make.centerY.equalTo(self.theoryTitleLable);
    }];
    [self.practiceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.modelLable);
        make.centerY.equalTo(self.practiceTitleLable);
    }];
    [self.cycleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.modelLable);
        make.centerY.equalTo(self.cycleTitleLable);
    }];
    [self.costLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.centerX.equalTo(self);
    }];
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        _titleLable.numberOfLines = 1;
    }
    return _titleLable;
}
- (UILabel *)modelLable{
    if (!_modelLable) {
        _modelLable = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
        _modelLable.numberOfLines = 1;
    }
    return _modelLable;
}
- (UILabel *)modelTitleLable{
    if (!_modelTitleLable) {
        _modelTitleLable = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
        _modelTitleLable.numberOfLines = 1;
    }
    return _modelTitleLable;
}

- (UILabel *)theoryLable{
    if (!_theoryLable) {
        _theoryLable = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
        _theoryLable.numberOfLines = 1;
    }
    return _theoryLable;
}
- (UILabel *)theoryTitleLable{
    if (!_theoryTitleLable) {
        _theoryTitleLable = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
        _theoryTitleLable.numberOfLines = 1;
    }
    return _theoryTitleLable;
}

- (UILabel *)practiceLable{
    if (!_practiceLable) {
        _practiceLable = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
        _practiceLable.numberOfLines = 1;
    }
    return _practiceLable;
}
- (UILabel *)practiceTitleLable{
    if (!_practiceTitleLable) {
        _practiceTitleLable = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
        _practiceTitleLable.numberOfLines = 1;
    }
    return _practiceTitleLable;
}

- (UILabel *)cycleLable{
    if (!_cycleLable) {
        _cycleLable = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
        _cycleLable.numberOfLines = 1;
    }
    return _cycleLable;
}
- (UILabel *)cycleTitleLable{
    if (!_cycleTitleLable) {
        _cycleTitleLable = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
        _cycleTitleLable.numberOfLines = 1;
    }
    return _cycleTitleLable;
}

- (UILabel *)costLable{
    if (!_costLable) {
        _costLable = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium12];
        _costLable.numberOfLines = 1;
    }
    return _costLable;
}
@end
