//
//  TXGoodsH5TableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/2.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXGoodsH5TableViewCell.h"

@interface TXGoodsH5TableViewCell ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) UIButton *reloadButton;
/// 记录最后的height
@property (nonatomic, assign) CGFloat endHeight;
@end

@implementation TXGoodsH5TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.webUrl = @"http://47.107.179.43:80/yq/invation/goodsDetails.html?id=61&status=1";
        [self initView];
//        self.webUrl = @"http://www.baidu.com";
        [self loadData];
    }
    return self;
}

//// 加载数据
- (void)loadData {
    if (self.webUrl.length == 0 || ![self.webUrl hasPrefix:@"http:"]) {
        MVLog(@"缺少链接");
        return;
    }
    NSURL* url = [NSURL URLWithString:self.webUrl];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
//    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
    [self.wkWebView loadRequest:request];
    
}

- (void) handleButtonTapped:(UIButton *)sender{
    self.wkWebView.hidden = NO;
    self.reloadButton.hidden = YES;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
}


- (void) initView{
    [self addSubview:self.wkWebView];
    [self addSubview:self.reloadButton];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
    }];
}

#pragma mark - WKNavigationDelegate
/// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.reloadButton.hidden = YES;
    self.wkWebView.hidden = NO;
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
/// 5 页面加载完成之后调用(此方法会调用多次)
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    /// 获取网页正文全文高，刷新cell
//    MV(weakSelf)
    __block CGFloat webViewHeight;
    self.height = webView.frame.size.height;//  document.body.scrollHeight
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以，但如果是和我一样直接加载原站内容使用前者更合适
        //获取页面高度，并重置webview的frame
        //因为WKWebView的contentSize在加载的时候是不断变化的，可能高度已经获取出来了但是还在刷新，然后又获取到相同的高度，所以当高度相同的时候我们不刷新tableview，高度不相同的时候我们刷新tableView获取最新值
        webViewHeight = [result floatValue];
        NSLog(@"wwowowowowowwowowoo ----- %f",webViewHeight);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (webViewHeight != self.height) {
                webView.frame = CGRectMake(0, 0, self.width, webViewHeight);
//                [self.tableView reloadData];
                
            }
        });
    }];
    
    NSLog(@"结束加载");
}



- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    TTLog(@"点击了链接URL%@",URL);
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    TTLog(@"点击了图片%@",textAttachment);
    return YES;
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.reloadButton.hidden = NO;
    self.wkWebView.hidden = YES;
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
        /// 使用H5播放视频
        configuration.allowsInlineMediaPlayback = YES;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _wkWebView.frame = CGRectMake(0, 0, self.width, 0);
        _wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.scrollView.backgroundColor = [UIColor whiteColor];
        _wkWebView.scrollView.showsVerticalScrollIndicator = false;
        _wkWebView.scrollView.showsHorizontalScrollIndicator = false;
        _wkWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _wkWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        _wkWebView.scrollView.scrollEnabled = NO;//禁止滚动，防止与UITableView冲突
        //监听webView.scrollView的contentSize属性
//        [_wkWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        _wkWebView.navigationDelegate = self;
        [_wkWebView sizeToFit];
    }
    return _wkWebView;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        MV(weakSelf);
        //执行js方法"document.body.offsetHeight" ，获取webview内容高度
        [_wkWebView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            CGFloat contentHeight = [result floatValue];
            TTLog(@"计算后的高度  -- %f",contentHeight);
            if (weakSelf.refreshWebViewHeightBlock) {
                weakSelf.refreshWebViewHeightBlock(contentHeight);
            }
        }];
    }
}

- (void)dealloc{
    [_wkWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
