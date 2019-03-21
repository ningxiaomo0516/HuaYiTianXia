//
//  TXZhuanchuZhuanruViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXZhuanchuZhuanruViewController.h"
#import "WMPageController.h"

@interface TXZhuanchuZhuanruViewController ()<WMPageControllerDelegate>

@end

@implementation TXZhuanchuZhuanruViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.setPageViewControllers];
}

#pragma mark -- setter/getter
-(UIView *)setPageViewControllers {
    WMPageController *pageController = [self p_defaultController];
    pageController.titleFontName = @"PingFang-SC-Medium";
    pageController.titleSizeNormal = 14;  /// 默认字体大小
    pageController.titleSizeSelected = 16;/// 选中字体大小
    pageController.menuViewStyle = WMMenuViewStyleLine;/// 样式
    pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;//居中模式
    pageController.menuItemWidth = kScreenWidth/3;/// 宽度
    pageController.titleColorSelected = HexString(@"#FF4163");
    pageController.titleColorNormal = kTextColor12;
    pageController.progressWidth = 20;
    pageController.progressColor = HexString(@"#FF4163");
    pageController.menuBGColor = kClearColor;
    //    pageController.showOnNavigationBar = YES;
    
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    
    
    UIView *linerView = [UIView lz_viewWithColor:kTextColor238];
    [pageController.view addSubview:linerView];
    linerView.frame = CGRectMake(0, pageController.menuHeight, kScreenWidth, 0.7);
    return pageController.view;
}

- (WMPageController *)p_defaultController {
    NSArray *titles = @[@"转出记录",@"转入记录"];
    NSArray *showClass = @[@"TXEquityViewController",@"TXEquityViewController"];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (int i=0; i<titles.count; i++) {
        NSString *className = [showClass lz_safeObjectAtIndex:i];
        Class controller = NSClassFromString(className);
        //    id controller = [[NSClassFromString(className) alloc] init];
        if (controller &&  [controller isSubclassOfClass:[UIViewController class]]){
            UIViewController *vc = [[controller alloc] init];
            vc.view.backgroundColor = kRandomColor;
            [viewControllers addObject:vc];
        }
    }
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    [pageVC setViewFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-kNavBarHeight)];
    pageVC.delegate = self;
    pageVC.menuHeight = 40;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}

@end
