//
//  TXMallGoodsDetailsViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseTableViewController.h"
#import "TXNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXMallGoodsDetailsViewController : TTBaseTableViewController
- (id)initMallProductModel:(NewsRecordsModel *)productModel;

/// 页面类型:0:商城进入详情 1:农保进入详情
@property (nonatomic, assign) NSInteger pageType;
@end

NS_ASSUME_NONNULL_END
