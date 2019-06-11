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
#import "TXNewsModel.h"

@interface TXNewsViewController ()<WMPageControllerDelegate>
@property (nonatomic, strong) TXMainHeaderView *headerView;
@property (nonatomic, assign) CGFloat menuHeight;
//@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, strong) NSMutableArray<TXNewsTabModel *> *titlesArray;
@end

@implementation TXNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadTabData];
    self.menuHeight = 40;
    [self initView];
}

- (void) loadTabData{
    kShowMBProgressHUD(self.view);
    [SCHttpTools getWithURLString:@"news/GetNewTab" parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TTLog(@"result -- %@",result);
        TXNewsModel *tabModel = [TXNewsModel mj_objectWithKeyValues:result];
        if (tabModel.errorcode==20000) {
            [self.titlesArray addObjectsFromArray:tabModel.data];
            [self.view addSubview:self.setPageViewControllers];
        }else{
            
        }
        self.loadFailedView.hidden = YES;
        kHideMBProgressHUD(self.view);
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        kHideMBProgressHUD(self.view);
        self.loadFailedView.hidden = NO;
    }];
}

- (void) reminderData{
    [self loadTabData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark ---- 界面布局设置
- (void)initView{
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(kNavBarHeight+self.menuHeight));
    }];
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
    pageController.titleColorSelected = kWhiteColor;
    pageController.titleColorNormal = kWhiteColor;
    pageController.progressWidth = 20;
    pageController.progressColor = kWhiteColor;
    pageController.menuBGColor = kClearColor;
    pageController.view.backgroundColor = kClearColor;
    [self addChildViewController:pageController];
    [pageController didMoveToParentViewController:self];
    
    return pageController.view;
}

- (WMPageController *)p_defaultController {
//    NSArray *titles = @[@"行业动态",@"公司信息",@"关于我们",@"华翼天下"];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];

    for (int i=0; i<self.titlesArray.count; i++) {
        TXNewsTabModel *model = self.titlesArray[i];
        TXNewTemplateViewController *vc  = [TXNewTemplateViewController new];
        vc.title = model.kid;
        [titles addObject:model.titleName];
        [viewControllers addObject:vc];
    }
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    [pageVC setViewFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight)];
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

- (NSMutableArray *)titlesArray{
    if (!_titlesArray) {
        _titlesArray = [[NSMutableArray alloc] init];
    }
    return _titlesArray;
}


@end
