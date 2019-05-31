//
//  TXMallGoodsDetailsViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMallGoodsDetailsViewController.h"
#import "TXMallGoodsBannerTableViewCell.h"
#import "TXMallGoodsDetailsTableViewCell.h"
#import "TXMallGoodsSpecTableViewCell.h"
#import "TXBuyCountTableViewCell.h"
#import "TXShareViewController.h"
#import "TXSubmitOrderViewController.h"
#import "TXWebViewController.h"
#import "TXPayOrderViewController.h"
#import "TXChoosePayViewController.h"
#import "TXLoginViewController.h"
#import <WebKit/WebKit.h>

static NSString * const reuseIdentifierBanner   = @"TXMallGoodsBannerTableViewCell";
static NSString * const reuseIdentifierDetails  = @"TXMallGoodsDetailsTableViewCell";
static NSString * const reuseIdentifierSpec     = @"TXMallGoodsSpecTableViewCell";
static NSString * const reuseIdentifierBuynum   = @"TXBuyCountTableViewCell";
@interface TXMallGoodsDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,
TXMallGoodsSpecTableViewCellDelegate,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIView *footerView;

/// 列表页传过来的Model
@property (strong, nonatomic) NewsRecordsModel *productModel;
/// 产品详情
@property (strong, nonatomic) NewsModel *productData;
/// 传入支付中心的model数据
@property (strong, nonatomic) NewsRecordsModel *model;

@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@property (nonatomic, assign) CGFloat sectionHeight;//缓存高度
@property (nonatomic, assign) CGFloat webH5Height;// WebView_H5_高度
@property (nonatomic, assign) BOOL isload;// WebView_H5_高度


@property (assign, nonatomic) CGFloat webViewHeight;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, strong) SCShareModel *shareModel;
/// 购买数量
@property (nonatomic, assign) NSInteger buyCount;
@end

@implementation TXMallGoodsDetailsViewController
- (id)initMallProductModel:(NewsRecordsModel *)productModel{
    if ( self = [super init] ){
        self.productModel = productModel;
        self.buyCount = 1;
        self.isload = NO;
        self.tableView.hidden = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [self createWebView];
    [self initView];
    [self.view showLoadingViewWithText:@"请稍后"];
    [self loadMallGoodsDetailsData];
}

- (void) loadMallGoodsDetailsData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.productModel.status) forKey:@"status"];
    [parameter setObject:self.productModel.kid forKey:@"id"];  // 每页条数
    
    [SCHttpTools postWithURLString:@"shopproduct/GetShopDetails" parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.productData = [NewsModel mj_objectWithKeyValues:result];
            self.isload = YES;
            self.tableView.hidden = NO;
            [self.tableView reloadData];
            self.noDataView.hidden = YES;
        }else{
            Toast(@"获取产品详情数据失败");
            self.noDataView.hidden = NO;
        }
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        [self.view dismissLoadingView];
        self.noDataView.hidden = NO;
    }];
}

