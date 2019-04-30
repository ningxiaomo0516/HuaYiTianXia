//
//  TXMessageChildViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/30.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseTableViewController.h"
#import "TXPushMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXMessageChildViewController : TTBaseTableViewController
- (id)initPushMessageModel:(PushMessageModel *)messageModel;
@end

NS_ASSUME_NONNULL_END
