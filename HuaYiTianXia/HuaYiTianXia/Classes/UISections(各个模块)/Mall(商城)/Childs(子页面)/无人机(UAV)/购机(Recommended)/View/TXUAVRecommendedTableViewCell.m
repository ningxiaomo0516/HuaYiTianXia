//
//  TXUAVRecommendedTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXUAVRecommendedTableViewCell.h"

@implementation TXUAVRecommendedTableViewCell

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
        [self initView];
        self.imagesView.image = kGetImage(@"test_work");
        self.titleLabel.text = @"ROBINSON R44";
        self.subtitleLabel.text = @"高级私人座驾，高性能、低价位，预警、巡逻、监控、指挥平台指挥平台指挥平台指挥平台指挥平台";
        self.priceLabel.text = @"￥4,200,000.00";
        self.numLabel.text = @"256人付款";
    }
    return self;
}

- (void)setListModel:(MallUAVListModel *)listModel{
    _listModel = listModel;
    
    [self.imagesView sd_setImageWithURL:kGetImageURL(self.listModel.coverimg) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    self.titleLabel.text = self.listModel.title;
    self.subtitleLabel.text = self.listModel.synopsis;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.listModel.startPrice];
    self.numLabel.text = [NSString stringWithFormat:@"%@人付款",self.listModel.signup];
}

- (void) initView{
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.buyButton];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.height.width.equalTo(@(IPHONE6_W(100)));
        make.centerY.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.top.equalTo(self.imagesView.mas_top).offset(-4);
    }];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.width.equalTo(@(IPHONE6_W(70)));
        make.height.equalTo(@(IPHONE6_W(22)));
        make.bottom.equalTo(self.imagesView.mas_bottom);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.buyButton.mas_top).offset(-4);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(10);
        make.centerY.equalTo(self.priceLabel);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
        _subtitleLabel.numberOfLines = 2;
    }
    return _subtitleLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"#F56C36") font:kFontSizeMedium13];
    }
    return _priceLabel;
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
    }
    return _numLabel;
}

- (UIButton *)buyButton{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _buyButton.titleLabel.font = kFontSizeMedium12;
        [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyButton setBackgroundImage:imageHexString(@"#F56C36") forState:UIControlStateNormal];
        [_buyButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//            [weakSelf onClick:self.buyButton];
        }];
    }
    return _buyButton;
}
@end