/// 立即投保
- (void) saveBtnClick:(UIButton *)sender{
    TTLog(@"self.pageType -- %ld",self.pageType);
    if (kUserInfo.isLogin) {
        if (self.pageType == 0) {
            ///// 记录当前是商城购买
            kUserInfo.topupType = 2;
            [kUserInfo dump];
            TXSubmitOrderViewController *vc = [[TXSubmitOrderViewController alloc] initNewsRecordsModel:self.model];
            TTPushVC(vc);
        }else if(self.pageType == 1){
            if (kUserInfo.isValidation==2) {
                ///// 记录当前是农保购买
                kUserInfo.topupType = 3;
                [kUserInfo dump];
                TXPayOrderViewController *vc = [[TXPayOrderViewController alloc] initNewsRecordsModel:self.model];
                vc.totalPriceBlock = ^(NSString * _Nonnull totalPrice) {
                    //            model.price = totalPrice;
                };
                [self sc_bottomPresentController:vc presentedHeight:IPHONE6_W(kiPhoneX_T(420)) completeHandle:^(BOOL presented) {
                    if (presented) {
                        TTLog(@"弹出了");
                    }else{
                        TTLog(@"消失了");
                    }
                }];
            }else if(kUserInfo.isValidation==1){
                Toast(@"实名认证审核中,请稍后再试!");
            }else{
                // 立即认证提示
                UIAlertController *alerController = [UIAlertController addAlertReminderText:@"提示"
                                                                                    message:@"是否立即实名认证?"
                                                                                cancelTitle:@"好的"
                                                                                    doTitle:@"去设置"//去设置
                                                                             preferredStyle:UIAlertControllerStyleAlert
                                                                                cancelBlock:nil doBlock:^{
                                                                                    [self jumpSetRealNameRequest];
                                                                                }];
                [self presentViewController:alerController animated:YES completion:nil];
            }
        }
    }else{
        TXLoginViewController *view = [[TXLoginViewController alloc] init];
        LZNavigationController *navigation = [[LZNavigationController alloc] initWithRootViewController:view];
        [self presentViewController:navigation animated:YES completion:^{
            TTLog(@"个人信息修改");
        }];
    }
}


- (void) jumpSetRealNameRequest{
    
}

/// 分享到第三方平台
- (void)didTapShareButton:(UIBarButtonItem *)barButtonItem {
    TXShareViewController *vc = [[TXShareViewController alloc] init];
    CGFloat height = IPHONE6_W(150)+kTabBarHeight;
    vc.shareModel = self.shareModel;
    [self sc_bottomPresentController:vc presentedHeight:height completeHandle:^(BOOL presented) {
        if (presented) {
            TTLog(@"弹出了");
        }else{
            TTLog(@"消失了");
        }
    }];
}

/**
 *  点击增加按钮
 *  tag:0 增加 tag:1 减少
 *  @param sender 当前按钮
 */
- (void)onClickBtn:(UIButton *)sender {
    if (sender.tag==0) {
        self.buyCount += 1;
    }else{
        self.buyCount = (self.buyCount<2) ? 1 : (self.buyCount-= 1);
    }
    self.model.buyCount = self.buyCount;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark ---- 界面布局设置
- (void)initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    
    [self.view addSubview:self.tableView];
  
    
    [self.view addSubview:self.footerView];
    [self.footerView addSubview:self.saveButton];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(kTabBarHeight);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(IPHONE6_W(45)));
        make.right.left.equalTo(self.footerView);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];

    
    UIImage *rightImg = kGetImage(@"live_btn_share");
    rightImg = [rightImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:rightImg
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(didTapShareButton:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.productData.data.count>0) {
        self.model = self.productData.data[0];
        self.model.buyCount = self.buyCount;
    }
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            TXMallGoodsBannerTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
            tools.isPageControl = YES;
            tools.bannerArray = self.model.banners;
            return tools;
        }else{
            TXMallGoodsDetailsTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDetails forIndexPath:indexPath];
            tools.model = self.model;
            return tools;
        }
    }else if(indexPath.section==1){
        TXMallGoodsSpecTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSpec forIndexPath:indexPath];
        tools.delegate = self;
        tools.tagView.dataArray = self.model.prospec;
        tools.indexPath = indexPath;
        return tools;
    }else if(indexPath.section==2){
        TXBuyCountTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierBuynum forIndexPath:indexPath];
        MV(weakSelf)
        [tools.minusBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf onClickBtn:tools.minusBtn];
        }];
        [tools.increaseBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf onClickBtn:tools.increaseBtn];
        }];
        if (self.pageType==0) {
            tools.boxView.hidden = NO;
            tools.buyNumLabel.text = [NSString stringWithFormat:@"%ld",(long)self.buyCount];
        }else if (self.pageType==1){
            tools.buyCountLabel.hidden = NO;
            tools.buyCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.buyCount];
        }else{
            Toast(@"未知页面");
        }
        return tools;
    }else{
        UITableViewCell *webCell = [tableView dequeueReusableCellWithIdentifier:@"WebViewCell" forIndexPath:indexPath];
        NSString *parameter = [NSString stringWithFormat:@"%@&status=%ld",
                               self.productModel.kid,(long)self.productModel.status];
        NSString *URLStr = kAppendH5URL(DomainName, GoodsDetailsH5, parameter);
        NSURL *url = [NSURL URLWithString:URLStr];
        self.shareModel.h5Url = URLStr;
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        if (self.isload) {
            self.isload = NO;
            [self.wkWebView loadRequest:urlRequest];
        }
        [webCell.contentView addSubview:self.scrollView];
        return webCell;
    }
    return [UITableViewCell new];
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return 2;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) return IPHONE6_W(250);
        else return IPHONE6_W(90);
    }
    if (indexPath.section==1) return IPHONE6_W(50);
    if (indexPath.section==2) return IPHONE6_W(50);
    if (indexPath.section==3){
        return self.webViewHeight;
    }
    return UITableViewAutomaticDimension;
}

