//
//  TXAddressAddViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AddressType){
    /// 添加地址
    AddInfo = 0,
    /// 编辑地址
    UpdateInfo
};
@interface TXAddressAddViewController : TTBaseTableViewController


///
@property (nonatomic, assign) AddressType currentType;

@end

NS_ASSUME_NONNULL_END
