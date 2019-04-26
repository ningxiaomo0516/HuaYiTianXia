//
//  TXAdsModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark --- 熊猫视频
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

#pragma mark --- 华翼天下 ---- 
@class TTAdsModel;
@interface TTAdsData : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) TTAdsModel *data;
@end
@interface TTAdsModel : NSObject

@property(nonatomic,copy)NSString *kid;
/// 名字
@property(nonatomic,copy)NSString *imageName;
/// 图片地址
@property(nonatomic,copy)NSString *imageUrl;
/// 倒计时
@property(nonatomic,assign)NSInteger showTime;
/// 状态 (礼包活动是否结束1:活动继续，进入礼包界面，2:活动终止,无法进入礼包界面)
@property(nonatomic,assign)NSInteger status;
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
