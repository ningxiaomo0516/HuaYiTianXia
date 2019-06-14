//
//  TXMembersCollectionViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^THToolsTypeBlock) (TXGeneralModel *model);
@interface TXMembersCollectionViewCell : UICollectionViewCell
//定义一个block
@property (nonatomic, copy) THToolsTypeBlock typeBlock;
@end

@interface MembersCollectionViewCell : UICollectionViewCell
/// 图片
@property (nonatomic, strong) UIImageView *imagesView;
@end

NS_ASSUME_NONNULL_END
