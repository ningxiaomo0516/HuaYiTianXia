//
//  TXCharterMachineChildViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/31.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterMachineChildViewController.h"
#import <WebKit/WebKit.h>
#import "TXShareViewController.h"

@interface TXCharterMachineChildViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) SCShareModel *shareModel;
@property (nonatomic, strong) UIButton *saveButton;
@end

@implementation TXCharterMachineChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    //    self.webUrl = @"http://www.baidu.com";
    [self loadData];
    self.title = @"航班详情";
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
    self.shareModel.h5Url = self.webUrl;
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

}

/// 清除全部缓存
- (void)deleteWebCache {
    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}

/// 自定义清除缓存
- (void)customDeleteWebCache {
    /*
     在磁盘缓存上。
     WKWebsiteDataTypeDiskCache,
     
     html离线Web应用程序缓存。
     WKWebsiteDataTypeOfflineWebApplicationCache,
     
     内存缓存。
     WKWebsiteDataTypeMemoryCache,
     
     本地存储。
     WKWebsiteDataTypeLocalStorage,
     
     Cookies
     WKWebsiteDataTypeCookies,
     
     会话存储
     WKWebsiteDataTypeSessionStorage,
     
     IndexedDB数据库。
     WKWebsiteDataTypeIndexedDBDatabases,
     
     查询数据库。
     WKWebsiteDataTypeWebSQLDatabases
     */
    NSArray * types=@[WKWebsiteDataTypeCookies,WKWebsiteDataTypeLocalStorage,WKWebsiteDataTypeDiskCache,
                      WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeOfflineWebApplicationCache];
    
    NSSet *websiteDataTypes= [NSSet setWithArray:types];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}

- (void) removeWebCache{
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                               NSUserDomainMask, YES)[0];
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                            objectForKey:@"CFBundleIdentifier"];
    NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
    NSString *webKitFolderInCaches = [NSString
                                      stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
    NSString *webKitFolderInCachesfs = [NSString
                                        stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    
    NSError *error;
    /* iOS8.0 WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
    
    /* iOS7.0 WebView Cache的存放路径 */
    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
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
    [self.view addSubview:self.saveButton];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.saveButton.mas_top);
    }];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerX.equalTo(self.view);
        make.height.equalTo(@(IPHONE6_W(45)));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    
    /// 清除当前网页全部缓存
    [self deleteWebCache];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    self.wkWebView.navigationDelegate = nil;
    self.wkWebView.UIDelegate = nil;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        float estimateProgress = [change[NSKeyValueChangeNewKey] doubleValue];
        [self.progress setProgress:estimateProgress animated:YES];
    }else if([keyPath isEqualToString:@"title"]){
        if (object == self.wkWebView) {
            self.shareModel.descriptStr = self.wkWebView.title;
            self.shareModel.sharetitle = self.wkWebView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    //    else {
    //        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    //    }
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

- (SCShareModel *)shareModel{
    if (!_shareModel) {
        _shareModel = [[SCShareModel alloc] init];
    }
    return _shareModel;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.tag = 2;
        [_saveButton setTitle:@"立 即 预 定" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_saveButton cornerRadius:0];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf handleControlEvent:self.saveButton];
        }];
    }
    return _saveButton;
}
@end
