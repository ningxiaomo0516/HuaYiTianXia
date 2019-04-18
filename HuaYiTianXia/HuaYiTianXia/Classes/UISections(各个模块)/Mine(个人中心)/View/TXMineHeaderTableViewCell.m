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
    self.vrAssetsLabel.text = self.userModel.vrcurrency;
    self.arAssetsLabel.text = self.userModel.arcurrency;
    self.eqAssetsLabel.text = self.userModel.stockRight;
}

- (void) initView{
    self.imagesViewBG.hidden = YES;
    [self addSubview:self.imagesViewBG];
    [self.imagesViewBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self addSubview:self.totalAssetsLabel];
    [self addSubview:self.totalAssetsTipsLabel];
    
    [self addSubview:self.vrBoxView];
    [self addSubview:self.arBoxView];
    [self addSubview:self.eqBoxView];
    
    [self.vrBoxView addSubview:self.vrAssetsLabel];
    [self.vrBoxView addSubview:self.vrAssetsTipsLabel];
    
    [self.vrBoxView addSubview:self.linerView];
    [self.eqBoxView addSubview:self.linersView];
    
    [self.arBoxView addSubview:self.arAssetsLabel];
    [self.arBoxView addSubview:self.arAssetsTipsLabel];
    
    [self.eqBoxView addSubview:self.eqAssetsLabel];
    [self.eqBoxView addSubview:self.eqAssetsTipsLabel];
    
    [self.totalAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
    }];
    
    [self.totalAssetsTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.totalAssetsLabel);
        make.top.equalTo(self.totalAssetsLabel.mas_bottom);
    }];
    
    [self.vrBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.height.equalTo(@(IPHONE6_W(65)));
        make.width.equalTo(self.arBoxView.mas_width);
        make.right.equalTo(self.arBoxView.mas_left);
    }];
    [self.arBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.equalTo(self.eqBoxView.mas_left);
        make.width.equalTo(self.eqBoxView.mas_width);
        make.height.equalTo(self.vrBoxView);
    }];
    [self.eqBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.width.equalTo(self.vrBoxView.mas_width);
        make.height.equalTo(self.vrBoxView);
    }];
    [self.vrAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vrBoxView);
        make.bottom.equalTo(self.vrAssetsTipsLabel.mas_top).offset(-5);
    }];

    [self.vrAssetsTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.vrBoxView);
        make.bottom.equalTo(self.vrBoxView.mas_bottom).offset(-8);
    }];

    [self.arAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.arBoxView);
        make.bottom.equalTo(self.arAssetsTipsLabel.mas_top).offset(-5);
    }];

    [self.arAssetsTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.arBoxView);
        make.bottom.equalTo(self.arBoxView.mas_bottom).offset(-8);
    }];
    
    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vrBoxView.mas_right);
        make.height.equalTo(@(IPHONE6_W(37)));
        make.width.equalTo(@(IPHONE6_W(0.7)));
        make.bottom.equalTo(self.mas_bottom).offset(-12);
    }];
    [self.linersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.eqBoxView);
        make.bottom.height.width.equalTo(self.linerView);
    }];
    [self.eqAssetsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.eqBoxView);
        make.bottom.equalTo(self.eqAssetsTipsLabel.mas_top).offset(-5);
    }];
    
    [self.eqAssetsTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.eqBoxView);
        make.bottom.equalTo(self.eqBoxView.mas_bottom).offset(-8);
    }];
}

- (UIImageView *)imagesViewBG{
    if (!_imagesViewBG) {
        _imagesViewBG = [[UIImageView alloc] init];
        _imagesViewBG.image = kGetImage(@"mine_bg_images");
    }
    return _imagesViewBG;
}


- (UILabel *)totalAssetsLabel{
    if (!_totalAssetsLabel) {
        _totalAssetsLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium30];
    }
    return _totalAssetsLabel;
}

- (UILabel *)totalAssetsTipsLabel{
    if (!_totalAssetsTipsLabel) {
        _totalAssetsTipsLabel = [UILabel lz_labelWithTitle:@"我的资产" color:kTextColor102 font:kFontSizeMedium14];
    }
    return _totalAssetsTipsLabel;
}

- (UILabel *)vrAssetsLabel{
    if (!_vrAssetsLabel) {
        _vrAssetsLabel = [UILabel lz_labelWithTitle:@"0" color:kTextColor102 font:kFontSizeScBold20];
    }
    return _vrAssetsLabel;
}

- (UILabel *)vrAssetsTipsLabel{
    if (!_vrAssetsTipsLabel) {
        _vrAssetsTipsLabel = [UILabel lz_labelWithTitle:@"VH积分" color:[kTextColor102 colorWithAlphaComponent:0.5] font:kFontSizeMedium14];
    }
    return _vrAssetsTipsLabel;
}

- (UIView *)linerView {
    if (!_linerView) {
        _linerView = [UIView lz_viewWithColor:kTextColor102];
    }
    return _linerView;
}

- (UILabel *)arAssetsLabel{
    if (!_arAssetsLabel) {
        _arAssetsLabel = [UILabel lz_labelWithTitle:@"0" color:kTextColor102 font:kFontSizeScBold20];
    }
    return _arAssetsLabel;
}

- (UILabel *)arAssetsTipsLabel {
    if (!_arAssetsTipsLabel) {
        _arAssetsTipsLabel = [UILabel lz_labelWithTitle:@"AH积分" color:[kTextColor102 colorWithAlphaComponent:0.5] font:kFontSizeMedium14];
    }
    return _arAssetsTipsLabel;
}

- (UIView *)linersView {
    if (!_linersView) {
        _linersView = [UIView lz_viewWithColor:kTextColor102];
    }
    return _linersView;
}

- (UILabel *)eqAssetsLabel{
    if (!_eqAssetsLabel) {
        _eqAssetsLabel = [UILabel lz_labelWithTitle:@"0" color:kTextColor102 font:kFontSizeScBold20];
    }
    return _eqAssetsLabel;
}

- (UILabel *)eqAssetsTipsLabel {
    if (!_eqAssetsTipsLabel) {
        _eqAssetsTipsLabel = [UILabel lz_labelWithTitle:@"股权数" color:[kTextColor102 colorWithAlphaComponent:0.5] font:kFontSizeMedium14];
    }
    return _eqAssetsTipsLabel;
}


- (UIView *)vrBoxView{
    if (!_vrBoxView) {
        _vrBoxView = [UIView lz_viewWithColor:kClearColor];
    }
    return _vrBoxView;
}

- (UIView *)arBoxView {
    if (!_arBoxView) {
        _arBoxView = [UIView lz_viewWithColor:kClearColor];
    }
    return _arBoxView;
}

- (UIView *)eqBoxView{
    if (!_eqBoxView) {
        _eqBoxView = [UIView lz_viewWithColor:kClearColor];
    }
    return _eqBoxView;
}
@end
