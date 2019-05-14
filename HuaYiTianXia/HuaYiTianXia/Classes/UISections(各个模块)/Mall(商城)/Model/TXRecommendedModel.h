//
//  TXRecommendedModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface RecommendChildModel : NSObject
/// 信息ID
@property (nonatomic, copy) NSString *kid;
/// 标题
@property (nonatomic, copy) NSString *title;
/// 起始价格
@property (nonatomic, copy) NSString *startPrice;
/// 结束价格（此字段为预留字段，先阶段可不适用）
@property (nonatomic, copy) NSString *endPrice;
/// 已报名人数
@property (nonatomic, copy) NSString *signup;
/// 咨询电话
@property (nonatomic, copy) NSString *phone;
/// 发布时间（未格式化，后期根据需求格式化）
@property (nonatomic, copy) NSString *datatime;
/// 简介
@property (nonatomic, copy) NSString *synopsis;
/// 定金 (金额大于0时，需调用支付接口完成支付功能)
@property (nonatomic, copy) NSString *deposit;
/// 报名上限人数
@property (nonatomic, copy) NSString *peoplelimit;
/// 培训地址
@property (nonatomic, copy) NSString *address;
/// 培训开始时间（未格式化，后期根据需求格式化）
@property (nonatomic, copy) NSString *startTime;
/// 培训结束时间（未格式化，后期根据需求格式化）
@property (nonatomic, copy) NSString *endTime;
/// banner 集合
@property (nonatomic, strong) NSMutableArray<NewsBannerModel *> *banners;
@end

@interface TXRecommendedModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) RecommendChildModel *data;
@end

NS_ASSUME_NONNULL_END
