//
//  TXEppoTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/10.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXEppoTableViewCell.h"

@implementation TXEppoTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
        
        self.imagesView.image = kGetImage(@"base_deprecated_activity");
        self.titleLabel.text = @"农用植保A2000";
        self.subtitleLabel.text = @"全球首款IPFS矿机收发功效低、性能高";
        self.priceLabel.text = @"500000";
        self.specLabel.text = @"规格4T";
    }
    return self;
}

- (void)setRecordsModel:(NewsRecordsModel *)recordsModel{
    _recordsModel = recordsModel;
    [self.imagesView sd_setImageWithURL:[NSURL URLWithString:recordsModel.coverimg]
                       placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    self.titleLabel.text = recordsModel.title;
    self.subtitleLabel.text = recordsModel.synopsis;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@.0",recordsModel.price];
    if (recordsModel.prospec.count>0) {
        self.specLabel.text = recordsModel.prospec[0];
    }else{
        self.specLabel.text = @"";
    }
}

- (void) initView{
    [self addSubview:self.boxView];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.subtitleLabel];
    [self.boxView addSubview:self.imagesView];
    [self.boxView addSubview:self.priceLabel];
    [self.boxView addSubview:self.specLabel];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(IPHONE6_W(225)));
        make.left.equalTo(@(IPHONE6_W(8)));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-8));
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.boxView);
        make.height.equalTo(@(IPHONE6_W(135)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(7)));
        make.top.equalTo(self.imagesView.mas_bottom).offset(IPHONE6_W(10));
        make.right.equalTo(self.boxView.mas_right).offset(IPHONE6_W(-7));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE6_W(5));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(IPHONE6_W(5));
    }];
    
    [self.specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel);
        make.centerY.equalTo(self.priceLabel);
    }];
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
        [_boxView lz_setCornerRadius:3.0];
    }
    return _boxView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51  font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
    }
    return _subtitleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"#2DAFF7") font:kFontSizeMedium15];
    }
    return _priceLabel;
}

- (UILabel *)specLabel{
    if (!_specLabel) {
        _specLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
    }
    return _specLabel;
}
@end
