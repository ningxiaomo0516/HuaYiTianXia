//
//  TXRolloutTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXRolloutTableViewCell.h"

@interface TXRolloutTableViewCell ()<UITextFieldDelegate>

@end

@implementation TXRolloutTableViewCell

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
        [self initView];
    }
    return self;
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.textField];
    [self addSubview:self.sc_textField];
    [self addSubview:self.imagesArrow];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(IPHONE6_W(15)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(IPHONE6_W(15)));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(IPHONE6_W(100)));
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    [self.sc_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.right.equalTo(self.textField);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.left.right.equalTo(self.textField);
    }];

    [self.imagesArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self);
    }];
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [UITextField lz_textFieldWithPlaceHolder:@""];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.delegate = self;
        _textField.font = kFontSizeMedium15;
    }
    return _textField;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51  font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor204  font:kFontSizeMedium15];
        _subtitleLabel.hidden = YES;
    }
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

- (SCTextField *)sc_textField{
    if (!_sc_textField) {
        _sc_textField = [[SCTextField alloc] init];
        _sc_textField.placeholder = @"请输入身份证号";
        _sc_textField.font = kFontSizeMedium15;
        _sc_textField.hidden = YES;
    }
    return _sc_textField;
}

@end
