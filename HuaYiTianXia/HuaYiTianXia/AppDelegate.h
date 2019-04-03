//
//  AppDelegate.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZRootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
{
    LZNavigationController *navigationController;
    
}
@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) UITabBarController *tabBarController;

+ (AppDelegate *) appDelegate;
/// 退出后选中首页
- (void) setSelectedIndex;
- (void) jumpMainVC;
@end

