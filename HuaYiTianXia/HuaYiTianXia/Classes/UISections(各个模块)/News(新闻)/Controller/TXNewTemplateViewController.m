
//
//  TXNewTemplateViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXNewTemplateViewController.h"
#import "TXNewTemplateTableViewCell.h"
#import "TXMallGoodsBannerTableViewCell.h"
#import "TXNewMultipleImageTableViewCell.h"
#import "TXNewsModel.h"
#import "TXWebViewController.h"
#import <JhtMarquee/JhtVerticalMarquee.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>

static NSString * const reuseIdentifierBanner = @"TXMallGoodsBannerTableViewCell";

@interface TXNewTemplateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 每页多少数据
@property (nonatomic, assign) NSInteger pageSize;
/// 当前页
@property (nonatomic, assign) NSInteger pageIndex;
/// 横向 跑马灯
@property (nonatomic, strong) JhtHorizontalMarquee *horizontalMarquee;
@property (nonatomic, copy) NSString *rollText;

@end

@implementation TXNewTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageSize = 20;
    self.pageIndex = 1;
    self.rollText = @"";
    [self initView];
    [self initViewConstraints];
    [self.view showLoadingViewWithText:@"加载中..."];
    [self loadNewsData];
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //将页码重新置为1
        self.pageIndex = 1;
        [self loadNewsData];
    }];
    /// 上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pageIndex++;// 页码+1
        [self loadNewsData];
    }];
    [self loadRollLabelData];
    [kNotificationCenter addObserver:self selector:@selector(receiveNotification:) name:@"dealwithNewPushMessage" object:nil];
}

- (void)receiveNotification:(NSNotification *)infoNotification {
    NSDictionary *resultDic = [infoNotification userInfo];
    NSString *kid = [resultDic lz_objectForKey:@"info"];
    NSString *messageType = [resultDic lz_objectForKey:@"messageType"];
    
    NSString *webURL = @"http://www.baidu.com";
    if (messageType.integerValue==4) { //// 拼接公告地址
        webURL = kAppendH5URL(DomainName, PushDetailsH5, kid);
    }else if (messageType.integerValue==6) {/// 新闻
        webURL = kAppendH5URL(DomainName, NewsDetailsH5, kid);
    }
    [self jumpNewDetailsBannerModel:webURL];
}

-(void)jumpNewDetailsBannerModel:(NSString*)webURL{
    TXWebViewController *vc = [[TXWebViewController alloc] init];
    vc.title = @"新闻详情";
    vc.webUrl = webURL;
    TTPushVC(vc);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 开启跑马灯
    [self.horizontalMarquee marqueeOfSettingWithState:MarqueeStart_H];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 关闭跑马灯
    [self.horizontalMarquee marqueeOfSettingWithState:MarqueeShutDown_H];
}

/// 获取跑马灯数据
- (void) loadRollLabelData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    /// 1:首页跑马灯消息 2:
    [parameter setObject:@(1) forKey:@"status"];
    [SCHttpTools postWithURLString:@"notice/GetNotice" parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TTLog(@"result -- %@",result);
        TXNewsArrayModel *model = [TXNewsArrayModel mj_objectWithKeyValues:result];
        if (model.errorcode==20000&&model.data.content!=nil) {
            self.rollText = model.data.content;
            TTLog(@"model.content -- %@",model.data.content);
            self.horizontalMarquee.text = model.data.content;
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
    }];
}

- (void) loadNewsData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.title forKey:@"tabID"];
    [parameter setObject:@(self.pageIndex) forKey:@"page"];     // 当前页
    [parameter setObject:@(self.pageSize) forKey:@"pageSize"];  // 每页条数

    [SCHttpTools postWithURLString:@"news/GetNew" parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXNewsArrayModel *model = [TXNewsArrayModel mj_objectWithKeyValues:result];
        if (model.errorcode==20000) {
            if (self.pageIndex==1) {
                [self.dataArray removeAllObjects];
                [self.bannerArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:model.data.records];
            [self.bannerArray addObjectsFromArray:model.banners];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.view dismissLoadingView];
    }];
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
}


