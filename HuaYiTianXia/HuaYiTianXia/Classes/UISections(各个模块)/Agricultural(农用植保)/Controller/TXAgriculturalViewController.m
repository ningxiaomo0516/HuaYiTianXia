//
//  TXAgriculturalViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXAgriculturalViewController.h"
#import "TXGoodsH5TableViewCell.h"
#import "TXWebHeaderView.h"
#import "TXMallEppoViewController.h"

static NSString * const reuseIdentifierGoodsH5 = @"TXGoodsH5TableViewCell";

@interface TXAgriculturalViewController ()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate, WKNavigationDelegate>
@property (strong, nonatomic) TXWebHeaderView *headerView;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) CGFloat webViewHeight;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation TXAgriculturalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webViewHeight = 0.0;
    [self initView];
}

- (void) initView{
    [self createWebView];
    self.headerView.titleLabel.text = @"一县一代理独家经营";
    self.headerView.subtitleLabel.text = @"农用科技化、现代化";
    self.headerView.imagesView.image = kGetImage(@"c41_live_nongbao");
    [self.headerView.saveButton setTitle:@"农用植保" forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [Utils lz_setExtraCellLineHidden:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
    }];
    MV(weakSelf);
    [self.headerView.saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf saveBtnClick:self.headerView.saveButton];
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    TXMallEppoViewController *vc = [[TXMallEppoViewController alloc] init];
    TTPushVC(vc);
}

- (void)dealloc{
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        // 方法一
        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat height = scrollView.contentSize.height;
        self.webViewHeight = height;
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.contentSize =CGSizeMake(self.view.frame.size.width, height);
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        
        /*
         // 方法二
         [_webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
         CGFloat height = [result doubleValue] + 20;
         self.webViewHeight = height;
         self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
         self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
         self.scrollView.contentSize =CGSizeMake(self.view.frame.size.width, height);
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
         }];
         */
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    TXGoodsH5TableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierGoodsH5 forIndexPath:indexPath];
//    tools.webUrl = kAppendH5URL(DomainName, AgencyCompanyH5, @"");
//    MV(weakSelf)
//    tools.refreshWebViewHeightBlock = ^(CGFloat height) {
//        weakSelf.webViewHeight = height;
//        [self.tableView reloadData];
//    };
//    tools.indexPath = indexPath;
//    return tools;
    UITableViewCell *webCell = [tableView dequeueReusableCellWithIdentifier:@"WebViewCell" forIndexPath:indexPath];
    [webCell.contentView addSubview:self.scrollView];
    return webCell;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.webViewHeight;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TXGoodsH5TableViewCell class] forCellReuseIdentifier:reuseIdentifierGoodsH5];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WebViewCell"];

        // 拖动tableView时收起键盘
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kClearColor;
    }
    return _tableView;
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
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1) configuration:wkWebConfig];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    self.webView.userInteractionEnabled = NO;
    self.webView.scrollView.bounces = NO;
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.webView sizeToFit];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    NSString *str = kAppendH5URL(DomainName, AgencyCompanyH5, @"");
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [self.scrollView addSubview:self.webView];
}

- (TXWebHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TXWebHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, IPHONE6_W(340));
    }
    return _headerView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
