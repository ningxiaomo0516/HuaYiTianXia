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
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
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
}

- (void) initView {
    [self.contentView addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
//        _imagesView.contentMode = UIViewContentModeScaleAspectFill;;
//        _imagesView.clipsToBounds = YES;
    }
    return _imagesView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
@end
