//
//  TXCharterMachineDateView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/31.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterMachineDateView.h"

@implementation TXCharterMachineDateView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kWhiteColor;
        [self initView];
        /// 获取当前日期
        [self.startDateButton setTitle:[Utils lz_getCurrentDate] forState:UIControlStateNormal];
        /// 获取七天后的日期
        [self.endDateButton setTitle:[Utils lz_getNdayDate:7 isShowTime:NO] forState:UIControlStateNormal];
        
    }
    return self;
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.startDateButton];
    [self addSubview:self.endDateButton];
    [self addSubview:self.toLabel];
    [self addSubview:self.screeningButton];
    [self setConstraint];
}

- (void) setConstraint{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.height.equalTo(@(13));
    }];
    
    [self.startDateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.titleLabel);
        make.width.equalTo(@(90));
        make.left.equalTo(self.titleLabel.mas_right).offset(11);
    }];
    
    [self.toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.centerY.equalTo(self.startDateButton);
        make.left.equalTo(self.startDateButton.mas_right);
        make.right.equalTo(self.endDateButton.mas_left);
    }];
    
    [self.endDateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.width.equalTo(self.startDateButton);
        make.right.equalTo(self.screeningButton.mas_left).offset(-11);
    }];
    
    [self.screeningButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(@(25));
        make.width.equalTo(@(60));
        make.right.equalTo(self.mas_right).offset(-15);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"选择日期:" color:kBlackColor font:kFontSizeMedium13];
    }
    return _titleLabel;
}

- (UIButton *)startDateButton{
    if (!_startDateButton) {
        _startDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startDateButton setTitleColor:kTextColor153 forState:UIControlStateNormal];
        _startDateButton.titleLabel.font = kFontSizeMedium13;
        _startDateButton.tag = 100;
        [_startDateButton setTitle:@"开始日期" forState:UIControlStateNormal];
    }
    return _startDateButton;
}

- (UIButton *)endDateButton{
    if (!_endDateButton) {
        _endDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_endDateButton setTitleColor:kTextColor153 forState:UIControlStateNormal];
        _endDateButton.titleLabel.font = kFontSizeMedium13;
        _endDateButton.tag = 200;
        [_endDateButton setTitle:@"结束日期" forState:UIControlStateNormal];
    }
    return _endDateButton;
}

- (UILabel *)toLabel{
    if (!_toLabel) {
        _toLabel = [UILabel lz_labelWithTitle:@"至" color:kBlackColor font:kFontSizeMedium14];
        _toLabel.font = kFontSizeMedium13;
        _toLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _toLabel;
}

- (UIButton *)screeningButton{
    if (!_screeningButton) {
        _screeningButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_screeningButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _screeningButton.titleLabel.font = kFontSizeMedium14;
        [_screeningButton lz_setCornerRadius:4.0];
        [_screeningButton setTitle:@"查询" forState:UIControlStateNormal];
        [_screeningButton setBackgroundImage:kButtonColorNormal forState:UIControlStateNormal];
    }
    return _screeningButton;
}
@end
