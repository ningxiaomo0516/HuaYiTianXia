//
//  TXWalletModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/1.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class WalletListModel,WalletModel;
@interface TXWalletModel : NSObject
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) WalletListModel *data;
@end

@interface WalletListModel : NSObject
/// 页码
@property (nonatomic, copy) NSString *currentPage;
/// 总页数
@property (nonatomic, copy) NSString *totalPages;
/// 每页条数
@property (nonatomic, copy) NSString *size;
/// 总条数
@property (nonatomic, copy) NSString *totalSize;
@property (nonatomic, strong) NSMutableArray<WalletModel *> *list;
@end

@interface WalletModel : NSObject
/// 价格
@property (nonatomic, copy) NSString *price;
/// 日期时间
@property (nonatomic, copy) NSString *date;
/// 产品标题
@property (nonatomic, copy) NSString *title;
/// 类型(购买类型)
@property (nonatomic, copy) NSString *typeName;
/// 类型---
@property (nonatomic, copy) NSString *yuanmoney;

/// 股权ID
@property (nonatomic, copy) NSString *kid;
/// 股权总数
@property (nonatomic, copy) NSString *stockRight;


/// 股权总数
@property (nonatomic, copy) NSString *mobile;


/// 页面类型0:股权 1:转出记录 2:转入记录
@property (nonatomic, assign) NSInteger pageType;
@end
NS_ASSUME_NONNULL_END
