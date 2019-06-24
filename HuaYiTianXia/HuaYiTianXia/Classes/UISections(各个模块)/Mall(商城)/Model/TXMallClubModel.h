//
//  TXMallClubModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/12.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TXMallClubDataModel;
@interface TXMallClubModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) TXMallClubDataModel *data;

@end

@interface TXMallClubDataModel : NSObject
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
@property (nonatomic, strong) NSMutableArray<MallClubListModel *> *list;
@end

NS_ASSUME_NONNULL_END
