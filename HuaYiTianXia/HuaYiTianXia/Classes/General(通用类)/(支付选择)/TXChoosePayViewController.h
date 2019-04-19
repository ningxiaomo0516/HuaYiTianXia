//
//  TXChoosePayViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/10.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^ChoosePayTypeBlock) (NewsRecordsModel *recordsModel);
@interface TXChoosePayViewController : TTBaseViewController
- (id) initNewsRecordsModel:(NewsRecordsModel *)recordsModel;
//定义一个block
@property (nonatomic, copy) ChoosePayTypeBlock typeBlock;
/// 0:商城 1:植保
@property (nonatomic, assign) NSInteger pageType;
@end

NS_ASSUME_NONNULL_END
