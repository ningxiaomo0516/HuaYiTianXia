//
//  AppDelegate.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "AppDelegate.h"
#import "LZRootViewController.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    //配置键盘
    [IQKeyboardManager sharedManager];
    [WXApi registerApp:kWechatAppId enableMTA:YES];
    
    ///初始化登陆信息
    [[TTUserModel shared] load];
    TTLog(@" --- %@ --- %@, --- %@ --- %@",kUserInfo.username,kUserInfo.realname,kUserInfo.uid,kUserInfo.inviteCode);
    [self showMainViewController];
    return YES;
}

- (void)showMainViewController {
    // 1. 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //设置窗口颜色
    self.window.backgroundColor = [UIColor whiteColor];
    //设置窗口为主窗口并且显示
    [self.window makeKeyAndVisible];
//    if (kUserInfo.isLogin) {
        // 设置窗口的根控制器
        //        if (!kUserInfo.isBindTel) {
        // 设置窗口的根控制器
    [self jumpMainVC];
//    }else{
//        [self jumpLoginVC];
//    }
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
    //微信支付的类
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        if (resp.errCode == WXSuccess) {
            strMsg = @"支付结果：成功！";
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
