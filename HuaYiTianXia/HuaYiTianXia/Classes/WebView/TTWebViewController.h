//
//  TTWebViewController.h
//  CodeShangFu
//
//  Created by 宁小陌 on 2018/10/25.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import "WebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTWebViewController : TTBaseViewController <UIWebViewDelegate>
/// 网页进度条
@property (strong, nonatomic) UIProgressView *progressView;
/// 定义web
@property (strong, nonatomic) WKWebView *webView;
/// 插件
@property WebViewJavascriptBridge *javascriptBridge;
/// H5 网页地址
@property (strong, nonatomic) NSString *webURL;
/// 用户ID
@property (copy, nonatomic) NSString *userID;
/// 用户Token
@property (copy, nonatomic) NSString *userToken;

/// 加载网络 Html
- (void) loadWebViewURLString:(NSString *) URLString;
/// 加载本地 Html
- (void) loadWebViewHtml:(NSString *) URLString;
/// 重新加载按钮
@property(nonatomic, strong)UIButton* reminderBtn;
///调整按钮位置
-(void)adjustmentReminderBtnFrame:(CGRect)frame;
///重新加载数据
-(void)reLoadVCData;
@end

NS_ASSUME_NONNULL_END
