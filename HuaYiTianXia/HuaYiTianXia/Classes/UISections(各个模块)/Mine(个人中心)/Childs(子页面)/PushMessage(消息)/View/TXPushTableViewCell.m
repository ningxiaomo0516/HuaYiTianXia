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
        self.contentView.backgroundColor = kClearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void) initView{
    
    self.boxView.backgroundColor = kWhiteColor;
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.contenLabel];
    [self.boxView addSubview:self.linerView];
    [self.boxView addSubview:self.dateLabel];
    [self.boxView addSubview:self.detailsButton];
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boxView).offset(IPHONE6_W(15));
        make.top.equalTo(self.boxView).offset(IPHONE6_W(10));
        make.right.equalTo(self.dateLabel.mas_left).offset(IPHONE6_W(-15));
        make.height.equalTo(@(IPHONE6_W(35)));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.boxView.mas_right).offset(IPHONE6_W(-15));
    }];

    [self.contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.dateLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.linerView.mas_top).offset(IPHONE6_W(-10));
    }];

    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.boxView.mas_bottom).offset(IPHONE6_W(-35));
        make.left.equalTo(self.boxView).offset(IPHONE6_W(15));
        make.right.equalTo(self.boxView.mas_right).offset(IPHONE6_W(-15));
        make.height.equalTo(@(0.5));
    }];
    
    [self.detailsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.boxView.mas_right).offset(IPHONE6_W(-15));
        make.top.equalTo(self.linerView);
        make.bottom.mas_equalTo(self);
    }];
}


- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
        [_boxView lz_setCornerRadius:5.0];
    }
    return _boxView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeScBold20];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
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
        _contenLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium15];
        _titleLabel.numberOfLines = 3;
        [_titleLabel sizeToFit];
    }
    return _contenLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
    }
    return _dateLabel;
}

- (UIButton *)detailsButton{
    if (!_detailsButton) {
        _detailsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_detailsButton setImage:kGetImage(@"mine_arrow_blue") forState:UIControlStateNormal];
        [_detailsButton setTitle:@"点击查看详情" forState:UIControlStateNormal];
        [_detailsButton setTitleColor:HexString(@"#00A7FF") forState:UIControlStateNormal];
        _detailsButton.titleLabel.font = kFontSizeMedium12;
        CGFloat spacing = 6;
        //image在左，文字在右，default
        [Utils lz_setButtonTitleWithImageEdgeInsets:_detailsButton postition:kMVImagePositionRight spacing:spacing];
    }
    return _detailsButton;
}
@end
