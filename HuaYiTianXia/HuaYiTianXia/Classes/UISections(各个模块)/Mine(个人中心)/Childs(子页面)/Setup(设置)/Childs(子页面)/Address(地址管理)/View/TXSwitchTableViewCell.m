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
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self);
    }];
    [self.isSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
    }];
}
    
    
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"设为默认地址" color:kTextColor51 font:kFontSizeMedium14];
    }
    return _titleLabel;
}

- (UISwitch *)isSwitch{
    if (!_isSwitch) {
        _isSwitch = [[UISwitch alloc] init];
        /// 设置开关处于开启时的状态
        _isSwitch.onTintColor = HexString(@"#26B9FE");
        /// 设置按钮处于关闭状态时边框的颜色
        _isSwitch.tintColor = kTextColor238;
        /// 设置开关的状态钮颜色
//        _isSwitch.thumbTintColor = kTextColor204;
    }
    return _isSwitch;
}

@end
