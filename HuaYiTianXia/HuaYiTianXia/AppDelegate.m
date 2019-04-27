//
//  AppDelegate.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "AppDelegate.h"
#import "LZRootViewController.h"
#import "TTGuidePages.h"
#import "AppDelegate+TXShare.h"
#import <AVFoundation/AVFoundation.h>
//推送
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

//版本号
#import "TXVersionViewController.h"
//广告页
#import "TXAdsViewController.h"
#import "TXVersionModel.h"
#import "TXAdsModel.h"

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    // 手机系统：iPhone OS
    NSString *deviceName = [[UIDevice currentDevice] systemName];
    // 1.手机系统版本：9.1
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    TTLog(@" --- %@ --- %@",deviceName,phoneVersion);

    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:2];
    [self registLocalNotificationWithOptions:launchOptions];
    //配置键盘
//    [IQKeyboardManager sharedManager];
    /// 注册分享
    [self registerMobLoginAndShare];
    /// 注册微信AppId
    [WXApi registerApp:kWechatAppId enableMTA:YES];
    
    ///初始化登陆信息
    [[TTUserModel shared] load];
    TTLog(@" --- %@ --- %@, --- %@ --- %@",kUserInfo.username,kUserInfo.realname,kUserInfo.userid,kUserInfo.inviteCode);

    /// 默认没有任何支付页面
    kUserInfo.topupType = 0;
    [kUserInfo dump];
    ///开启监听网络
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [kNotificationCenter postNotificationName:NetworkReachabilityStatus object:nil userInfo:@{@"status":@(status)}];
    }];
    
    BOOL isProduction = NO;
    #ifdef DEBUG
        isProduction = NO;
    #else
        isProduction = YES;
    #endif
    ///极光推送
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }else{
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService crashLogON];
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:kJGAppKey
                          channel:@"App Store"
                 apsForProduction:true];
    NSNotificationCenter *defaultCenter = kNotificationCenter;
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    [self showMainViewController];
//    [self setVersionVC];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//        [self guidePages];
    }else{
    
    }
    return YES;
}

//---------------------------------------------------------------------------------------------------------------------------------------------
- (void)guidePages{
    //---------------------------------------------------------------------------------------------------------------------------------------------
    
    TTGuidePages *mzgpc = [[TTGuidePages alloc] init];
    __weak typeof(TTGuidePages) *weakMZ = mzgpc;
    mzgpc.buttonAction = ^{
        [UIView animateWithDuration:1.5f
                         animations:^{
                             weakMZ.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [weakMZ removeFromSuperview];
                         }];
    };
    [self.window addSubview:mzgpc];    
}

/// 获取registedID
- (void)networkDidLogin:(NSNotification *)notification {
    if ([JPUSHService registrationID]) {
        //下面是我拿到registeID,发送给服务器的代码，可以根据你需求来处理
        NSString *registerid = [JPUSHService registrationID];
        TTLog(@"APPDelegate开始上传rgeisterID -- %@",registerid);
        kUserInfo.registrationID = registerid;
        [kUserInfo dump];
        NSString *idd = [NSString stringWithFormat:@"--- %@ --- \n --- %@ ---",kUserInfo.registrationID,registerid];
        Toast(idd);
    }else{
        Toast(@"有个卵");
    }
}

//设置版本页面为主视图
- (void)setVersionVC{
    TXVersionViewController * vc = [[TXVersionViewController alloc] init];
    self.window.backgroundColor = kClearColor;
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

- (void)showMainViewController {
    // 1. 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //设置窗口颜色
    self.window.backgroundColor = [UIColor whiteColor];
    //设置窗口为主窗口并且显示
//    [self.window makeKeyAndVisible];
    [self setVersionVC];
//    [self jumpMainVC];
}

- (void) jumpMainVC{
    LZRootViewController *mainVC   = [[LZRootViewController alloc] init];
    self.window.rootViewController = mainVC;
}

+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (void) setSelectedIndex{
    [self.window.rootViewController.tabBarController setSelectedIndex:0];
}

#pragma mark  本地通知（预约）
- (void)registLocalNotificationWithOptions:(NSDictionary *)launchOptions {
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if (notification) {
        //        NSString* kid = notification.userInfo[@"id"];
    }
}

#pragma mark ------ 微信支付处理 ------
/// iOS9.0以前使用
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    /// 支付宝
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            TTLog(@"result = %@",resultDic);
        }];
    }
    
    
    return YES;
}

