//
//  TXRegisterTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXRegisterTableViewCell.h"

@interface TXRegisterTableViewCell ()<UITextFieldDelegate>

@end

@implementation TXRegisterTableViewCell

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
    [self addSubview:self.linerView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(IPHONE6_W(15)));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(105)));
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
    }];
    
    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
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
        _textField.clearButtonMode = UITextFieldViewModeAlways;
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

@end
