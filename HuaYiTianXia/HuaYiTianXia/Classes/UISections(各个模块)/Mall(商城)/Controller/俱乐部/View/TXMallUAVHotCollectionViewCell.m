//
//  TXMallUAVHotCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMallUAVHotCollectionViewCell.h"

@implementation TXMallUAVHotCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
        self.imagesView.image = kGetImage(@"base_deprecated_activity");
        self.titleLabel.text = @"无人机体验";
        [self.contentView lz_setCornerRadius:5.0];
    }
    return self;
}

- (void)setModel:(MallUAVListModel *)model{
    _model = model;
    self.titleLabel.text = self.model.title;
    [self.imagesView sd_setImageWithURL:kGetImageURL(self.model.coverimg) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
}

- (void)setupUI {
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.titleLabel];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-30);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.top.equalTo(self.imagesView.mas_bottom);
        make.left.equalTo(@(5));
    }];
}

#pragma mark -- setter getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium14];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.contentMode = UIViewContentModeScaleAspectFill;
        _imagesView.clipsToBounds = YES;
    }
    return _imagesView;
}
@end