// 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
//    [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    /// 支付宝
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //发送支付成功通知
            [kNotificationCenter postNotificationName:@"AlipayStatus" object:resultDic];
            if (kUserInfo.topupType == 1) {
                /// 充值成功处理
                Toast(@"充值成功");
            }else if (kUserInfo.topupType == 2) {
                /// 商城支付成功
            }else if (kUserInfo.topupType == 3) {
                /// 农保支成功
            }
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            TTLog(@"platformapi  result = %@",resultDic);
            //发送支付失败通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:ReturnSucceedPayNotification object:nil];
        }];
    };
    
    /// 设置微信支付代理
    if ([url.host isEqualToString:@"pay"]) {
//        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }
    return YES;
}

#pragma mark - WXApiDelegate==========================WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
    //// (1:充值 2:商城支付 3:农保支付)
    NSString *payType = [NSString stringWithFormat:@"当前的支付页面是 -- --%ld",kUserInfo.topupType];
    TTLog(@"%@", payType);
    //微信支付的类
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        if (resp.errCode == WXSuccess) {
            if (kUserInfo.topupType == 1) {
                strMsg = @"支付成功！";
            }else if (kUserInfo.topupType == 2) {
                strMsg = @"支付成功！";
            }else if (kUserInfo.topupType == 3) {
                strMsg = @"充值成功！";
            }
            
            TTLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//            PaySucceedViewController *vc = [[PaySucceedViewController alloc] init];
//            vc.backStr = @"1";
//            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
//            AppDelegate *appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate.window.rootViewController presentViewController:navi animated:NO completion:nil];
        }/**else if(resp.errCode == WXErrCodeCommon){
            strMsg = @"普通错误类型！";
            TTLog(@"普通错误类型，retcode = %d", resp.errCode);
        }*/else if(resp.errCode == WXErrCodeUserCancel){
            strMsg = @"取消支付！";
            TTLog(@"用户点击取消并返回，retcode = %d", resp.errCode);
        }/**else if(resp.errCode == WXErrCodeSentFail){
            strMsg = @"发送失败！";
            TTLog(@"发送失败，retcode = %d", resp.errCode);
        }else if(resp.errCode == WXErrCodeSentFail){
            strMsg = @"授权失败！";
            TTLog(@"授权失败，retcode = %d", resp.errCode);
        }*/else{
//            strMsg = @"微信不支持";
            strMsg = [NSString stringWithFormat:@"支付结果：失败！"];
            TTLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//            PayFailedViewController *vc = [[PayFailedViewController alloc] init];
//            vc.backStr = @"1";
//            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
//            AppDelegate *appDelegate =
//            (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate.window.rootViewController presentViewController:navi animated:NO completion:nil];
        }
        Toast(strMsg);
    }
    
    //微信登录的类
    if([resp isKindOfClass:[SendAuthResp class]]){
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
//            if (_delegate && [_delegate respondsToSelector:@selector(loginSuccessByCode:)]) {
//                SendAuthResp *resp2 = (SendAuthResp *)resp;
//                [_delegate loginSuccessByCode:resp2.code];
//            }
        }else{ //失败
            TTLog(@"登录失败 --- error %@",resp.errStr);
        }
    }
    
    //微信分享的类
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        //微信分享 微信回应给第三方应用程序的类
        SendMessageToWXResp *response = (SendMessageToWXResp *)resp;
        NSLog(@"error code %d  error msg %@  lang %@   country %@",response.errCode,response.errStr,response.lang,response.country);
        if (resp.errCode == 0) {//成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
//            if(_delegate && [_delegate respondsToSelector:@selector(shareSuccessByCode:)]){
//                [_delegate shareSuccessByCode:response.errCode];
//            }
        }else{ //失败
            TTLog(@"分享失败 --- error %@",resp.errStr);
        }
    }
}



#pragma mark  ----------------极光推送----------------
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// 记得一定要向极光服务器注册diviceToken来换取registedID
    /// Required - 注册 DeviceToken
    TTLog(@"deviceToken -- %@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

/// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        [self handleRemoteNotificationWhenAppInBackground:[UIApplication sharedApplication] userInfo:userInfo];
    }
    self.userInfo = userInfo;
    self.isImplementPush = true;
    
    //    NSString *voiceStr = userInfo[@"aps"][@"alert"];
    //    TTLog(@"voiceStr --- %@",voiceStr);
    //    [self syntheticVoice:voiceStr];
    TTLog(@"userInfo  - %@",userInfo);
    
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        [self handleRemoteNotificationWhenAppInBackground:[UIApplication sharedApplication] userInfo:userInfo];
    }
    self.userInfo = userInfo;
    self.isImplementPush = true;
    TTLog(@"userInfo  - %@",userInfo);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification  API_AVAILABLE(ios(10.0)){
    TTLog(@"---- 什么玩意");
}

