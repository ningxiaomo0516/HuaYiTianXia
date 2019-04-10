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


/// 消息提示
@property(nonatomic, copy)NSString* message;
/// 错误Code
@property(nonatomic, assign)NSInteger errorcode;
/// 错误Code
@property(nonatomic, copy)NSString *obj;


@end

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

NS_ASSUME_NONNULL_END
