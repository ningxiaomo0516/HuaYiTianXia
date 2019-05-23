//
//  TXMineTeamTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/23.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMineTeamTableViewCell.h"

@implementation TXMineTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (NSString *) isNull:(NSString *) parameter{
    //（null）判断方法
    if (parameter == nil) return @"0";
    // <null>判断方法
    if([parameter isEqual:[NSNull null]]) return @"0";
    // "<null>"判断方法
    if([parameter isEqualToString:@"<null>"]) return @"0";
    // ""判断方法
    if(parameter.length == 0) return @"0";
    return parameter;
}

- (void)setTeamModel:(MineTeamModel *)teamModel{
    _teamModel = teamModel;
    self.imagesAvatar.image = kGetImage(@"mine_icon_avatar");
    [self.imagesAvatar sd_setImageWithURL:kGetImageURL(self.teamModel.headImg) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    self.usernameLabel.text = self.teamModel.name;
    TTLog(@"self.teamModel.mobile -- %@",self.teamModel.mobile);
    TTLog(@"self.teamModel.mobile -- %@",kUserInfo.account);
    if (self.teamModel.mobile.integerValue==kUserInfo.account.integerValue) {
        self.mineLabel.text = @"(我)";
    }else{
        self.mineLabel.text = @"";
    }
    self.telphoneLabel.text = self.teamModel.mobile;
    if ([self isNull:self.teamModel.asmoney].integerValue==0) {
        self.insuredLabel.text = @"";
    }else{
        self.insuredLabel.text = [NSString stringWithFormat:@"投保金额%@元",self.teamModel.asmoney];
    }
}

- (void) initView{
    [self.contentView addSubview:self.imagesAvatar];
    [self.contentView addSubview:self.usernameLabel];
    [self.contentView addSubview:self.mineLabel];
    [self.contentView addSubview:self.telphoneLabel];
    [self.contentView addSubview:self.insuredLabel];
    
    [self.imagesAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self);
        make.width.height.equalTo(@(IPHONE6_W(41)));
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesAvatar.mas_right).offset(10);
        make.top.equalTo(self.imagesAvatar.mas_top).offset(-2);
    }];
    [self.mineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.usernameLabel);
    }];
    [self.telphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel);
        make.bottom.equalTo(self.imagesAvatar.mas_bottom).offset(2);
    }];
    [self.insuredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self);
    }];
}


- (UIImageView *)imagesAvatar{
    if (!_imagesAvatar) {
        _imagesAvatar = [[UIImageView alloc] init];
        [_imagesAvatar lz_setCornerRadius:IPHONE6_W(41)/2.0];
    }
    return _imagesAvatar;
}

- (UILabel *)usernameLabel{
    if (!_usernameLabel) {
        _usernameLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _usernameLabel;
}

- (UILabel *)mineLabel{
    if (!_mineLabel) {
        _mineLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor204 font:kFontSizeMedium12];
    }
    return _mineLabel;
}

- (UILabel *)telphoneLabel{
    if (!_telphoneLabel) {
        _telphoneLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
    }
    return _telphoneLabel;
}

- (UILabel *)insuredLabel{
    if (!_insuredLabel) {
        _insuredLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
    }
    return _insuredLabel;
}
@end
