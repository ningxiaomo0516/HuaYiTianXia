//
//  TXMineViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMineViewController.h"
#import "TXMineHeaderView.h"
#import "TXMineHeaderTableViewCell.h"
#import "TXMineTableViewCell.h"
#import "TXMineBannerTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXRealNameViewController.h"
#import "TXWebViewController.h"

static NSString * const reuseIdentifier = @"TXMineTableViewCell";
static NSString * const reuseIdentifierHeader = @"TXMineHeaderTableViewCell";
static NSString * const reuseIdentifierBanner = @"TXMineBannerTableViewCell";

@interface TXMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) TXMineHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemModelArray;
@property (nonatomic, strong) TTUserModel *userModel;
@property (nonatomic, strong) NSMutableArray *bannerArray;

@end

@implementation TXMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    if (kUserInfo.isLogin) {
        [self requestPersonalCenterData];
    }
    // 注册通知
    [kNotificationCenter addObserver:self selector:@selector(reloadUserName) name:@"reloadUserName" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(reloadData) name:@"reloadMineData" object:nil];
}

/// 登录成功之后再获取数据
- (void) reloadData{
    [self requestPersonalCenterData];
}

- (void) reloadUserName{
    self.headerView.nickNameLabel.text = kUserInfo.username;
    [self.headerView.imagesViewAvatar sc_setImageWithUrlString:kUserInfo.avatar
                                              placeholderImage:kGetImage(@"mine_icon_avatar")
                                                      isAvatar:false];
}

- (void) requestPersonalCenterData{
    [SCHttpTools getWithURLString:kHttpURL(@"customer/Wallet") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TTLog(@"result ---- %@",[Utils lz_dataWithJSONObject:result]);
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTUserDataModel *model = [TTUserDataModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                self.userModel = model.data;
                kUserInfo.totalAssets = model.data.totalAssets;
                kUserInfo.arcurrency = model.data.arcurrency;
                kUserInfo.vrcurrency = model.data.vrcurrency;
                kUserInfo.stockRight = model.data.stockRight;
                kUserInfo.username = model.data.username;
                kUserInfo.balance = model.data.balance;
                kUserInfo.avatar = model.data.avatar;
                kUserInfo.isValidation = model.data.isValidation;
                [kUserInfo dump];
                [self.headerView.imagesViewAvatar sc_setImageWithUrlString:model.data.avatar
                                                          placeholderImage:kGetImage(@"mine_icon_avatar")
                                                                  isAvatar:false];
                self.headerView.nickNameLabel.text = model.data.username;
                self.headerView.kidLabel.text = [NSString stringWithFormat:@"ID:%@",model.data.uid];
                [self.bannerArray addObjectsFromArray:model.data.banners];
                [self.tableView reloadData];
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"个人中心数据获取失败");
        }
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        TXMineHeaderTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
        tools.totalAssetsLabel.text = self.userModel.totalAssets;
        tools.vrAssetsLabel.text = self.userModel.vrcurrency;
        tools.arAssetsLabel.text = self.userModel.arcurrency;
        tools.eqAssetsLabel.text = self.userModel.stockRight;
        return tools;

    }else if (indexPath.section == 1){
        TXMineBannerTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        tools.bannerArray = self.bannerArray;
        return tools;
    }else{
        TXMineTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        if (indexPath.row==0) {
            tools.titleLabel.textColor = kTextColor102;
            tools.titleLabel.font = kFontSizeMedium13;
            tools.imagesArrow.hidden = YES;
            tools.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if(indexPath.row==1){
            tools.subtitleLabel.textColor = HexString(@"#FF9B9B");
            if (kUserInfo.isValidation==2) {
                tools.subtitleLabel.textColor = kTextColor153;
                tools.subtitleLabel.text = @"已认证";
                tools.imagesArrow.hidden = YES;
            }else if (kUserInfo.isValidation==1) {
                tools.subtitleLabel.text = @"认证中";
            }else{
                tools.subtitleLabel.text = @"未实名认证";
            }
            tools.subtitleLabel.hidden = NO;
        }
        TXGeneralModel* model = self.itemModelArray[0][indexPath.row];
        model.index = indexPath.item;
        tools.titleLabel.text = model.title;

        return tools;
    }
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section!=2) return 1;
    NSArray *subArray = [self.itemModelArray lz_safeObjectAtIndex:0];
    return subArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) return IPHONE6_W(146);
    if (indexPath.section==1) return IPHONE6_W(180);
    else {
        if (indexPath.row==0) return IPHONE6_W(40);
    }
    return IPHONE6_W(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TXGeneralModel* model = self.itemModelArray[0][indexPath.row];
    NSString *className = model.showClass;
    if ([model.showClass isEqualToString:@"TXRealNameViewController"]) {
        if (kUserInfo.isValidation==0) {
            TXRealNameViewController *vc = [[TXRealNameViewController alloc] init];
            vc.title = model.title;
            vc.typePage = 0;
            TTPushVC(vc);
        }
    }else if([model.showClass isEqualToString:@"TXWebViewController"]){
        TXWebViewController *vc = [[TXWebViewController alloc] init];
        vc.title = model.title;
        vc.webUrl = kAppendH5URL(DomainName, InvataionH5,@"");
        TTPushVC(vc);
    }else{
        Class controller = NSClassFromString(className);
        //    id controller = [[NSClassFromString(className) alloc] init];
        if (controller &&  [controller isSubclassOfClass:[UIViewController class]]){
            UIViewController *vc = [[controller alloc] init];
            vc.title = model.title;
            TTPushVC(vc);
        }
    }    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXMineHeaderTableViewCell class] forCellReuseIdentifier:reuseIdentifierHeader];
        [_tableView registerClass:[TXMineTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXMineBannerTableViewCell class] forCellReuseIdentifier:reuseIdentifierBanner];

        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,IPHONE6_W(15),0,0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kWhiteColor;
    }
    return _tableView;
}

#pragma mark ---- 界面布局设置
- (void)initView{
    [self.view addSubview:self.headerView];
    [Utils lz_setExtraCellLineHidden:self.tableView];

    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(kNavBarHeight));
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).offset(-1);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
    }];
}

- (TXMineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TXMineHeaderView alloc] init];
    }
    return _headerView;
}

- (NSMutableArray *)itemModelArray{
    if (!_itemModelArray) {
        _itemModelArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@[@"资产管理",@"实名认证",@"订单中心",@"我的钱包",
                                @"推荐邀请",@"我的团队",@"设置"]];//TXOrderViewController
        NSArray* classArr = @[@[@"",@"TXRealNameViewController",@"TXProductViewController",
                                @"TXWalletViewController",@"TXWebViewController",
                                @"TXTeamViewController",@"TXSetupViewController"]];
        for (int i=0; i<titleArr.count; i++) {
            NSArray *subTitlesArray = [titleArr lz_safeObjectAtIndex:i];
            NSArray *classArray = [classArr lz_safeObjectAtIndex:i];
            NSMutableArray *subArray = [NSMutableArray array];
            for (int j = 0; j < subTitlesArray.count; j ++) {
                TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
                generalModel.title = [subTitlesArray lz_safeObjectAtIndex:j];
                generalModel.showClass = [classArray lz_safeObjectAtIndex:j];
                [subArray addObject:generalModel];
            }
            [_itemModelArray addObject:subArray];
        }
    }
    return _itemModelArray;
}

- (NSMutableArray *)bannerArray{
    if (!_bannerArray) {
        _bannerArray = [[NSMutableArray alloc] init];
    }
    return _bannerArray;
}

- (void)dealloc{
    [kNotificationCenter removeObserver:self];
}

@end
