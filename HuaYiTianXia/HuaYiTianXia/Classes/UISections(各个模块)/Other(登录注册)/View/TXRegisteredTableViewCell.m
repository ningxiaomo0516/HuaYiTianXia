//
//  TXRegisteredTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXRegisteredTableViewCell.h"

@interface TXRegisteredTableViewCell ()<UITextFieldDelegate>

@end

@implementation TXRegisteredTableViewCell

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
    [self addSubview:self.textField];
    [self addSubview:self.codeBtn];
    [self addSubview:self.linerView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(IPHONE6_W(15)));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(105)));
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.codeBtn.mas_left).offset(IPHONE6_W(-15));
    }];
    
    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self);
        make.width.equalTo(@(IPHONE6_W(102)));
        make.height.equalTo(@(IPHONE6_W(38)));
    }];
}

- (UIView *)linerView{
    if (!_linerView) {
        _linerView = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView;
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

- (UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [Utils lz_setButtonWithBGImage:_codeBtn isRadius:YES];
        [_codeBtn setBackgroundImage:imageColor(kWhiteColor) forState:UIControlStateNormal];
        [_codeBtn setBackgroundImage:imageColor(kWhiteColor) forState:UIControlStateHighlighted];
        [_codeBtn setTitleColor:kThemeColorHex forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = kFontSizeMedium13;
        [_codeBtn lz_setCornerRadius:5.0];
        [_codeBtn setBorderColor:kThemeColorHex];
        [_codeBtn setBorderWidth:1.0];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    return _codeBtn;
}

@end
