//
//  TXMainModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/9/5.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MainModel,MainListModel;
@interface TXMainModel : NSObject

/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) MainModel *data;
@end

@interface MainModel : NSObject

@property (nonatomic, strong) NSMutableArray<MainListModel *> *list;
@property (nonatomic, strong) NSMutableArray<NewsBannerModel *> *banners;
@end

@interface MainListModel : NSObject
@property (nonatomic, copy) NSString *kid;
/// 折扣
@property (nonatomic, copy) NSString *referenceprice;
/// 价格
@property (nonatomic, copy) NSString *price;
/// 目的地
@property (nonatomic, copy) NSString *destination;
/// 出发地
@property (nonatomic, copy) NSString *origin;
/// 日期时间
@property (nonatomic, copy) NSString *depTime;
@property (nonatomic, copy) NSString *aircraftImg;
@end

NS_ASSUME_NONNULL_END
