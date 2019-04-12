//
//  TXWebViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/1.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXWebViewController.h"
#import <WebKit/WebKit.h>

@interface TXWebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UIProgressView *progress;
@end

@implementation TXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
//    self.webUrl = @"http://www.baidu.com";
    [self loadData];
    
    if ([self.title isEqualToString:@"农保电子协议"]) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:kGetImage(@"all_btn_close_grey")
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(didTapPopButton:)];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

//// 加载数据
- (void)loadData {
    if (self.webUrl.length == 0 || ![self.webUrl hasPrefix:@"http:"]) {
        MVLog(@"缺少链接");
        return;
    }
    NSURL* url = [NSURL URLWithString:self.webUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.wkWebView loadRequest:request];
    
}

- (void) handleButtonTapped:(UIButton *)sender{
    self.wkWebView.hidden = NO;
    self.reloadButton.hidden = YES;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
}

- (void)didTapPopButton:(UIBarButtonItem *)barButtonItem {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void) initView{
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progress];
    [self.view addSubview:self.reloadButton];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.wkWebView.navigationDelegate = nil;
    self.wkWebView.UIDelegate = nil;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        float estimateProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        [self.progress setProgress:estimateProgress animated:YES];
    }
}

#pragma mark - WKNavigationDelegate
///页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.reloadButton.hidden = YES;
    self.wkWebView.hidden = NO;
    [self.progress setHidden:NO];
    [self.progress setProgress:0.1 animated:YES];
}

/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.progress setProgress:1.0 animated:YES];
    [self.progress setHidden:YES];
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.reloadButton.hidden = NO;
    self.wkWebView.hidden = YES;
    [self.progress setHidden:YES];
}

- (UIProgressView *)progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progress.frame = CGRectMake(0, 0, self.wkWebView.width, 0.7);
        _progress.progressTintColor= kColorWithRGB(44, 248, 152);//设置已过进度部分的颜色
        _progress.trackTintColor= [kWhiteColor colorWithAlphaComponent:0.5];//设置未过进度部分的颜色
        _progress.backgroundColor = [UIColor groupTableViewBackgroundColor];//设置背景色
        [self.view insertSubview:_progress aboveSubview:self.navigationController.navigationBar];
    }
    return _progress;
}

- (UIButton *)reloadButton{
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_reloadButton setTitleColor:HexString(@"#FF4163") forState:UIControlStateNormal];
        [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        _reloadButton.titleLabel.font = kFontSizeMedium15;
        _reloadButton.tag = 100;
        MV(weakSelf);
        [_reloadButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf handleButtonTapped:weakSelf.reloadButton];
        }];
    }
    return _reloadButton;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        /// 创建网页配置对象
        WKPreferences *preferences = [WKPreferences new];
        /// 在没有用户交互的情况下，是否JavaScript可以打开windows
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        /// 设置字体大小(最小的字体大小)
//        preferences.minimumFontSize = 40.0;
        /// 设置偏好设置对象
        configuration.preferences = preferences;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.scrollView.backgroundColor = [UIColor whiteColor];
        _wkWebView.scrollView.showsVerticalScrollIndicator = false;
        _wkWebView.scrollView.showsHorizontalScrollIndicator = false;
        
        DisableAutoAdjustScrollViewInsets(_wkWebView.scrollView, self);
    }
    return _wkWebView;
}

@end
