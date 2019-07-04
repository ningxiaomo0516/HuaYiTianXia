//
//  TXChartModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/7/4.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ChartDataModel,ChartModel;
@interface TXChartModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
/// Chart模型数据
@property (nonatomic, strong) ChartDataModel *data;
@end

@interface ChartDataModel : NSObject
/// VH积分7日变动情况
@property (nonatomic, strong) NSMutableArray<ChartModel *> *VH;
/// 复投7日倍数变动（市值）
@property (nonatomic, strong) NSMutableArray<ChartModel *> *FT;
/// AH积分7日变动情况
@property (nonatomic, strong) NSMutableArray<ChartModel *> *AH;
@end

@interface  ChartModel : NSObject
/// 变动值
@property (nonatomic, copy) NSString *count;
/// 时间戳
@property (nonatomic, copy) NSString *timestamp;
@end



NS_ASSUME_NONNULL_END
