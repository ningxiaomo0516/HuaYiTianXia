//
//  TTWebViewController.m
//  CodeShangFu
//
//  Created by 宁小陌 on 2018/10/25.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import "TTWebViewController.h"

@interface TTWebViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,
UIApplicationDelegate,UIScrollViewDelegate,WKNavigationDelegate,WKUIDelegate>
@property(nonatomic, assign)CGRect reminderBtnFrame;
/** 主页URL */
@property(nonatomic, strong) NSURL *url;
/** 保存当前请求的URL */
@property(nonatomic, strong) NSURL *currentUrl;

@end

@implementation TTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    //开启调试信息
    [WebViewJavascriptBridge enableLogging];
    
    // 给webView建立JS与OC的沟通桥梁
    self.javascriptBridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    // 设置代理，如果不需要实现，可以不设置
    [self.javascriptBridge setWebViewDelegate:self];
    
    [self initView];
    [self setUPUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

- (void) initView{
    [self.view addSubview:self.progressView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.webView);
        make.height.equalTo(@(1));
    }];
}

- (void) netWordSatus:(NSNotification*)notification{
    NSInteger status = ((NSNumber*)notification.userInfo[@"status"]).integerValue;
    if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
        self.reminderBtn.hidden = YES;
    }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
        self.reminderBtn.hidden = YES;
    }else if(status == AFNetworkReachabilityStatusNotReachable){
        Toast(@"请检查网络状态是否正常");
        self.reminderBtn.hidden = NO;
    }
}

#pragma mark -- 加载本地文件
- (void) loadWebViewURLString:(NSString *)URLString{
    // 设置访问的URL
    self.url = [NSURL URLWithString:URLString];
    [self requestWebViewURL:self.url];
}

- (void) requestWebViewURL:(NSURL *)currentUrl{
    // 根据URL创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:currentUrl];
    [request setHTTPMethod: @"POST"];
    // WKWebView加载请求
    [self.webView loadRequest:request];
}

#pragma mark - KVO
// 计算wkWebView进度条和获取title
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        float estimateProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        [self.progressView setProgress:estimateProgress animated:YES];
    }else if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView) {
            self.title = self.webView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

#pragma mark - WKNavigationDelegate
///页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.reminderBtn.hidden = YES;
    self.webView.hidden = NO;
    [self.progressView setHidden:NO];
    [self.progressView setProgress:0.1 animated:YES];
}

/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.progressView setProgress:1.0 animated:YES];
    [self.progressView setHidden:YES];
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.reminderBtn.hidden = NO;
    self.progressView.hidden = YES;
    [self.progressView setHidden:YES];
}

// 滑动后隐藏键盘
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [scrollView endEditing:YES];
}

- (WKWebView *)webView {
    if (!_webView) {
        //以下代码适配大小
        NSString *jScript = @"var script = document.createElement('meta');"
        "script.name = 'viewport';"
        "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
        "document.getElementsByTagName('head')[0].appendChild(script);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:wkWebConfig];
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        _webView.scrollView.scrollEnabled = YES;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //        _webView.scrollView.bounces = false;
        _webView.UIDelegate = self;
        // 隐藏水平和垂直方向的滚动条
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.opaque = NO;
        
        DisableAutoAdjustScrollViewInsets(_webView.scrollView, self);
        [_webView sizeToFit];
    }
    return _webView;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.frame = CGRectMake(0, 0, self.webView.width, 0.7);
        _progressView.progressTintColor= kColorWithRGB(44, 248, 152);//设置已过进度部分的颜色
        _progressView.trackTintColor= [kWhiteColor colorWithAlphaComponent:0.5];//设置未过进度部分的颜色
        _progressView.backgroundColor = [UIColor groupTableViewBackgroundColor];//设置背景色
        [self.view insertSubview:_progressView aboveSubview:self.navigationController.navigationBar];
    }
    return _progressView;
}

/**
 * 设置界面
 */
- (void)setUPUI {
    [self.view addSubview:self.reminderBtn];
    if (CGRectGetMaxY(self.reminderBtnFrame) > 0.0) {
        self.reminderBtn.frame = self.reminderBtnFrame;
    }else{
        [self.reminderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.equalTo(self.view);
            make.height.equalTo(@(30));
        }];
    }
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        self.reminderBtn.hidden = NO;
    }
}

- (void)adjustmentReminderBtnFrame:(CGRect)frame{
    self.reminderBtnFrame = frame;
}

-(UIButton *)reminderBtn{
    if (!_reminderBtn) {
        _reminderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reminderBtn.hidden = YES;
        _reminderBtn.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Regular" size:17];;
        [_reminderBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        _reminderBtn.backgroundColor = [UIColor clearColor];
        [_reminderBtn addTarget:self action:@selector(reminderBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_reminderBtn setTitle:@"点击这里重新加载" forState:UIControlStateNormal];
    }
    return _reminderBtn;
}

-(void)reminderBtnClicked{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        self.reminderBtn.hidden = NO;
    }else{
        self.reminderBtn.hidden = YES;
    }
    if ([self respondsToSelector:@selector(reLoadVCData)]) {
        [self requestWebViewURL:self.currentUrl];
    }
    TTLog(@"重新加载");
}

-(void)reLoadVCData{
    [self.webView reload];
}

@end
