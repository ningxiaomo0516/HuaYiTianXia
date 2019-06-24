//
//  TXClubCollectionHeaderView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/21.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXClubCollectionHeaderView.h"

@implementation TXClubCollectionHeaderView
//顶部视图的缓存池标示
+ (NSString *)headerViewIdentifier{
    static NSString *headerIdentifier = @"TXClubCollectionHeaderView";
    return headerIdentifier;
}
//获取顶部视图对象
+ (instancetype)headerViewWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    //从缓存池中寻找顶部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的顶部视图返回
    TXClubCollectionHeaderView *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[TXClubCollectionHeaderView headerViewIdentifier] forIndexPath:indexPath];
    return headerView;
    
}
//注册了顶部视图后，当缓存池中没有顶部视图的对象时候，自动调用alloc/initWithFrame创建
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kViewColorNormal;
        [self addSubview:self.imagesView];
        [self addSubview:self.textLabel];
        [self addSubview:self.moreButton];
        [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.centerY.equalTo(self);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.imagesView.mas_right).offset(5);
        }];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(100));
            make.right.equalTo(self.mas_right).offset(-15);
        }];
    }
    return self;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = kFontSizeMedium15;
        _textLabel.textColor = kColorWithRGB(211, 0, 0);
    }
    return _textLabel;
}

- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.titleLabel.font = kFontSizeMedium12;
        [_moreButton setTitle:@"更多>" forState:UIControlStateNormal];
        _moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_moreButton setTitleColor:kTextColor153  forState:UIControlStateNormal];
        [_moreButton setTitleColor:kTextColor102  forState:UIControlStateHighlighted];
    }
    return _moreButton;
}
@end
