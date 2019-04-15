//
//  TXReceiveAddressTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXReceiveAddressTableViewCell.h"

@implementation TXReceiveAddressTableViewCell

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
    [self addSubview:self.imagesView];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.telphoneLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.imagesArrow];
    [self addSubview:self.addButton];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(35)));
        make.top.equalTo(@(IPHONE6_W(15)));
    }];
    
    [self.telphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nicknameLabel);
        make.left.equalTo(self.nicknameLabel.mas_right).offset(IPHONE6_W(20));
    }];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(13)));
        make.bottom.equalTo(@(IPHONE6_W(-15)));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imagesView);
        make.left.equalTo(self.nicknameLabel);
    }];
    
    [self.imagesArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self);
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.top.bottom.equalTo(self);
        make.width.equalTo(@(IPHONE6_W(120)));
    }];
}

- (UIImageView *)imagesView {
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.image = kGetImage(@"c16_btn_address");
    }
    return _imagesView;
}

- (UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium14];
    }
    return _nicknameLabel;
}

- (UILabel *)telphoneLabel{
    if (!_telphoneLabel) {
        _telphoneLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium14];
    }
    return _telphoneLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium14];
    }
    return _addressLabel;
}

- (UIImageView *)imagesArrow{
    if (!_imagesArrow) {
        _imagesArrow = [[UIImageView alloc] init];
        _imagesArrow.image = kGetImage(@"right_arrow");
    }
    return _imagesArrow;
}

- (TTImageButton *)addButton{
    if (!_addButton) {
        _addButton = [[TTImageButton alloc] init];
        [_addButton setImage:kGetImage(@"c31_tianjia") forState:UIControlStateNormal];
        [_addButton setTitleColor:kTextColor128 forState:UIControlStateNormal];
        [_addButton setTitle:@"添加收货地址" forState:UIControlStateNormal];
        _addButton.style = kTTButtonStyleTop;
        _addButton.titleLabel.font = kFontSizeMedium15;
        _addButton.hidden = YES;
    }
    return _addButton;
}
@end
