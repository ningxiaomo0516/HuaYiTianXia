//
//  TXAddressTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXAddressTableViewCell.h"

@implementation TXAddressTableViewCell

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
//        self.titleLabel.text = @"佐伊";
//        self.telLabel.text = @"13512340987";
//        NSString *labelText = @"四川省 成都市 双流县 华阳镇街道 比海运的一单元54564";
//        if (addressModel.isDefault) {
//            self.defaultLabel.hidden = NO;
//            self.addressLabel.attributedText = [UILabel changeIndentationSpaceForLabel:labelText spaceWidth:IPHONE6_W(35.0)];
//        }else{
//            if (addressModel.isDefault) {
//                labelText = @"四川省 成都市 武侯区 天和东街29号";
//            }else{
//                labelText = @"四川省 成都市 武侯区 桂溪街道 天和东街29号 22栋27楼48号 如奔赴古城道路上阳光温柔灿烂不用时刻联系";
//            }
//            self.addressLabel.text = labelText;
//        }
    }
    return self;
}

- (void)setAddressModel:(AddressModel *)addressModel{
    _addressModel = addressModel;
    self.titleLabel.text = addressModel.username;
    self.telLabel.text = addressModel.telphone;
    NSString *labelText = addressModel.address;
    if (addressModel.isDefault) {
        self.defaultLabel.hidden = NO;
        self.addressLabel.attributedText = [UILabel changeIndentationSpaceForLabel:labelText spaceWidth:IPHONE6_W(40.0)];
    }else{
        self.addressLabel.text = labelText;
    }
}

- (void) initView{
    [self addSubview:self.imagesFace];
    [self addSubview:self.imagesAddr];
    [self addSubview:self.titleLabel];
    [self addSubview:self.telLabel];
    [self addSubview:self.defaultLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.imagesArrow];
    
    [self.imagesFace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(20)));
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.imagesAddr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(20)));
        make.centerY.equalTo(self.addressLabel);
    }];
    [self.imagesArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self.telLabel);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(45)));
        make.top.equalTo(@(IPHONE6_W(15)));
    }];
    
    [self.telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(IPHONE6_W(5));
        make.bottom.equalTo(self.titleLabel);
    }];
    
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE6_W(6));
        make.width.equalTo(@(IPHONE6_W(35)));
        make.height.equalTo(@(IPHONE6_W(18)));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE6_W(6));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-45));
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-15));
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium14];
    }
    return _titleLabel;
}

- (UILabel *)telLabel{
    if (!_telLabel) {
        _telLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium12];
    }
    return _telLabel;
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

@end
