//
//  TXSwitchTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXSwitchTableViewCell.h"

@implementation TXSwitchTableViewCell

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
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.isSwitch];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.helpButton];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self);
    }];
    [self.isSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
    }];
    [self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.helpButton.mas_left).offset(-5);
    }];
}

- (void) showlabel{
    self.subtitleLabel.text = @"当前VH不足";
    self.helpButton.hidden = NO;
    self.subtitleLabel.hidden = NO;
    self.isSwitch.hidden = YES;
}
    
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"设为默认地址" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UISwitch *)isSwitch{
    if (!_isSwitch) {
        _isSwitch = [[UISwitch alloc] init];
        /// 设置开关处于开启时的状态
        _isSwitch.onTintColor = kThemeColorHex;
        /// 设置按钮处于关闭状态时边框的颜色
        _isSwitch.tintColor = kTextColor238;
        /// 设置开关的状态钮颜色
//        _isSwitch.thumbTintColor = kTextColor204;
    }
    return _isSwitch;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kPriceColor font:kFontSizeMedium13];
        _subtitleLabel.hidden = YES;
    }
    return _subtitleLabel;
}

- (UIButton *)helpButton{
    if (!_helpButton) {
        _helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpButton setImage:kGetImage(@"帮助中心") forState:UIControlStateNormal];
        _helpButton.hidden = YES;
    }
    return _helpButton;
}
@end
