//
//  TXMineHeaderTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMineHeaderTableViewCell.h"

@implementation TXMineHeaderTableViewCell

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
    }
    return self;
}

- (void)setUserModel:(TTUserModel *)userModel{
    _userModel = userModel;
    [self initView];
    self.totalAssetsLabel.text = self.userModel.totalAssets;
    self.vhAssetsLabel.text = self.userModel.vrcurrency;
    self.ahAssetsLabel.text = self.userModel.arcurrency;
    self.eqAssetsLabel.text = self.userModel.stockRight;
    self.vhAssetsTips.text = [NSString stringWithFormat:@"农保可用%@",self.userModel.exclusiveVH];
}

- (void) initView{
    [self addSubview:self.totalAssetsLabel];
    [self addSubview:self.totalAssetsTipsLabel];
    
    [self addSubview:self.vhBoxView];
    [self addSubview:self.ahBoxView];
    [self addSubview:self.eqBoxView];
    [self.vhBoxView addSubview:self.vhAssetsLabel];
    [self.vhBoxView addSubview:self.vhAssetsTipsLabel];
    [self.vhBoxView addSubview:self.vhAssetsTips];
    
    [self.ahBoxView addSubview:self.ahAssetsLabel];
    [self.ahBoxView addSubview:self.ahAssetsTipsLabel];
    [self.ahBoxView addSubview:self.ahAssetsTips];
    
    [self.eqBoxView addSubview:self.eqAssetsLabel];
    [self.eqBoxView addSubview:self.eqAssetsTipsLabel];
    [self.eqBoxView addSubview:self.eqAssetsTips];
    
    CGFloat margin = IPHONE6_W(6);
    [self.totalAssetsTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(margin));
        make.centerX.equalTo(self);
    }];
    
    [self.totalAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.totalAssetsTipsLabel);
        make.top.equalTo(self.totalAssetsTipsLabel.mas_bottom);
    }];
    
    [self.vhBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.height.equalTo(@(IPHONE6_W(65)));
        make.width.equalTo(self.ahBoxView.mas_width);
        make.right.equalTo(self.ahBoxView.mas_left);
    }];
    [self.ahBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self.eqBoxView.mas_left);
        make.width.equalTo(self.eqBoxView.mas_width);
        make.height.equalTo(self.vhBoxView);
    }];
    [self.eqBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.width.equalTo(self.vhBoxView.mas_width);
        make.height.equalTo(self.vhBoxView);
    }];
    
    [self.vhAssetsTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vhBoxView);
        make.top.equalTo(@(margin));
    }];
    
    [self.vhAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.vhBoxView);
    }];
    
    [self.vhAssetsTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vhBoxView);
        make.bottom.equalTo(self.vhBoxView.mas_bottom).offset(-margin);
    }];

    [self.ahAssetsTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.ahBoxView);
        make.top.equalTo(@(margin));
    }];
    
    [self.ahAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.ahBoxView);
    }];
    
    [self.ahAssetsTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.ahBoxView);
        make.centerY.equalTo(self.vhAssetsTips);
    }];
    
    [self.eqAssetsTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.eqBoxView);
        make.top.equalTo(@(margin));
    }];
    [self.eqAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.eqBoxView);
    }];
    [self.eqAssetsTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.eqBoxView);
        make.centerY.equalTo(self.vhAssetsTips);
    }];
}

- (UILabel *)totalAssetsLabel{
    if (!_totalAssetsLabel) {
        _totalAssetsLabel = [UILabel lz_labelWithTitle:@"" color:kThemeColorHex font:kFontSizeScBold24];
    }
    return _totalAssetsLabel;
}

- (UILabel *)totalAssetsTipsLabel{
    if (!_totalAssetsTipsLabel) {
        _totalAssetsTipsLabel = [UILabel lz_labelWithTitle:@"我的资产" color:kTextColor102 font:kFontSizeMedium15];
    }
    return _totalAssetsTipsLabel;
}

- (UILabel *)vhAssetsLabel{
    if (!_vhAssetsLabel) {
        _vhAssetsLabel = [UILabel lz_labelWithTitle:@"0" color:kThemeColorHex font:kFontSizeMedium16];
    }
    return _vhAssetsLabel;
}

- (UILabel *)vhAssetsTipsLabel{
    if (!_vhAssetsTipsLabel) {
        _vhAssetsTipsLabel = [UILabel lz_labelWithTitle:@"VH" color:kTextColor51 font:kFontSizeMedium12];
    }
    return _vhAssetsTipsLabel;
}

- (UILabel *)vhAssetsTips{
    if (!_vhAssetsTips) {
        _vhAssetsTips = [UILabel lz_labelWithTitle:@"农保可用4000" color:kTextColor102 font:kFontSizeMedium10];
    }
    return _vhAssetsTips;
}

- (UILabel *)ahAssetsLabel{
    if (!_ahAssetsLabel) {
        _ahAssetsLabel = [UILabel lz_labelWithTitle:@"0" color:kThemeColorHex font:kFontSizeMedium16];
    }
    return _ahAssetsLabel;
}

- (UILabel *)ahAssetsTipsLabel {
    if (!_ahAssetsTipsLabel) {
        _ahAssetsTipsLabel = [UILabel lz_labelWithTitle:@"AH" color:kTextColor51 font:kFontSizeMedium12];
    }
    return _ahAssetsTipsLabel;
}

- (UILabel *)ahAssetsTips{
    if (!_ahAssetsTips) {
        _ahAssetsTips = [UILabel lz_labelWithTitle:@"-" color:kTextColor102 font:kFontSizeMedium10];
    }
    return _ahAssetsTips;
}

- (UILabel *)eqAssetsLabel{
    if (!_eqAssetsLabel) {
        _eqAssetsLabel = [UILabel lz_labelWithTitle:@"0" color:kThemeColorHex font:kFontSizeMedium16];
    }
    return _eqAssetsLabel;
}

- (UILabel *)eqAssetsTipsLabel {
    if (!_eqAssetsTipsLabel) {
        _eqAssetsTipsLabel = [UILabel lz_labelWithTitle:@"股权数" color:kTextColor51 font:kFontSizeMedium12];
    }
    return _eqAssetsTipsLabel;
}

- (UILabel *)eqAssetsTips{
    if (!_eqAssetsTips) {
        _eqAssetsTips = [UILabel lz_labelWithTitle:@"-" color:kTextColor102 font:kFontSizeMedium10];
    }
    return _eqAssetsTips;
}


- (UIView *)vhBoxView{
    if (!_vhBoxView) {
        _vhBoxView = [UIView lz_viewWithColor:kClearColor];
    }
    return _vhBoxView;
}

- (UIView *)ahBoxView {
    if (!_ahBoxView) {
        _ahBoxView = [UIView lz_viewWithColor:kClearColor];
    }
    return _ahBoxView;
}

- (UIView *)eqBoxView{
    if (!_eqBoxView) {
        _eqBoxView = [UIView lz_viewWithColor:kClearColor];
    }
    return _eqBoxView;
}
@end
