//
//  SCTableViewSectionHeaderView.m
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/7/21.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import "SCTableViewSectionHeaderView.h"

@implementation SCTableViewSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstraints];
        self.contentView.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void) initView{
    [self addSubview:self.lineView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.imagesArrow];
    [self addSubview:self.linerView];
    [self addSubview:self.sectionButton];
    
}

- (void)initConstraints{
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(17));
        make.left.equalTo(@(15));
        make.width.equalTo(@(3));
        make.centerY.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.lineView.mas_right).offset(14);
    }];
    
    [self.imagesArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.imagesArrow.mas_left).offset(-6);
    }];
    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kLinerViewHeight));
        make.left.bottom.right.equalTo(self);
    }];
    
    [self.sectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self);
        make.width.equalTo(@(100));
    }];
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView lz_viewWithColor:[UIColor lz_colorWithHexString:@"#26B9FE"]];
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium14];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    };
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor136 font:kFontSizeMedium12];
    };
    return _subtitleLabel;
}

- (UIImageView *)imagesArrow{
    if (!_imagesArrow) {
        _imagesArrow = [[UIImageView alloc] init];
        _imagesArrow.image = kGetImage(@"right_arrow");
        _imagesArrow.hidden = YES;
    }
    return _imagesArrow;
}

- (UIButton *)sectionButton{
    if (!_sectionButton) {
        _sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sectionButton setTitle:@"" forState:UIControlStateNormal];
    }
    return _sectionButton;
}

- (UIView *)linerView{
    if (!_linerView) {
        _linerView = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView;
}
@end
