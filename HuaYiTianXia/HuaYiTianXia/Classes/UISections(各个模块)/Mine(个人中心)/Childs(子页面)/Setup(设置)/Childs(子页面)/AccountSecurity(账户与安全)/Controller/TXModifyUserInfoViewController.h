//
//  TXModifyUserInfoViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^ChangeInfoBlock) (NSString *text);
@interface TXModifyUserInfoViewController : TTBaseViewController
@property (nonatomic, copy) NSString *tabBarTitle;
@property (nonatomic, copy) NSString *nickname;
//定义一个block
@property (nonatomic, copy) ChangeInfoBlock block;

- (void) updateUserInfoDataRequest:(NSString *) imageURL;
@end

NS_ASSUME_NONNULL_END
