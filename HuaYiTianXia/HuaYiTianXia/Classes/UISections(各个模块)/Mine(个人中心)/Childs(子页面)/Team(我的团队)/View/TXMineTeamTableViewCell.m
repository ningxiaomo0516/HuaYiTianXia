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


@implementation TXTeamTableViewCell

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



- (void)setTeamModel:(TeamModel *)teamModel{
    _teamModel = teamModel;
    self.teamnameLabel.text = self.teamModel.name;
    self.leadershipLabel.text = self.teamModel.leaderName;
    self.dateLabel.text = self.teamModel.createTime;
}

- (void) initView{
    [self.contentView addSubview:self.imagesRanking];
    [self.contentView addSubview:self.labelRanking];
    [self.contentView addSubview:self.teamnameLabel];
    [self.contentView addSubview:self.leadershipLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.joinButton];
    [self.imagesRanking mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self.labelRanking);
    }];
    [self.labelRanking mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.right.equalTo(self.leadershipLabel.mas_left);
    }];
    
    [self.teamnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(50)));
        make.top.equalTo(@(IPHONE6_W(10)));
    }];
    
    [self.leadershipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.teamnameLabel);
        make.centerY.equalTo(self);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.teamnameLabel);
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-10));
    }];
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.width.equalTo(@(IPHONE6_W(55)));
        make.height.equalTo(@(IPHONE6_W(25)));
        make.centerY.equalTo(self);
    }];
}

- (UIImageView *)imagesRanking{
    if (!_imagesRanking) {
        _imagesRanking = [[UIImageView alloc] init];
    }
    return _imagesRanking;
}

- (UILabel *)labelRanking{
    if (!_labelRanking) {
        _labelRanking = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        _labelRanking.textAlignment = NSTextAlignmentCenter;
    }
    return _labelRanking;
}

- (UILabel *)teamnameLabel{
    if (!_teamnameLabel) {
        _teamnameLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeScBold15];
    }
    return _teamnameLabel;
}

- (UILabel *)leadershipLabel{
    if (!_leadershipLabel) {
        _leadershipLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
    }
    return _leadershipLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium12];
    }
    return _dateLabel;
}

- (UIButton *)joinButton{
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_joinButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _joinButton.titleLabel.font = kFontSizeMedium13;//[UIFont fontWithName:@"PingFang-SC-Heavy" size:13.0];
        [_joinButton setTitle:@"+加入" forState:UIControlStateNormal];
        [_joinButton lz_setCornerRadius:IPHONE6_W(25/2.0)];
        [_joinButton setBackgroundImage:imageHexString(@"#596377") forState:UIControlStateNormal];
        [_joinButton setBackgroundImage:imageHexStringAlpha(@"#596377",0.7) forState:UIControlStateHighlighted];
    }
    return _joinButton;
}
@end
