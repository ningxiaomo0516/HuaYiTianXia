//
//  TXRecommendedViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXRecommendedViewController.h"
#import <WebKit/WebKit.h>

@interface TXRecommendedViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, strong)  UIButton *reloadButton;
/// 进度条展示
@property (nonatomic, strong) UIProgressView *progress;
@end

@implementation TXRecommendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.webUrl = @"http://a2.rabbitpre.com/m/uYj6Jjm?lc=4&sui=qS0w7BPo&from=timeline&isappinstalled=0&openid=o7kepwdLtLW1UT6ss4SHSOcr48-U&access_token=11_AvHbFw3kSk04hTwR9SG_YZVRwKsJjtt3j2vDel_Nm57JqYDiSIQb-UNWT0IJni1p5h2QVV1nfDo6R0SCLCuOMoPn0Ae3Ax88K6IQj2HFlkQ#from=share";
    self.webUrl = @"http://www.baidu.com";
    [self initView];
    [self loadData];
    self.reloadButton.layer.zPosition = 2;
    UILabel *label = [UILabel lz_labelWithTitle:@"我擦" color:kColorWithRGB(211, 0, 0) font:kFontSizeMedium14];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
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
    self.view.backgroundColor = kWhiteColor;
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.wkWebView.navigationDelegate = nil;
    self.wkWebView.UIDelegate = nil;
}

- (void)initView {
    [self.view addSubview:self.wkWebView];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.right.equalTo(self.view);
    }];
    
//    [self.view addSubview:self.progress];
//    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_offset(0);
//        make.height.mas_equalTo(1);
//    }];
}

- (void) handleButtonTapped:(UIButton *)sender{
    self.wkWebView.hidden = NO;
    self.reloadButton.hidden = YES;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
}

/// 加载数据
- (void)loadData {
    if (self.webUrl.length == 0 || ![self.webUrl hasPrefix:@"http:"]) {
        MVLog(@"缺少链接");
        return;
    }
    NSURL* url = [NSURL URLWithString:self.webUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.wkWebView loadRequest:request];
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

- (UIButton *)reloadButton{
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_reloadButton setTitleColor:HexString(@"#FF4163") forState:UIControlStateNormal];
        [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        _reloadButton.titleLabel.font = kFontSizeMedium15;
        _reloadButton.tag = 100;
        MV(weakSelf);
        [_reloadButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf handleButtonTapped:self.reloadButton];
        }];
    }
    return _reloadButton;
}

- (UIProgressView *)progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progress.frame = CGRectMake(0, 0, self.wkWebView.width, 1);
        _progress.progressTintColor= kColorWithRGB(27, 230, 71);//设置已过进度部分的颜色
        _progress.trackTintColor= kColorWithRGB(210, 210, 210);//设置未过进度部分的颜色
        _progress.backgroundColor = [UIColor groupTableViewBackgroundColor];//设置背景色
        [self.view insertSubview:_progress aboveSubview:self.navigationController.navigationBar];
    }
    return _progress;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 40.0;
        configuration.preferences = preferences;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _wkWebView.backgroundColor = kColorWithRGB(211, 0, 0);
        _wkWebView.scrollView.backgroundColor = [UIColor whiteColor];
        _wkWebView.scrollView.showsVerticalScrollIndicator = false;
        _wkWebView.scrollView.showsHorizontalScrollIndicator = false;
        DisableAutoAdjustScrollViewInsets(_wkWebView.scrollView, self);
    }
    return _wkWebView;
}


@end
