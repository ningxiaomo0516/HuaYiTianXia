//
//  TXTeamTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXTeamTableViewCell.h"

@implementation TXTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)setTeamModel:(TeamModel *)teamModel{
    _teamModel = teamModel;
    [self.imagesView sd_setImageWithURL:kGetImageURL(self.teamModel.avatar) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    self.titleLabel.text = [NSString stringWithFormat:@"昵称:%@",self.teamModel.username];
    self.kidLabel.text = [NSString stringWithFormat:@"账号:%@",self.teamModel.uid];
    self.telLabel.text = [NSString stringWithFormat:@"手机号码:%@",self.teamModel.mobile];
}

- (void) initView{
    [self addSubview:self.imagesView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.kidLabel];
    [self addSubview:self.telLabel];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(@(IPHONE6_W(25)));
        make.width.height.equalTo(@(IPHONE6_W(55)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right).offset(IPHONE6_W(15));
        make.top.equalTo(self.imagesView.mas_top).offset(-2);
    }];
    
    [self.kidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imagesView.mas_bottom).offset(2);
        make.left.equalTo(self.titleLabel);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        [_imagesView lz_setCornerRadius:IPHONE6_W(55)/2.0];
    }
    return _imagesView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
    }
    return _titleLabel;
}

- (UILabel *)kidLabel{
    if (!_kidLabel) {
        _kidLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
    }
    return _kidLabel;
}

- (UILabel *)telLabel{
    if (!_telLabel) {
        _telLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
    }
    return _telLabel;
}
@end
