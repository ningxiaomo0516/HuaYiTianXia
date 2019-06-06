//
//  TXPurchaseAgreementViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPurchaseAgreementViewController.h"
#import <WebKit/WebKit.h>
#import "TXSignatureView.h"

@interface TXPurchaseAgreementViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *agreedButton;
@end

@implementation TXPurchaseAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view lz_setCornerRadius:10.0];
    [self initView];
    NSString *textStr = [NSString stringWithFormat:@"%@&money=%@",kUserInfo.userid,self.amountText];
    self.webUrl = kAppendH5URL(DomainName, NBElectronicAgreementH5,textStr);
//    self.webUrl = @"http://www.baidu.com";
    [self loadData];
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
    if (sender.tag==100) {
        self.wkWebView.hidden = NO;
        self.reloadButton.hidden = YES;
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    }else if(sender.tag == 120){
//        [self sc_dismissVC];
        [kNotificationCenter postNotificationName:@"AgreeDealBlockNotice" object:nil];
    }else{
        [self sc_dismissVC];
    }
}

- (void)didTapPopButton:(UIBarButtonItem *)barButtonItem {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void) initView{
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progress];
    [self.view addSubview:self.reloadButton];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.agreedButton];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.closeButton.mas_top);
    }];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(1);
    }];
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.view);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(44));
        make.left.equalTo(@(10));
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.right.equalTo(self.agreedButton.mas_left).offset(-5);
        make.width.equalTo(self.agreedButton);
    }];
    [self.agreedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.width.height.centerY.equalTo(self.closeButton);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    
    self.view.backgroundColor = kWhiteColor;
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

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitleColor:kTextColor51 forState:UIControlStateNormal];
        [_closeButton setTitle:@"不同意" forState:UIControlStateNormal];
        _closeButton.titleLabel.font = kFontSizeMedium15;
        _closeButton.tag = 110;
        [_closeButton lz_setCornerRadius:5.0];
        [_closeButton setBorderColor:kColorWithRGB(214, 214, 214)];
        [_closeButton setBorderWidth:1.0];
        [_closeButton setBackgroundImage:imageColor(kWhiteColor) forState:UIControlStateNormal];
        [_closeButton setBackgroundImage:imageColor(kTextColor244) forState:UIControlStateHighlighted];
        MV(weakSelf);
        [_closeButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf handleButtonTapped:weakSelf.closeButton];
        }];
    }
    return _closeButton;
}

- (UIButton *)agreedButton{
    if (!_agreedButton) {
        _agreedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreedButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_agreedButton setTitle:@"同意" forState:UIControlStateNormal];
        _agreedButton.titleLabel.font = kFontSizeMedium15;
        _agreedButton.tag = 120;
        [_agreedButton lz_setCornerRadius:5.0];
        [_agreedButton setBorderColor:kTextColor51];
        [_agreedButton setBackgroundImage:imageColor(kColorWithRGB(57, 148, 250)) forState:UIControlStateNormal];
        [_agreedButton setBackgroundImage:imageColor(kColorWithRGB(51, 142, 244)) forState:UIControlStateHighlighted];
        MV(weakSelf);
        [_agreedButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf handleButtonTapped:weakSelf.agreedButton];
        }];
    }
    return _agreedButton;
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

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"设备投资协议" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

@end
