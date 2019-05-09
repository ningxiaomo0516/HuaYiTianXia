//
//  TXMineBannerCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMineBannerCollectionViewCell.h"

@implementation TXMineBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
        self.titleLabel.text = @"100张电影票 请你看大片!";
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = kWhiteColor;
        [self initView];
    }
    return self;
}

- (void)setBannerModel:(NewsBannerModel *)bannerModel{
    _bannerModel = bannerModel;
    NSString *imageURL = @"";
    if (kStringIsEmpty(bannerModel.img)) {
        imageURL = bannerModel.imageText;
    }else{
        imageURL = bannerModel.img;
    }
//    tools.imagesView.image = kGetImage(@"base_deprecated_activity");
    [self.imagesView sd_setImageWithURL:kGetImageURL(imageURL)
                       placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    if (bannerModel.isBannerTitle) {
        self.titleLabel.text = bannerModel.title;
    }else{
        self.titleLabel.text = @"";
    }
}

- (void) initView {
    [self.contentView addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.contentView addSubview:self.boxView];
    [self.boxView addSubview:self.imagesViewBottom];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.countLabel];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@(40));
    }];
    [self.imagesViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.boxView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerY.equalTo(self.boxView);
        make.right.equalTo(self.countLabel.mas_left);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.boxView.mas_right).offset(-15);
        make.centerY.equalTo(self.boxView);
        make.width.equalTo(@(IPHONE6_W(30)));
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
//        _imagesView.contentMode = UIViewContentModeScaleAspectFit;;
//        _imagesView.clipsToBounds = YES;
    }
    return _imagesView;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kClearColor];
        _boxView.hidden = YES;
    }
    return _boxView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium15];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UIImageView *)imagesViewBottom{
    if (!_imagesViewBottom) {
        _imagesViewBottom = [[UIImageView alloc] init];
        _imagesViewBottom.image = kGetImage(@"live_banner_bottom");
    }
    return _imagesViewBottom;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium12];
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
@end
