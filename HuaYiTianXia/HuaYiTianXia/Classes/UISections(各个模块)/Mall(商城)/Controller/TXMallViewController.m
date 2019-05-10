//
//  TXMallViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMallViewController.h"
#import "WMPageController.h"
#import "TXMallCollectionViewController.h"
#import "TXMainHeaderView.h"

@interface TXMallViewController ()<WMPageControllerDelegate>
@property (nonatomic, strong) TXMainHeaderView *headerView;
@property (nonatomic, assign) CGFloat menuHeight;

@end

@implementation TXMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.menuHeight = 44;
    [self initView];
    [self.view addSubview:self.setPageViewControllers];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark ---- 界面布局设置
- (void)initView{
    [self.view addSubview:self.headerView];
    self.headerView.titlesLabel.hidden = YES;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(kNavBarHeight));
    }];
}

#pragma mark -- setter/getter
-(UIView *)setPageViewControllers {
    WMPageController *pageController = [self p_defaultController];
    pageController.titleFontName = @"PingFang-SC-Medium";
    pageController.titleSizeNormal = 14;  /// 默认字体大小
    pageController.titleSizeSelected = 16;/// 选中字体大小
    pageController.menuViewStyle = WMMenuViewStyleLine;/// 样式
    pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;//居中模式
    pageController.menuItemWidth = kScreenWidth/4;/// 宽度
    pageController.titleColorSelected = kWhiteColor;//HexString(@"#FF4163");
    pageController.titleColorNormal = [kWhiteColor colorWithAlphaComponent:0.5];
    pageController.progressWidth = 20;
    pageController.progressColor = kWhiteColor;
    pageController.menuBGColor = kClearColor;
    pageController.view.backgroundColor = kClearColor;
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    

    return pageController.view;
}

- (WMPageController *)p_defaultController {
    NSArray *titles = @[@"无人机产品",@"生态产业"];
    NSArray *kidArray = @[@"1",@"6"];
    NSArray *classArray = @[@"TXUAvCollectionViewController",@"TXMallCollectionViewController"];
//    1：无人机商城产品（消费）；2：农用植保产品（购买）；3：VR产品（购买）；4：纵横矿机产品（购买）；5：共享飞行产品（购买）；6：生态农业商城产品（消费）

    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (int i=0; i<classArray.count; i++) {
        NSString *className = classArray[i];
        Class controller = NSClassFromString(className);
        //    id controller = [[NSClassFromString(className) alloc] init];
        if (controller &&  [controller isSubclassOfClass:[UIViewController class]]){
            UIViewController *vc = [[controller alloc] init];
            vc.title = kidArray[i];
            [viewControllers addObject:vc];
        }
    }
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    [pageVC setViewFrame:CGRectMake(0, kNavBarHeight-self.menuHeight, kScreenWidth, kScreenHeight-kNavBarHeight)];
    pageVC.delegate = self;
    pageVC.menuHeight = self.menuHeight;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}

- (TXMainHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TXMainHeaderView alloc] init];
    }
    return _headerView;
}

@end
