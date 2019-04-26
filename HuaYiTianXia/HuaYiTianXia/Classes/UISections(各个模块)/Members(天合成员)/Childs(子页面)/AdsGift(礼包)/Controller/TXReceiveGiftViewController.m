//
//  TXReceiveGiftViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXReceiveGiftViewController.h"
#import "TXReceiveAddressTableViewCell.h" 
#import "TXAddressModel.h"
#import <WebKit/WebKit.h>

static NSString * const reuseIdentifierReceiveAddress = @"TXReceiveAddressTableViewCell";
@interface TXReceiveGiftViewController ()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) AddressModel  *addressModel;
@property (nonatomic, assign) NSInteger     addressNum;

@property (nonatomic, assign) CGFloat       webViewHeight;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) WKWebView     *webView;
/**添加的footView*/
@property (nonatomic ,strong) UIView        *footerView;
/// 提交按钮
@property (nonatomic, strong) UIButton      *submitButton;
@end

@implementation TXReceiveGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addressModel = [[AddressModel alloc] init];
    [self getAddressModel];
    self.webViewHeight = 0.0;
    [self initView];
    self.title = @"礼包详情";
}

#pragma mark ---- 界面布局设置
- (void)initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [self.footerView addSubview:self.submitButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(kTabBarHeight));
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat height = IPHONE6_W(35);
        CGFloat top = (kTabBarHeight-height-kSafeAreaBottomHeight)/2;
        make.right.equalTo(self.footerView.mas_right).offset(IPHONE6_W(-15));
        make.height.equalTo(@(height));
        make.width.equalTo(@(IPHONE6_W(85)));
        make.top.equalTo(@(top));
    }];
    [self createWebView];
}

- (void) submitBtnClick:(UIButton *)sender{
    kShowMBProgressHUD(self.view);
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.model.libaoId forKey:@"id"];
    [parameter setObject:self.addressModel.sid forKey:@"id"];
    [SCHttpTools getWithURLString:kHttpURL(@"parcel/UserToParcel") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTUserDataModel *model = [TTUserDataModel mj_objectWithKeyValues:result];
            if (model.errorcode==20000) {
                Toast(@"礼包领取成功");
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                Toast(model.message);
            }
        }
        kHideMBProgressHUD(self.view);
    } failure:^(NSError *error) {
        TTLog(@"礼包领取 -- %@", error);
        kHideMBProgressHUD(self.view);
    }];
}

/// 获取默认收货地址
- (void) getAddressModel{
    [SCHttpTools getWithURLString:kHttpURL(@"address/GetAddress") parameter:nil success:^(id responseObject) {
        NSDictionary *results = responseObject;
        if ([results isKindOfClass:[NSDictionary class]]) {
            TXAddressModel *addressModel = [TXAddressModel mj_objectWithKeyValues:results];
            if (addressModel.errorcode == 20000) {
                self.addressNum = addressModel.data.count;
                for (AddressModel *model in addressModel.data) {
                    if (model.isDefault) {
                        self.addressModel = model;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
                    }
                }
                [self.tableView reloadData];
            }else{
                Toast(addressModel.message);
            }
        }
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
    }];
}


#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            TXReceiveAddressTableViewCell*tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiveAddress forIndexPath:indexPath];
            tools.nicknameLabel.text = self.addressModel.username;//@"李阿九";
            tools.telphoneLabel.text = self.addressModel.telphone;//@"13566667888";
            tools.addressLabel.text = self.addressModel.address;//@"四川 成都 高新区 环球中心W6区 1518室";
            tools.addButton.userInteractionEnabled = NO;
            if ((self.addressNum==0)&&(!self.addressModel.isDefault)) {
                tools.imagesView.hidden = YES;
                tools.imagesView.hidden = NO;
            }
            return tools;
        }
        case 1:{
//            UITableViewCell *webCell = [tableView dequeueReusableCellWithIdentifier:@"WebViewCell" forIndexPath:indexPath];
////            NSString *str = kAppendH5URL(DomainName, GoodsDetailsH5, parameter);
//            NSString *urlstr = [NSString stringWithFormat:@"http://192.168.1.5/libao/index.html?type=1&userID=%@",kUserInfo.userid];
//            NSURL *url = [NSURL URLWithString:urlstr];
//            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//            [self.webView loadRequest:urlRequest];
//            [webCell.contentView addSubview:self.scrollView];
            UITableViewCell * webCell = [tableView dequeueReusableCellWithIdentifier:@"WebViewCell"];
            if (!webCell) {
                webCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WebViewCell"];
            }
            [webCell.contentView addSubview:self.scrollView];
            return webCell;
        }
    }
    return [UITableViewCell new];
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) return IPHONE6_W(70);
    if (indexPath.section==1) return self.webViewHeight;
    return IPHONE6_W(50);
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==2) return 0;
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXReceiveAddressTableViewCell class] forCellReuseIdentifier:reuseIdentifierReceiveAddress];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
    }
    return _tableView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _footerView;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _submitButton.titleLabel.font = kFontSizeMedium15;
        [_submitButton setTitle:@"领取" forState:UIControlStateNormal];
        UIImage *image = [UIImage lz_imageWithColor:kColorWithRGB(211, 0, 0)];
        [_submitButton setBackgroundImage:image forState:UIControlStateNormal];
        [_submitButton lz_setCornerRadius:3.0];
        MV(weakSelf);
        [_submitButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf submitBtnClick:self.submitButton];
        }];
    }
    return _submitButton;
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
    }
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
    NSString *str = [NSString stringWithFormat:@"http://192.168.1.5/libao/index2.html?id=%@",self.model.libaoId];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [self.scrollView addSubview:self.webView];
}

@end
