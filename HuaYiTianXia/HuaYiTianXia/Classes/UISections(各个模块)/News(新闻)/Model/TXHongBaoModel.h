//
//  TXHongBaoModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/13.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HongBaoModel;
@interface TXHongBaoModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) HongBaoModel *data;
@end

@interface HongBaoModel : NSObject
@property (nonnull, strong) NSString *redpacketstart;
@property (nonnull, strong) NSString *redpacketend;
@end
NS_ASSUME_NONNULL_END
