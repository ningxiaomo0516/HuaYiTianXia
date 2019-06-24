//
//  TXClubCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/21.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXClubCollectionViewCell.h"

@implementation TXClubCollectionViewCell
/// 方块视图的缓存池标示
+ (NSString *)reuseIdentifier{
    static NSString *reuseIdentifier = @"CollectionViewCellIdentifier";
    return reuseIdentifier;
}

//获取方块视图对象
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    TXClubCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:[TXClubCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    return cell;
}

//注册了方块视图后，当缓存池中没有底部视图的对象时候，自动调用alloc/initWithFrame创建
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = kWhiteColor;
        [self setupUI];
    }
    return self;
}


- (void)setModel:(MallClubListModel *)model{
    _model = model;
    self.titleLabel.text = self.model.title;
    self.subtitleLabel.text = self.model.synopsis;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",self.model.startPrice];
    [self.imagesView sd_setImageWithURL:kGetImageURL(self.model.coverimg) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
}

- (void)setupUI {
    [self lz_setCornerRadius:5.0];
    
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@(IPHONE6_W(145)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagesView.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.left.equalTo(@(5));
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
}


#pragma mark -- setter getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
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

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:kPriceColor font:kFontSizeMedium15];
        _priceLabel.numberOfLines = 1;
    }
    return _priceLabel;
}
@end
