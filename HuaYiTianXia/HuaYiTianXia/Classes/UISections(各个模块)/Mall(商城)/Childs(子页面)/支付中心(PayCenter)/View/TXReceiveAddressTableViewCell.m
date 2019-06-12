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

- (void)setAddrModel:(AddressModel *)addrModel{
    _addrModel = addrModel;
    self.nicknameLabel.text = self.addrModel.username;
    self.telphoneLabel.text = self.addrModel.telphone;
    self.addressLabel.text = self.addrModel.address;
    NSString *labelText = self.addrModel.address;
    if (addrModel.isDefault) {
        self.defaultLabel.hidden = NO;
        self.addressLabel.attributedText = [UILabel changeIndentationSpaceForLabel:labelText spaceWidth:IPHONE6_W(40.0)];
    }else{
        self.addressLabel.text = labelText;
    }
    self.addButton.userInteractionEnabled = NO;
}

- (void) initView{
    [self addSubview:self.imagesFace];
    [self addSubview:self.imagesAddr];
    [self addSubview:self.nicknameLabel];
    [self addSubview:self.imagesArrow];
    [self addSubview:self.telphoneLabel];
    [self addSubview:self.defaultLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.addButton];
    
    [self.imagesFace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(20)));
        make.top.equalTo(@(IPHONE6_W(18)));
    }];
    [self.imagesAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesFace);
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-18));
    }];
    [self.imagesArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self);
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(45)));
        make.centerY.equalTo(self.imagesFace);
    }];
    
    [self.telphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nicknameLabel.mas_right).offset(IPHONE6_W(5));
        make.centerY.equalTo(self.nicknameLabel);
    }];
    
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nicknameLabel);
        make.centerY.equalTo(self.imagesAddr);
        make.width.equalTo(@(IPHONE6_W(35)));
        make.height.equalTo(@(IPHONE6_W(18)));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nicknameLabel);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(IPHONE6_W(15));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-45));
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-15));
    }];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.top.bottom.equalTo(self);
        make.width.equalTo(@(IPHONE6_W(120)));
    }];
}

- (UILabel *)nicknameLabel{
    if (!_nicknameLabel) {
        _nicknameLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium14];
    }
    return _nicknameLabel;
}

- (UILabel *)telphoneLabel{
    if (!_telphoneLabel) {
        _telphoneLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium12];
    }
    return _telphoneLabel;
}

- (UILabel *)defaultLabel{
    if (!_defaultLabel) {
        _defaultLabel = [UILabel lz_labelWithTitle:@"默认" color:kWhiteColor font:kFontSizeMedium12];
        _defaultLabel.backgroundColor = kThemeColorHex;
        _defaultLabel.hidden = YES;
        _defaultLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _defaultLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
    }
    return _addressLabel;
}

- (UIImageView *)imagesFace{
    if (!_imagesFace) {
        _imagesFace = [[UIImageView alloc] init];
        _imagesFace.image = kGetImage(@"c31_mine_face");
    }
    return _imagesFace;
}

- (UIImageView *)imagesAddr{
    if (!_imagesAddr) {
        _imagesAddr = [[UIImageView alloc] init];
        _imagesAddr.image = kGetImage(@"c31_mine_address");
    }
    return _imagesAddr;
}

- (UIImageView *)imagesArrow{
    if (!_imagesArrow) {
        _imagesArrow = [[UIImageView alloc] init];
        _imagesArrow.image = kGetImage(@"mine_btn_enter");
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
