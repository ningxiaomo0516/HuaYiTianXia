//
//  TXPushMessageViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/24.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPushMessageViewController.h"
#import "WMPageController.h"

@interface TXPushMessageViewController ()<WMPageControllerDelegate>

@end

@implementation TXPushMessageViewController

- (instancetype)init {
    if (self = [super init]) {
        self.titleFontName = @"PingFang-SC-Medium";
        self.titleSizeNormal = 14;  /// 默认字体大小
        self.titleSizeSelected = 16;/// 选中字体大小
        self.menuViewStyle = WMMenuViewStyleLine;/// 样式
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;//居中模式
        self.menuItemWidth = kScreenWidth/3;/// 宽度
        self.titleColorSelected = kThemeColor;
        self.titleColorNormal = kTextColor51;
        self.progressWidth = 20;
        self.progressColor = kThemeColor;
        self.menuBGColor = kClearColor;
        self.showOnNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBarTheme];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return @"推送消息";
        case 1: return @"系统消息";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return [[UIViewController alloc] init];
}

- (void) setupNavigationBarTheme {
    // 1.去掉背景图片和底部线条
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self.navigationController.navigationBar setBackgroundImage:[imageColor(kColorWithRGB(250, 250, 250)) resizableImageWithCapInsets:UIEdgeInsetsMake(5, 1, 5, 1)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = kColorWithRGB(51, 51, 51);
    //去掉导航栏下边的投影
    self.navigationController.navigationBar.shadowImage = [imageColor(kClearColor) resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    
    self.navigationController.navigationBar.barTintColor = kNavigationColorNormal;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kColorWithRGB(51, 51, 51)};
    self.navigationController.navigationBar.translucent = NO;// NavigationBar 是否透明
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}
@end
