//
//  YKBuyTicketIntroduceViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/12.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKBuyTicketIntroduceViewController.h"
#import "WMPageController.h"
#import "TXWebViewController.h"

@interface YKBuyTicketIntroduceViewController ()<WMPageControllerDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *imagesView;
@property (nonatomic, assign) CGFloat menuHeight;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation YKBuyTicketIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imagesView.image = kGetImage(@"全程保障_放心预订");
    self.menuHeight = 40;
    [self initView];
    [self.view addSubview:self.setPageViewControllers];
    UIView *linerView = [UIView lz_viewWithColor:kLinerViewColor];
    [self.view addSubview:linerView];
    [linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(0.5));
        make.top.equalTo(@(87));
    }];
    
    [self.closeButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self sc_dismissVC];
    }];
}

- (void) initView{
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.imagesView];
    [self.headerView addSubview:self.closeButton];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(47));
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.headerView);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(5));
        make.top.bottom.equalTo(self.headerView);
        make.width.equalTo(self.headerView.mas_height);
        make.centerY.equalTo(self.headerView);
    }];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kWhiteColor;
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
    pageController.titleColorNormal = kTextColor51;
    pageController.progressWidth = 20;
    pageController.progressColor = kColorWithRGB(199, 167, 101);
    pageController.menuBGColor = kWhiteColor;
    pageController.view.backgroundColor = kClearColor;
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    
    return pageController.view;
}

- (WMPageController *)p_defaultController {
    NSArray *titles = @[@"儿童票",@"婴儿票",@"常见问题"];
    /// 儿童票
    NSString *product = kStringFormat(DomainName, @"appH5/child.html");
    /// 婴儿票
    NSString *luggage = kStringFormat(DomainName, @"appH5/baby.html");
    /// 常见问题
    NSString *help = kStringFormat(DomainName, @"appH5/problem.html");
    NSArray *urlArray = @[product,luggage,help];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (int i=0; i<titles.count; i++) {
        TXWebViewController *vc  = [TXWebViewController new];
        vc.webUrl = urlArray[i];
        [viewControllers addObject:vc];
    }
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    CGFloat height = kScreenHeight - (kScreenHeight/4) - 40;
    [pageVC setViewFrame:CGRectMake(0, 47, kScreenWidth, height)];
    pageVC.delegate = self;
    pageVC.menuHeight = self.menuHeight;
    pageVC.postNotification = YES;
    pageVC.bounces = YES;
    return pageVC;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _headerView;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:kGetImage(@"all_btn_close_grey") forState:UIControlStateNormal];
    }
    return _closeButton;
}
@end
