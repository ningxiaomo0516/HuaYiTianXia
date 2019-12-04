//
//  YKReceiveWineViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/14.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKReceiveWineViewController.h"
#import <WebKit/WebKit.h>

@interface YKReceiveWineViewController ()

@end

@implementation YKReceiveWineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首次下单送豪礼";
    [self loadWebViewHtml:@"index2.html"];
//    [self loadWebViewURLString:self.webURL];
    [self registLocationFunction];
    [self setupWebViewJavascriptBridgeCallbacks];
}

- (void)registLocationFunction{
    [self.javascriptBridge registerHandler:@"locationClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 获取位置信息
        NSString *location = @"广东省深圳市南山区学府路00000000号";
        // 将结果返回给js
        responseCallback(location);
    }];
    
    [self.javascriptBridge registerHandler:@"locationCallBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        MVLog(@"js call getUserIdFromObjC : %@", data);
        
        self.title = data[@"content"];
        Toast(data[@"time"]);
    }];
    
    [self.javascriptBridge registerHandler:@"submitclickcallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        MVLog(@"js call getUserIdFromObjC : %@", data);
        
//        self.title = data[@"content"];
//        Toast(data[@"time"]);
    }];
    
    [self.javascriptBridge registerHandler:@"submitclickcallback2" handler:^(id data, WVJBResponseCallback responseCallback) {
        MVLog(@"js call getUserIdFromObjC : %@", data);
        
                Toast(@"卧槽");
    }];
}

//点击js事件 js向oc通信(触发oc事件)
-(void)setupWebViewJavascriptBridgeCallbacks{
    /// 扫描二维码appCallBack callAppfinish
    [self.javascriptBridge registerHandler:@"finish" handler:^(id data, WVJBResponseCallback responseCallback) {
        MVLog(@"js call getUserIdFromObjC : %@", data);
    }];
    
}

@end