#pragma mark ---- 约束布局
- (void) initViewConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.right.equalTo(self.view);
    }];
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MV(weakSelf)
    if (self.bannerArray.count>0&&indexPath.section==0) {
        TXMallGoodsBannerTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        tools.isPageControl = NO;
        tools.bannerArray = self.bannerArray;
        [tools setImagesDidOnClickCallBlock:^(NewsBannerModel * _Nonnull bannerModel) {
            /// 跳转banner详情
            NSString *webURL = kAppendH5URL(DomainName, NewsDetailsH5, bannerModel.kid)
            [weakSelf jumpNewDetailsBannerModel:webURL];
        }];
        return tools;
    }else if(indexPath.section==1&&self.rollText.length!=0){
        UITableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:@"TTRollLabelWebViewCell" forIndexPath:indexPath];
        tools.backgroundColor = kWhiteColor;
        [tools.contentView addSubview:self.horizontalMarquee];
        tools.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imagesView = [[UIImageView alloc] init];
        [tools.contentView addSubview:imagesView];
        imagesView.image = kGetImage(@"c77_通知");
        [imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(IPHONE6_W(15)));
            make.centerY.equalTo(tools.contentView);
        }];
        [self.horizontalMarquee mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(tools.contentView);
            make.left.equalTo(imagesView.mas_right).offset(5);
        }];
        // 开启跑马灯
        [self.horizontalMarquee marqueeOfSettingWithState:MarqueeStart_H];
        return tools;
    }else{
//        TXNewMultipleImageTableViewCell
//        if (<#condition#>) {
//            <#statements#>
//        }
        TXNewTemplateTableViewCell *tools=[TXNewTemplateTableViewCell cellWithTableViewCell:tableView forIndexPath:indexPath];
        tools.recordsModel = self.dataArray[indexPath.row];
        return tools;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if((self.rollText.length>0&&indexPath.section==1)){
        return IPHONE6_W(25);
    }else{
        return (self.bannerArray.count>0&&indexPath.section==0)?IPHONE6_W(165):UITableViewAutomaticDimension;
    }
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.rollText.length>0) {
        return (self.bannerArray.count>0)?3:1;
    }else{
        return (self.bannerArray.count>0)?2:1;
    }
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((self.bannerArray.count>0&&section==0)||(self.rollText.length>0&&section==1))?1:self.dataArray.count;
}

#pragma mark -------------- 设置Header高度 --------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ((self.bannerArray.count>0&&section==0)||(self.rollText.length>0&&section==1)) {
        return 0.f;
    }else{
        if (self.bannerArray.count==0&&(self.rollText.length>0&&section==0)) {
            return 0.0f;
        }else{
            return 10.0f;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (((self.bannerArray.count>0&&indexPath.section==0)||(indexPath.section==1&&self.rollText.length))) {
        
    }else{
        NewsRecordsModel *model = self.dataArray[indexPath.row];
        NSString *webURL = kAppendH5URL(DomainName, NewsDetailsH5, model.kid)
        [self jumpNewDetailsBannerModel:webURL];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----- getter/setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_tableView registerClass:[TXNewTemplateTableViewCell class] forCellReuseIdentifier:[TXNewTemplateTableViewCell reuseIdentifier]];
        [_tableView registerClass:[TXNewMultipleImageTableViewCell class] forCellReuseIdentifier:[TXNewMultipleImageTableViewCell reuseIdentifier]];
        [_tableView registerClass:[TXMallGoodsBannerTableViewCell class] forCellReuseIdentifier:reuseIdentifierBanner];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TTRollLabelWebViewCell"];
        
        //1 禁用系统自带的分割线
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [[NSMutableArray alloc] init];
    }
    return _bannerArray;
}

/** 横向 跑马灯 */
- (JhtHorizontalMarquee *)horizontalMarquee {
    if (!_horizontalMarquee) {
        _horizontalMarquee = [[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(IPHONE6_W(15), 0, self.view.width-IPHONE6_W(30), IPHONE6_W(25)) singleScrollDuration:0.0];
        _horizontalMarquee.tag = 100;
        _horizontalMarquee.backgroundColor = kClearColor;
        _horizontalMarquee.textColor = kThemeColorHex;
        _horizontalMarquee.font = kFontSizeMedium10;
    }
    
    return _horizontalMarquee;
}

- (void)dealloc{
    [kNotificationCenter removeObserver:self];
}

@end
