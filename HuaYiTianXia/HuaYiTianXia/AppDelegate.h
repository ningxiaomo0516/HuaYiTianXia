//
//  AppDelegate.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZRootViewController.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
    LZNavigationController *navigationController;
    
}
@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) UITabBarController *tabBarController;

///是否执行了推送
@property(nonatomic, assign)BOOL isImplementPush;
@property(nonatomic, strong)NSDictionary* userInfo;

+ (AppDelegate *) appDelegate;
/// 退出后选中首页
- (void) setSelectedIndex;
- (void) jumpMainVC;


@property (nonatomic, strong) Reachability  *hostReachability;
@property (nonatomic, strong) Reachability  *interNetReachability;
@property (nonatomic, strong) NSString      *offLine;
@end

