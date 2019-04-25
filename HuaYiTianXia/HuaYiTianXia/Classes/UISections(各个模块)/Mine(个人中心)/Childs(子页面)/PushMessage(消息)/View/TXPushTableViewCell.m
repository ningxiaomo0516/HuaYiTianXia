//
//  TXPushTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPushTableViewCell.h"

@implementation TXPushTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kViewColorNormal;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void) initView{
    [self.contentView addSubview:self.boxView];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.contenLabel];
    [self.boxView addSubview:self.linerView];
    [self.boxView addSubview:self.dateLabel];
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(@(IPHONE6_W(15)));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
    }];
    
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.boxView).offset(IPHONE6_W(15));
//        make.right.equalTo(self.dateLabel.mas_left).offset(IPHONE6_W(-15));
//        make.height.equalTo(@(IPHONE6_W(35)));
//    }];
    
//    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.titleLabel);
//        make.right.equalTo(self.boxView.mas_right).offset(IPHONE6_W(-15));
//    }];
//
//    [self.contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.left.equalTo(self.titleLabel);
//        make.bottom.equalTo(self.linerView.mas_top).offset(IPHONE6_W(-10));
//    }];
//
//    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.boxView.mas_bottom).offset(IPHONE6_W(-30));
//        make.left.equalTo(self.boxView).offset(IPHONE6_W(15));
//        make.right.equalTo(self.boxView.mas_right).offset(IPHONE6_W(-15));
//        make.height.equalTo(@(0.5));
//    }];
}


- (UIView *)boxView{
    if (_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
        [_boxView lz_setCornerRadius:5.0];
    }
    return _boxView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeScBold20];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UIView *)linerView{
    if (!_linerView) {
        _linerView = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView;
}

- (UILabel *)contenLabel{
    if (!_contenLabel) {
        _contenLabel = [[UILabel alloc] init];
    }
    return _contenLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
    }
    return _dateLabel;
}
@end
