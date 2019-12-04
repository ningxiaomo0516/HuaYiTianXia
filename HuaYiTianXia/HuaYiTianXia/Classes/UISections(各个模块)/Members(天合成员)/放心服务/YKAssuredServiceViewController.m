//
//  YKAssuredServiceViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/11.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKAssuredServiceViewController.h"
#import "YKBaseNavigationView.h"
#import "WMPageController.h"
#import "TXWebViewController.h"

@interface YKAssuredServiceViewController ()<WMPageControllerDelegate>
@property (nonatomic, strong) YKBaseNavigationView *navigationView;
@property (nonatomic, assign) CGFloat menuHeight;
@end

@implementation YKAssuredServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.navigationView];
    self.menuHeight = 40;
    self.navigationView.imagesView.image = kGetImage(@"放心服务标题");
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kNavBarHeight);
    }];
    [self.view addSubview:self.setPageViewControllers];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -- setter/getter
-(UIView *)setPageViewControllers {
    WMPageController *pageController = [self p_defaultController];
    pageController.titleFontName = @"PingFang-SC-Medium";
    pageController.titleSizeNormal = 15;  /// 默认字体大小
    pageController.titleSizeSelected = 16;/// 选中字体大小
    pageController.menuViewStyle = WMMenuViewStyleLine;/// 样式
    pageController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;//居中模式
    pageController.menuItemWidth = kScreenWidth/4;/// 宽度
    pageController.titleColorSelected = kColorWithRGB(199, 167, 101);
    pageController.titleColorNormal = kTextColor102;
    pageController.progressWidth = 20;
    pageController.progressColor = kColorWithRGB(199, 167, 101);
    pageController.menuBGColor = kWhiteColor;
    pageController.view.backgroundColor = kClearColor;
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    
    return pageController.view;
}

- (WMPageController *)p_defaultController {
    NSArray *titles = @[@"产品说明",@"行李规定"];
    /// 产品
    NSString *product = kStringFormat(DomainName, @"appH5/productExplain.html");
    /// 行李
    NSString *luggage = kStringFormat(DomainName, @"appH5/bag.html");
    NSArray *urlArray = @[product,luggage];

    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
//    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (int i=0; i<titles.count; i++) {
//        TXNewsTabModel *model = self.titlesArray[i];
        TXWebViewController *vc  = [TXWebViewController new];
        vc.webUrl = urlArray[i];
//        [titles addObject:model.titleName];
        [viewControllers addObject:vc];
    }
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    //    [pageVC setViewFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight)];
    pageVC.delegate = self;
    pageVC.menuHeight = self.menuHeight;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}

//- (NSMutableArray *)titlesArray{
//    if (!_titlesArray) {
//        _titlesArray = [[NSMutableArray alloc] init];
//    }
//    return _titlesArray;
//}

- (YKBaseNavigationView *)navigationView{
    if (!_navigationView) {
        _navigationView = [[YKBaseNavigationView alloc] init];
    }
    return _navigationView;
}
@end
