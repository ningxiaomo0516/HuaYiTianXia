//
//  AppDelegate+TXReachability.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/7.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (TXReachability)
/// 监听苹果官方 Reachability
- (void) listenNetWorkReachabilityStatus;
/// 监听AFN Reachability
- (void) listenAFNetworkReachabilityStatus;
@end

NS_ASSUME_NONNULL_END
