//
//  TXClubCollectionFooterView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/21.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXClubCollectionFooterView.h"

@implementation TXClubCollectionFooterView
//底部视图的缓存池标示
+ (NSString *)footerViewIdentifier{
    static NSString *footerIdentifier = @"TXClubCollectionFooterView";
    return footerIdentifier;
}
//获取底部视图对象
+ (instancetype)footerViewWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    TXClubCollectionFooterView *footerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:[TXClubCollectionFooterView footerViewIdentifier] forIndexPath:indexPath];
    return footerView;
    
}
//注册了底部视图后，当缓存池中没有底部视图的对象时候，自动调用alloc/initWithFrame创建
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kViewColorNormal;
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.numberOfLines = 0;
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.textColor = kColorWithRGB(211, 0, 0);
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}
@end
