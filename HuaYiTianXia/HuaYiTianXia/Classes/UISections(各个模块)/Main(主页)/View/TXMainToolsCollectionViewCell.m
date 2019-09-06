//
//  TXMainToolsCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/9/4.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMainToolsCollectionViewCell.h"

@implementation TXMainToolsCollectionViewCell
/// 方块视图的缓存池标示
+ (NSString *)reuseIdentifier{
    static NSString *reuseIdentifier = @"TXMainToolsCollectionViewCell";
    return reuseIdentifier;
}

//获取方块视图对象
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    TXMainToolsCollectionViewCell *tools=[collectionView dequeueReusableCellWithReuseIdentifier:[TXMainToolsCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    return tools;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kClearColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}
@end
