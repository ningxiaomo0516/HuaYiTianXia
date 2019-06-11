//
//  TXUAVExperienceMainViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXUAVExperienceMainViewController.h"
#import "TXUAVExperienceViewController.h"
#import "WMPageController.h"

@interface TXUAVExperienceMainViewController ()<WMPageControllerDelegate>

@end

@implementation TXUAVExperienceMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"培训课程";
    [self.view addSubview:self.setPageViewControllers];
}

#pragma mark -- setter/getter
-(UIView *)setPageViewControllers {
    WMPageController *pageController = [self p_defaultController];
    pageController.titleFontName = @"PingFang-SC-Medium";
    pageController.titleSizeNormal = 15;  /// 默认字体大小
    pageController.titleSizeSelected = 16;/// 选中字体大小
    pageController.menuViewStyle = WMMenuViewStyleLine;/// 样式
    pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;//居中模式
    pageController.menuItemWidth = kScreenWidth/3;/// 宽度
    pageController.titleColorSelected = HexString(@"#3994FA");
    pageController.titleColorNormal = kTextColor51;
    pageController.progressWidth = 20;
    pageController.progressColor = kWhiteColor;
    pageController.menuBGColor = kClearColor;
    pageController.view.backgroundColor = kWhiteColor;
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    
    
    return pageController.view;
}

- (WMPageController *)p_defaultController {
    NSArray *titles = @[@"推荐培训",@"我的课程"];
    NSArray *classArray = @[@"TXUAVExperienceViewController",@"TXUAVExperienceViewController"];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (int i=0; i<classArray.count; i++) {
        NSString *className = classArray[i];
        Class controller = NSClassFromString(className);
        //    id controller = [[NSClassFromString(className) alloc] init];
        if (controller &&  [controller isSubclassOfClass:[UIViewController class]]){
            UIViewController *vc = [[controller alloc] init];
            [viewControllers addObject:vc];
        }
    }
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    [pageVC setViewFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavBarHeight)];
    pageVC.delegate = self;
    pageVC.menuHeight = 40;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}
@end
