//
//  TTTemplateThreeCollectionViewCell.m
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/12/10.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import "TTTemplateThreeCollectionViewCell.h"

@implementation TTTemplateThreeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
//        self.imagesView.image = kGetImage(@"base_deprecated_activity");
//        self.titleLabel.text = @"无人机体验";
//        self.subtitleLabel.text = @"1小时无人机操控";
    }
    return self;
}

- (void)setupUI {
//    [self.imagesView lz_setCornerRadius:5.0];
}

- (void)setModel:(MallUAVListModel *)model{
    _model = model;
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.text = self.model.title;
    [self.imagesView sd_setImageWithURL:kGetImageURL(self.model.coverimg) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    if (model.sectionType==2) { /// 推荐
        [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.equalTo(@(190));
            make.width.equalTo(@(190));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.imagesView.mas_bottom).offset(-5);
            make.left.equalTo(@(5));
            make.right.equalTo(self);
        }];

        self.titleLabel.textColor = kWhiteColor;
        
    }else if(model.sectionType==3){ /// 热门
        
        self.titleLabel.textColor = kTextColor51;
    }else if (model.sectionType==4){ /// 体验专区
        
    }
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

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
        _subtitleLabel.numberOfLines = 1;
    }
    return _subtitleLabel;
}

- (UIImageView *)imagesViewAd{
    if (!_imagesViewAd) {
        _imagesViewAd = [[UIImageView alloc] init];
        _imagesViewAd.image = kGetImage(@"c22_mall_hot");
    }
    return _imagesViewAd;
}

- (SCCustomMarginLabel *)endAdLabel{
    if (!_endAdLabel) {
        _endAdLabel = [[SCCustomMarginLabel alloc] init];
        _endAdLabel.text = @"1";
        _endAdLabel.textAlignment = NSTextAlignmentCenter;
        _endAdLabel.backgroundColor = [kBlackColor colorWithAlphaComponent:0.4];
        _endAdLabel.textColor = kWhiteColor;
        _endAdLabel.font = kFontSizeMedium10;
        _endAdLabel.edgeInsets    = UIEdgeInsetsMake(2.f, 6.f, 2.f, 6.f); // 设置左内边距
        [_endAdLabel lz_setCornerRadius:9.0];
        [_endAdLabel sizeToFit]; // 重新计算尺寸
    }
    return _endAdLabel;
}

@end