#pragma mark Notification
/// 应用在后台运行
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    ///处理推送结果
    
    self.isImplementPush = true;
    self.userInfo = userInfo;
    if (application.applicationState == UIApplicationStateInactive){
        [self handleRemoteNotificationWhenAppInBackground:application userInfo:userInfo];
    }else{
        completionHandler(UIBackgroundFetchResultNewData);
    }
    //     else if (application.applicationState == UIApplicationStateBackground) {
    //         [self handleRemoteNotificationWhenAppInBackground:application userInfo:userInfo];
    //     }
    TTLog(@"userInfo  - %@",userInfo);
}

#pragma mark- JPUSHRegisterDelegate // 2.1.9版新增JPUSHRegisterDelegate,需实现以下两个方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    //处理推送结果
    if (application.applicationState == UIApplicationStateInactive){
        [self handleRemoteNotificationWhenAppInBackground:application userInfo:userInfo];
    }else{
        
    }
    self.isImplementPush = true;
    self.userInfo = userInfo;
    //else if (application.applicationState == UIApplicationStateBackground) {
    //        [self handleRemoteNotificationWhenAppInBackground:application userInfo:userInfo];
    //    }
    TTLog(@"userInfo  - %@",userInfo);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    TTLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

-(void)handleRemoteNotificationWhenAppInBackground:(UIApplication*)application userInfo:(NSDictionary*)userInfo{
    [JPUSHService setBadge:0];
    [JPUSHService resetBadge];
    application.applicationIconBadgeNumber = 0;
    TTLog(@"userInfo  - %@",userInfo);
//    NSString *voiceStr = userInfo[@"aps"][@"alert"];
    //对接送进行解析
    if (userInfo[@"iosNotification extras key"] && [userInfo[@"iosNotification extras key"] isKindOfClass:[NSString class]]) {
        NSDictionary* jsonDict  = [self dictionaryWithJsonString:userInfo[@"iosNotification extras key"]];
        //        NSString* type = [NSString stringWithFormat:@"%@",jsonDict[@"type"]];
        //        NSString* url = jsonDict[@"url"];
        //        UITabBarController* tabVC = (UITabBarController*)application.keyWindow.rootViewController;
        //        UINavigationController* navVC = tabVC.selectedViewController;
        
        
        //        if (type.integerValue == 0) {//跳点播页面
        //            PVDemandViewController* vc = [[PVDemandViewController alloc] init];
        //            vc.url = url;
        //            [navVC pushViewController:vc animated:true];
        //        }else if (type.integerValue == 1){//直播频道
        //            PVLIveViewController* liveVC = tabVC.childViewControllers[1].childViewControllers.firstObject;
        //            if (liveVC.childViewControllers.count > 0) {
        //                PVTelevisionViewController* vc = liveVC.childViewControllers.firstObject;
        //                vc.jumpType = @"2";
        //                vc.jumpUrl = url;
        //                [liveVC scrollTelevision];
        //            }else{
        //                liveVC.menuModel.jumpType = @"1";
        //                liveVC.menuModel.jumpUrl = url;
        //            }
        //            tabVC.selectedIndex = 1;
        //        }else if (type.integerValue == 2){//互动直播详情页
        //            PVInteractiveZBViewController* vc = [[PVInteractiveZBViewController alloc]  init];
        //            vc.menuUrl = url;
        //            [navVC pushViewController:vc animated:true];
        //        }else if (type.integerValue == 3 || type.integerValue == 4){//活动
        //            PVWebViewController* vc = [[PVWebViewController alloc]  initWebViewControllerWithWebUrl:url webTitle:@""];
        //            if (url.length < 10) {
        //                return;
        //            }
        //            [navVC pushViewController:vc animated:true];
        //        }else if (type.integerValue == 5){//专题详情页
        //            PVSpecialSecondDetailController* vc = [[PVSpecialSecondDetailController alloc]  init];
        //            vc.menuUrl = url;
        //            [navVC pushViewController:vc animated:true];
        //        }
        TTLog(@"jsonDict = %@",jsonDict);
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        TTLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self cleanNotNum];
}

- (void)cleanNotNum{
    [JPUSHService resetBadge];
    [self cleanNotificationNumber];
}

- (void)cleanNotificationNumber{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
