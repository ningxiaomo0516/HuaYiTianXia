//
//  TXNewsViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXNewsViewController.h"
#import "WMPageController.h"
#import "TXNewTemplateViewController.h"
#import "TXMainHeaderView.h"

@interface TXNewsViewController ()<WMPageControllerDelegate>
@property (nonatomic, strong) TXMainHeaderView *headerView;

@end

@implementation TXNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.setPageViewControllers];
    [self initView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark ---- 界面布局设置
- (void)initView{
    self.headerView.backgroundColor = kRandomColor;
    [self.view addSubview:self.headerView];

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
    pageController.titleColorSelected = HexString(@"#FF4163");
    pageController.titleColorNormal = kTextColor12;
    pageController.progressWidth = 20;
    pageController.progressColor = HexString(@"#FF4163");
    pageController.menuBGColor = kClearColor;
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    
    
    UIView *linerView = [UIView lz_viewWithColor:kTextColor238];
    [pageController.view addSubview:linerView];
    linerView.frame = CGRectMake(0, pageController.menuHeight+kNavBarHeight, kScreenWidth, 0.7);
    return pageController.view;
}

- (WMPageController *)p_defaultController {
    NSArray *titles = @[@"行业动态",@"公司信息",@"关于我们",@"华翼天下"];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (int i=0; i<titles.count; i++) {
        TXNewTemplateViewController *vc  = [TXNewTemplateViewController new];
        vc.view.backgroundColor = kRandomColor;
        [viewControllers addObject:vc];
    }
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    [pageVC setViewFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight)];
    pageVC.delegate = self;
    pageVC.menuHeight = 40;
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
