//
//  TXAdsGiftViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXAdsGiftViewController.h"
#import <WebKit/WebKit.h>
#import "TXReceiveGiftViewController.h"
#import "WebViewJavascriptBridge.h"
#import "TXReceiveGiftListViewController.h"

@interface TXAdsGiftViewController ()<WKNavigationDelegate>

@property (nonatomic, copy) NSString *registerid;

@end

@implementation TXAdsGiftViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index1.html" ofType:nil];
//    NSString *localHtml = [NSString stringWithContentsOfFile:urlStr encoding:NSUTF8StringEncoding error:nil];
//    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
//    [self.webView loadHTMLString:localHtml baseURL:fileURL];
    NSString *url = [NSString stringWithFormat:@"http://192.168.1.5/libao/index.html?type=1&userID=%@",kUserInfo.userid];
//    [self loadWebViewURLString:@"http://192.168.1.5/libao/index.html"];
    [self loadWebViewURLString:url];
    [self registLocationFunction];
    
    // 添加右边保存按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"领取记录"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(receiveList)];
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void) receiveList{
    TXReceiveGiftListViewController *vc = [[TXReceiveGiftListViewController alloc] init];
    TTPushVC(vc);
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)registLocationFunction{
    [self.javascriptBridge registerHandler:@"locationClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 获取位置信息
        NSString *location = @"广东省深圳市南山区学府路00000000号";
        // 将结果返回给js
        responseCallback(location);
    }];
    [self.javascriptBridge registerHandler:@"linQu" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 获取位置信息
        // data 的类型与 JS中传的参数有关
        TTLog(@"js call getUserIdFromObjC : %@", data);
        TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:data];
        TTLog(@"js call getUserIdFromObjC : %@", model.libaoId);
        TXReceiveGiftViewController *vc = [[TXReceiveGiftViewController alloc] init];
        vc.model = model;
        TTPushVC(vc);
    }];
}

@end
