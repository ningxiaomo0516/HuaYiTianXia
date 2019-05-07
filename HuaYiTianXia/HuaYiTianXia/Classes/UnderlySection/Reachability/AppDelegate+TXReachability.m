//
//  AppDelegate+Reachability.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/7.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "AppDelegate+TXReachability.h"

@implementation AppDelegate (TXReachability)


#pragma mark - 苹果官方 Reachability
/** 初始化并监听网络变化 */
- (void)listenNetWorkReachabilityStatus {
    
    // KVO监听，监听kReachabilityChangedNotification的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    // 初始化 Reachability 当前网络环境
    self.interNetReachability = [Reachability reachabilityForInternetConnection];
    // 开始监听
    [self.interNetReachability startNotifier];
    
    
    //    /** 或者你也可以监听某一个站点的网络连接情况 */
    //    NSString *remoteHostName = @"www.apple.com";
    //    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    //    [self.hostReachability startNotifier];
}

/** 网络环境改变时实现的方法 */
- (void) reachabilityChanged:(NSNotification *)note {
    // 当前发送通知的 reachability
    Reachability *reachability = [note object];
    // 当前网络环境
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    // 断言 如果出错则发送错误信息
    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
    // 不同网络的处理方法
    switch (netStatus) {
        case NotReachable:
            TTLog(@"没有网络连接");
            self.offLine = @"没有网络连接";
            break;
        case ReachableViaWiFi:
            TTLog(@"已连接Wi-Fi");
            self.offLine = @"已连接Wi-Fi";
            break;
        case ReachableViaWWAN:
            TTLog(@"已连接蜂窝网络");
            self.offLine = @"已连接蜂窝网络";
            break;
        default:
            
            break;
    }
    NSDictionary * dic = @{@"offline" : self.offLine};
    [kNotificationCenter postNotification:[NSNotification notificationWithName:@"offline" object:nil userInfo:dic]];
}

/// 监听AFN Reachability
- (void)listenAFNetworkReachabilityStatus {
    /// 开启监听网络
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    /**
     判断网络状态并处理
     @param status 网络状态
     AFNetworkReachabilityStatusUnknown             = 未知网络
     AFNetworkReachabilityStatusNotReachable        = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN    = 蜂窝网络（3g、4g、wwan）
     AFNetworkReachabilityStatusReachableViaWiFi    = wifi网络
     */
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                TTLog(@"当前网络状态未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                TTLog(@"网络已断开");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                TTLog(@"已连接蜂窝网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                TTLog(@"已连接Wi-Fi");
                break;
            default:
                TTLog(@"网络已连接");
                break;
        }
        [kNotificationCenter postNotificationName:NetworkReachabilityStatus object:nil userInfo:@{@"status":@(status)}];
    }];
}

/// 判断是否有网
- (BOOL)isConnectionAvailable {
    /// 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    /// Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    /// 获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    /// 如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags) {
        return NO;
    }
    /// 根据获得的连接标志进行判断
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
}

/**  移除监听，防止内存泄露 */
- (void)dealloc {
    // Reachability停止监听网络， 苹果官方文档上没有实现，所以不一定要实现该方法
    [self.hostReachability stopNotifier];
    
    // 移除Reachability的NSNotificationCenter监听
    [kNotificationCenter removeObserver:self name:kReachabilityChangedNotification object:nil];
}
@end

