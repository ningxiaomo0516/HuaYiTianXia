//
//  TXAddressViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseTableViewController.h"
#import "TXAddressModel.h"

NS_ASSUME_NONNULL_BEGIN
//这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^SelectedAddressBlock) (AddressModel *model);
@interface TXAddressViewController : TTBaseTableViewController
/// 0:选择收货地址 1:查看收货地址列表
@property (nonatomic, assign) NSInteger pageType;
//定义一个block
@property (nonatomic, copy) SelectedAddressBlock selectedAddressBlock;

@end

NS_ASSUME_NONNULL_END
