//
//  TXAddressModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/1.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class AddressModel;
@interface TXAddressModel : NSObject
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) NSMutableArray<AddressModel *> *data;
@end

@interface AddressModel : NSObject

/// 收货地址ID
@property (nonatomic, copy) NSString *sid;
/// 收货地址
@property (nonatomic, copy) NSString *address;
/// 联系人电话
@property (nonatomic, copy) NSString *telphone;
/// 默认地址状态（0:否，1：默认）
@property (nonatomic, assign) NSInteger status;
/// 是否默认
@property (nonatomic, assign) BOOL isDefault;
///
@property (nonatomic, copy) NSString *username;
@end

@interface  TXCityModel: NSObject
/// ID
@property (nonatomic, copy) NSString *kid;
/// 编码
@property (nonatomic, copy) NSString *code;
/// 城市
@property (nonatomic, copy) NSString *areaName;
/// 级别
@property (nonatomic, copy) NSString *level;
/// 父级ID
@property (nonatomic, copy) NSString *parentId;
@end

@interface TXCityData : NSObject
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) NSMutableArray<TXCityModel *> *list;
@end
NS_ASSUME_NONNULL_END
