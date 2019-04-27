//
//  TXGiftDataModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/27.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GiftDataModel,GiftModel;
@interface TXGiftDataModel : NSObject
//// 详情接口
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
/// records 新闻列表集合
@property (nonatomic, strong) GiftDataModel *data;
@end

@interface GiftDataModel : NSObject
/// 当前页
@property (nonatomic, assign) NSInteger current;
/// 总页数
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger searchCount;
/// 每页条数
@property (nonatomic, assign) NSInteger size;
/// 总条数
@property (nonatomic, assign) NSInteger total;
/// records 新闻列表集合
@property (nonatomic, strong) NSMutableArray<GiftModel *> *records;
@end

@interface GiftModel : NSObject
@property (nonatomic, copy) NSString *pname;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *datatime;
@end
NS_ASSUME_NONNULL_END
