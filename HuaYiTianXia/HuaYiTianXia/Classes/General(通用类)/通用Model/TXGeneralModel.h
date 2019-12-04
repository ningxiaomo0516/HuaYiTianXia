//
//  TXGeneralModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXGeneralModel : NSObject
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* imageText;
@property(nonatomic, copy)NSString* showClass;
@property(nonatomic, assign)NSInteger index;
/// 礼包ID
@property(nonatomic, copy)NSString* libaoId;


/// 消息提示
@property(nonatomic, copy)NSString* message;
/// 错误Code
@property(nonatomic, assign)NSInteger errorcode;
/// 支付宝支付的时候取所需签名,微信支付时需要将字符串转为字典后在使用
@property(nonatomic, copy)NSString *obj;

@end


/// 微信支付的时候使用的订单Model
@interface OrderData : NSObject
/// 消息提示
@property(nonatomic, copy)NSString* code;
@property(nonatomic, copy)NSString* appid;
@property(nonatomic, copy)NSString* sign;
@property(nonatomic, copy)NSString* prepayid;
@property(nonatomic, copy)NSString* partnerid;
@property(nonatomic, copy)NSString* info;
@property(nonatomic, copy)NSString* timestamp;
@property(nonatomic, copy)NSString* noncestr;
@end

@class RegionalModel;
@interface RegionalPromptModel : NSObject
/// 消息提示
@property(nonatomic, copy)NSString* message;
/// 错误Code
@property(nonatomic, assign)NSInteger errorcode;
/// 区域提示Model
@property(nonatomic, strong)RegionalModel *data;
@end

@interface RegionalModel : NSObject
/// 消息提示
@property(nonatomic, copy)NSString* kid;
/// 错误Code
@property(nonatomic, copy)NSString *regional;

@property(nonatomic, copy)NSString *regionalagentMsg;
@end


@interface RealnameModel : NSObject
/// 消息提示
@property(nonatomic, copy)NSString* message;
/// 错误Code
@property(nonatomic, assign)NSInteger errorcode;

@end
NS_ASSUME_NONNULL_END
