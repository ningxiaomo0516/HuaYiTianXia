//
//  TXClubCollectionFooterView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/21.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXClubCollectionFooterView : UICollectionReusableView
@property (strong, nonatomic) UILabel *textLabel;
//底部视图的缓存池标示
+ (NSString *)footerViewIdentifier;
//获取底部视图对象
+ (instancetype)footerViewWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
