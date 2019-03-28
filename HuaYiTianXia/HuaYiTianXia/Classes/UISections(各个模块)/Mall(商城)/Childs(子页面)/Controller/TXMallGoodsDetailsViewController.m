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
#import "TXShareViewController.h"
#import "TXSubmitOrderViewController.h"

static NSString * const reuseIdentifierBanner = @"TXMallGoodsBannerTableViewCell";
static NSString * const reuseIdentifierDetails = @"TXMallGoodsDetailsTableViewCell";
static NSString * const reuseIdentifierSpec = @"TXMallGoodsSpecTableViewCell";
@interface TXMallGoodsDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) NewsRecordsModel *productModel;
/// 产品详情
@property (strong, nonatomic) MallProductArrayModel *productDataModel;

@end

@implementation TXMallGoodsDetailsViewController
- (id)initMallProductModel:(NewsRecordsModel *)productModel{
    if ( self = [super init] ){
        self.productModel = productModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [self initView];
    [self loadMallGoodsDetailsData];
}

- (void) loadMallGoodsDetailsData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.productModel.status) forKey:@"status"];
    [parameter setObject:@(self.productModel.kid) forKey:@"id"];  // 每页条数
    
    [SCHttpTools postWithURLString:@"shopproduct/GetShopDetails" parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.productDataModel = [MallProductArrayModel mj_objectWithKeyValues:result];
            [self.tableView reloadData];
        }else{
            Toast(@"获取城市数据失败");
        }
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
    }];
}

/// 立即投保
- (void) saveBtnClick:(UIButton *)sender{
    TXSubmitOrderViewController *vc = [[TXSubmitOrderViewController alloc] init];
    TTPushVC(vc);
}

/// 分享到第三方平台
- (void)didTapShareButton:(UIBarButtonItem *)barButtonItem {
    TXShareViewController *vc = [[TXShareViewController alloc] init];
    //    [self presentPopupViewController:vc animationType:TTPopupViewAnimationSlideBottomBottom];
    CGFloat height = IPHONE6_W(150)+kTabBarHeight;
    [self sc_bottomPresentController:vc presentedHeight:height completeHandle:^(BOOL presented) {
        if (presented) {
            TTLog(@"弹出了");
        }else{
            TTLog(@"消失了");
        }
    }];
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
        make.left.top.right.equalTo(self.footerView);
        make.height.equalTo(@(IPHONE6_W(49)));
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

    if (indexPath.section==0) {
        TXMallGoodsBannerTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        tools.bannerArray = self.productDataModel.banners;
        return tools;

    }else if(indexPath.section==1){
        TXMallGoodsDetailsTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDetails forIndexPath:indexPath];
        tools.titleLabel.text = @"星际纵横矿机（4T/72T) A0055";
        tools.subtitleLabel.text = @"全球首款IPFS矿机收发功效低、性能高";
        tools.priceLabel.text = @"起投价格：10000";
        return tools;
    }else if(indexPath.section==2 || indexPath.section==3){
        TXMallGoodsSpecTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSpec forIndexPath:indexPath];
        tools.titleLabel.text = (indexPath.section==2)?@"商品规格：":@"购买数量：";
        tools.subtitleLabel.text = (indexPath.section==2)?@"4T矿机":@"1";
        if (indexPath.section==3) {
            tools.subtitleLabel.backgroundColor = kColorWithRGB(248, 248, 248);
            tools.subtitleLabel.borderWidth = 0.0;
            [tools.subtitleLabel lz_setCornerRadius:0.0];
        }
        return tools;
    }else{
        return [UITableViewCell new];
    }
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) return IPHONE6_W(212);
    if (indexPath.section==1) return IPHONE6_W(90);
    if (indexPath.section==2||indexPath.section==3) return IPHONE6_W(60);
    return kScreenHeight-kTabBarHeight-kNavBarHeight;
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
        
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kWhiteColor;
    }
    return _tableView;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kFontSizeMedium15;
        [_saveButton setTitle:@"立即投保" forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:kGetImage(@"c31_btn_tb") forState:UIControlStateNormal];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
