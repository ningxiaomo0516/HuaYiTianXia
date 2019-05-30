//
//  TXUAVExperienceChildViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXUAVExperienceChildViewController.h"
#import "TXUAVExperienceChildTableViewCell.h"
#import "TXMallGoodsBannerTableViewCell.h"
#import "TXCourseModel.h"
#import "TXVideoTableViewCell.h"
#import "TXShareViewController.h"
#import <WebKit/WebKit.h>
#import "TXCourseChildModel.h"
#import "TXCourseReservationView.h"

static NSString * const reuseIdentifier = @"TXUAVExperienceChildTableViewCell";
static NSString * const reuseIdentifierVideo = @"TXVideoTableViewCell";
static NSString * const reuseIdentifierBanner = @"TXMallGoodsBannerTableViewCell";
@interface TXUAVExperienceChildViewController ()<UITableViewDelegate,UITableViewDataSource,TXUAVExperienceChildTableViewCellDelegate,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度

@property (nonatomic, assign) CGFloat webViewHeight;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, assign) BOOL isload;
@property (nonatomic, strong) SCShareModel *shareModel;
@property (nonatomic, strong) CourseListModel *courseListModel;
@property (nonatomic, strong) TXCourseChildModel *courseModel;
@property (nonatomic, strong) UIButton *saveButton;
@end

@implementation TXUAVExperienceChildViewController
- (id)initCourseListModel:(CourseListModel *)courseListModel{
    if ( self = [super init] ){
        self.courseListModel = courseListModel;
        self.webViewHeight = 300;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.isload = NO;
    self.title = @"培训详情";
    [self createWebView];
    [self.view showLoadingViewWithText:@"加载中..."];
    [self requestPersonalCenterData];
    UIImage *rightImg = kGetImage(@"live_btn_share");
    rightImg = [rightImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:rightImg
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(didTapShareButton:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/// 分享到第三方平台
- (void)didTapShareButton:(UIBarButtonItem *)barButtonItem {
    TXShareViewController *vc = [[TXShareViewController alloc] init];
    CGFloat height = IPHONE6_W(150)+kTabBarHeight;
    vc.shareModel = self.shareModel;
    [self sc_bottomPresentController:vc presentedHeight:height completeHandle:^(BOOL presented) {
        if (presented) {
            TTLog(@"弹出了");
        }else{
            TTLog(@"消失了");
        }
    }];
}

- (void) handleControlEvent:(UIButton *) sender{
//    TXCourseReservationView *view = [[TXCourseReservationView alloc] init];
//    [view showInView:self.navigationController.view];
}

- (void) requestPersonalCenterData{
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.courseListModel.kid.integerValue) forKey:@"id"];
    [SCHttpTools postWithURLString:kHttpURL(@"flighttrain/flightTrainDetails") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.courseModel = [TXCourseChildModel mj_objectWithKeyValues:result];
            if (self.courseModel.errorcode == 20000) {
                
            }else{
                Toast(self.courseModel.message);
            }
            self.isload = YES;
        }else{
            Toast(@"数据获取失败");
        }
        [self.view dismissLoadingView];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.view dismissLoadingView];
    }];
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.saveButton.mas_top);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(IPHONE6_W(45)));
        make.left.right.equalTo(self.view);
        make.left.equalTo(@(IPHONE6_W(15)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-15));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        /// 视频
//        TXVideoTableViewCell * tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierVideo forIndexPath:indexPath];
//        tools.imagesView.image = kGetImage(@"base_deprecated_activity");
//        return tools;
        /// banner
        TXMallGoodsBannerTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        tools.isPageControl = YES ;
        tools.bannerArray = self.courseModel.data.banners;
        return tools;
    } else if (indexPath.section==1) {
        TXUAVExperienceChildTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.delegate = self;
        tools.indexPath = indexPath;
        tools.courseLabel.text = self.courseModel.data.title;
        tools.courseModel = self.courseModel.data.flightcourse;
        return tools;
    }else{
        UITableViewCell *webCell = [tableView dequeueReusableCellWithIdentifier:@"WebViewCell" forIndexPath:indexPath];
        //        培训产品传入:0，另外的传入:1
        NSString *parameter = [NSString stringWithFormat:@"%@&type=0", self.courseListModel.kid];
        NSString *URLStr = kAppendH5URL(DomainName, CourseDetailsH5, parameter);
        NSURL *url = [NSURL URLWithString:URLStr];
        self.shareModel.h5Url = URLStr;
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        if (self.isload) {
            self.isload = NO;
            [self.wkWebView loadRequest:urlRequest];
        }
        [webCell.contentView addSubview:self.scrollView];
        return webCell;
    }
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) return IPHONE6_W(180);
    if (indexPath.section==1) {
        if (self.heightAtIndexPath[indexPath]) {
            NSNumber *num = self.heightAtIndexPath[indexPath];
            /// collectionView 底部还有七个像素
            return [num floatValue]+7;
        }else {
            return UITableViewAutomaticDimension;
        }
    }
    if (indexPath.section==2) return self.webViewHeight;
    return UITableViewAutomaticDimension;
}

#pragma mark ====== First ======
- (void)updateTableViewCellHeight:(TXUAVExperienceChildTableViewCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath {
    if (![self.heightAtIndexPath[indexPath] isEqualToNumber:@(height)]) {
        self.heightAtIndexPath[indexPath] = @(height);
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView registerClass:[TXUAVExperienceChildTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXVideoTableViewCell class] forCellReuseIdentifier:reuseIdentifierVideo];
        [_tableView registerClass:[TXMallGoodsBannerTableViewCell class] forCellReuseIdentifier:reuseIdentifierBanner];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WebViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = kTableViewInSectionColor;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableDictionary *)heightAtIndexPath {
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [[NSMutableDictionary alloc] init];
    }
    return _heightAtIndexPath;
}

- (SCShareModel *)shareModel{
    if (!_shareModel) {
        _shareModel = [[SCShareModel alloc] init];
    }
    return _shareModel;
}


- (void)dealloc{
    [self.wkWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        // 方法一
        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat height = scrollView.contentSize.height;
        self.webViewHeight = height;
        self.wkWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:2], nil] withRowAnimation:UITableViewRowAnimationNone];
    }else if([keyPath isEqualToString:@"title"]){
        if (object == self.wkWebView) {
            TTLog(@"self.wkWebView.title --- %@",self.wkWebView.title);
            self.shareModel.descriptStr = self.wkWebView.title;
            self.shareModel.sharetitle = self.wkWebView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}


- (void)createWebView{
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    wkWebConfig.userContentController = wkUController;
    // 自适应屏幕宽度js
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 添加js调用
    [wkUController addUserScript:wkUserScript];
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1) configuration:wkWebConfig];
    self.wkWebView.backgroundColor = [UIColor clearColor];
    self.wkWebView.opaque = NO;
    self.wkWebView.userInteractionEnabled = NO;
    self.wkWebView.scrollView.bounces = NO;
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.wkWebView sizeToFit];
    [self.wkWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [self.scrollView addSubview:self.wkWebView];
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.tag = 2;
        [_saveButton setTitle:@"立即报名" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_saveButton cornerRadius:45/2.0];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf handleControlEvent:self.saveButton];
        }];
    }
    return _saveButton;
}

@end