#pragma mark ====== 更新规格的高度 ======
- (void)updateTableViewCellHeight:(TXMallGoodsSpecTableViewCell *)cell andheight:(CGFloat)height {
    self.sectionHeight = height;
    TTLog(@"height -- %f",height);
//    if (![self.heightAtIndexPath[indexPath] isEqualToNumber:@(height)]) {
//        self.heightAtIndexPath[indexPath] = @(height);
//        [self.tableView reloadData];
        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:2];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
}

- (void)didToolsSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath withContent:(nonnull NSString *)content {
    TTLog(@"content --- %@",content);
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXMallGoodsBannerTableViewCell class] forCellReuseIdentifier:reuseIdentifierBanner];
        [_tableView registerClass:[TXMallGoodsDetailsTableViewCell class] forCellReuseIdentifier:reuseIdentifierDetails];
        [_tableView registerClass:[TXMallGoodsSpecTableViewCell class] forCellReuseIdentifier:reuseIdentifierSpec];
        [_tableView registerClass:[TXBuyCountTableViewCell class] forCellReuseIdentifier:reuseIdentifierBuynum];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WebViewCell"];

        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kWhiteColor;
    }
    return _tableView;
}

- (void)dealloc{
    [self.wkWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        // 方法一
        UIScrollView *scrollView = (UIScrollView *)object;
        CGFloat height = scrollView.contentSize.height;
        self.webViewHeight = height;
        self.wkWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, height);
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:3], nil] withRowAnimation:UITableViewRowAnimationNone];
    }else if([keyPath isEqualToString:@"title"]){
        if (object == self.wkWebView) {
            TTLog(@"self.wkWebView.title --- %@",self.wkWebView.title);
            self.shareModel.descriptStr = self.wkWebView.title;
            self.shareModel.sharetitle = self.wkWebView.title;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
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
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1) configuration:wkWebConfig];
    self.wkWebView.backgroundColor = [UIColor clearColor];
    self.wkWebView.opaque = NO;
    self.wkWebView.userInteractionEnabled = NO;
    self.wkWebView.scrollView.bounces = NO;
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.wkWebView sizeToFit];
    [self.wkWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [self.scrollView addSubview:self.wkWebView];
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_saveButton cornerRadius:0];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf saveBtnClick:self.saveButton];
        }];
    }
    return _saveButton;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _footerView;
}

- (NSMutableDictionary *)heightAtIndexPath {
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [[NSMutableDictionary alloc] init];
    }
    return _heightAtIndexPath;
}

- (SCShareModel *)shareModel{
    if (!_shareModel) {
        _shareModel = [[SCShareModel alloc] init];
    }
    return _shareModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
