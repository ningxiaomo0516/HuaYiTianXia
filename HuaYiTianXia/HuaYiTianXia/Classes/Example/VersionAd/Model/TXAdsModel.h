//
//  TXAdsModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXAdsModel : NSObject
@property(nonatomic,copy)NSString *kid;
/// 名字
@property(nonatomic,copy)NSString *imageName;
/// 图片地址
@property(nonatomic,copy)NSString *imageUrl;
/// 倒计时
@property(nonatomic,assign)NSInteger showTime;
/// 状态
@property(nonatomic,assign)NSInteger state;
/// 类型
@property(nonatomic,assign)NSInteger type;
/// 排序
@property(nonatomic,assign)NSInteger sort;
/// 跳转类型
@property(nonatomic,assign)NSInteger jumpType;
/// 跳转地址
@property(nonatomic,copy)NSString *jumpUrl;

@end

NS_ASSUME_NONNULL_END
