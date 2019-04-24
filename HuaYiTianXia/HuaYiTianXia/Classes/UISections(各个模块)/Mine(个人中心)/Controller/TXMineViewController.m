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
#import "TXBecomeVipViewController.h"
#import "TXPushMessageViewController.h"
#import "TXSetupViewController.h"

static NSString * const reuseIdentifier = @"TXMineTableViewCell";
static NSString * const reuseIdentifierHeader = @"TXMineHeaderTableViewCell";
static NSString * const reuseIdentifierBanner = @"TXMineBannerTableViewCell";

@interface TXMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) TXMineHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemModelArray;
@property (nonatomic, strong) TTUserModel *userModel;
@property (nonatomic, strong) NSMutableArray *bannerArray;
/// 导航View
@property (nonatomic, strong) UIView *navBoxView;
/// 设置按钮
@property (nonatomic, strong) UIButton *setupButton;
/// 消息按钮
@property (nonatomic, strong) UIButton *messageButton;
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
    MV(weakSelf)
    [self.headerView.upgradeButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf jumpBecomeVipVC:[[TXBecomeVipViewController alloc] init]];
    }];
    
    [self.messageButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf jumpBecomeVipVC:[[TXPushMessageViewController alloc] init]];
    }];
    [self.setupButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf jumpBecomeVipVC:[[TXSetupViewController alloc] init]];
    }];
}

- (void) jumpBecomeVipVC:(UIViewController *)vc{
    TTPushVC(vc);
}

/// 登录成功之后再获取数据
- (void) reloadData{
    [self requestPersonalCenterData];
}

- (void) reloadUserName{
    self.headerView.nicknameLabel.text = kUserInfo.username;
    [self.headerView.imagesViewAvatar sc_setImageWithUrlString:kUserInfo.avatar
                                              placeholderImage:kGetImage(@"mine_icon_avatar")
                                                      isAvatar:false];
}

- (void) requestPersonalCenterData{
    [SCHttpTools getWithURLString:kHttpURL(@"customer/Wallet") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTUserDataModel *model = [TTUserDataModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                TTLog(@"result ---- %@",[Utils lz_dataWithJSONObject:[result lz_objectForKey:@"obj"]]);
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
                NSAttributedString *attributedText;
                if ([model.data.userTypeName isEqualToString:@"天合会员"]) {
                   attributedText = [SCSmallTools sc_initImageWithText:model.data.userTypeName imageName:@"c7_普通用户" fontWithSize:kFontSizeMedium13];
                }else{
                    attributedText = [SCSmallTools sc_initImageWithText:model.data.userTypeName imageName:@"c7_黄金会员" fontWithSize:kFontSizeMedium13];
                }
                
                self.headerView.levelLabel.attributedText = attributedText;
                self.headerView.nicknameLabel.text = model.data.username;
                self.headerView.titleLabel.text = model.data.companyname.length>0?model.data.companyname:@"分公司筹建中";
                self.headerView.numberLabel.text = [NSString stringWithFormat:@"人数：%@/30",model.data.joined.length>0?model.data.joined:@"0"];
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
        tools.userModel = self.userModel;
        return tools;

    }else if (indexPath.section == 1){
        TXMineBannerTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        tools.bannerArray = self.bannerArray;
        return tools;
    }else{
        TXMineTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        TXGeneralModel* model = self.itemModelArray[0][indexPath.row];
        model.index = indexPath.item;
        tools.titleLabel.text = model.title;
        tools.linerView.hidden = NO;
        if (indexPath.row==0){
            tools.subtitleLabel.textColor = HexString(@"#FF9B9B");
            if (kUserInfo.isValidation==2) {
                tools.subtitleLabel.textColor = kTextColor153;
                tools.subtitleLabel.text = @"已认证";
                tools.imagesArrow.hidden = YES;
            }else if (kUserInfo.isValidation==1) {
                tools.subtitleLabel.text = @"认证中";
            }else if (kUserInfo.isValidation==3) {
                tools.subtitleLabel.text = @"认证失败";
            }else{
                tools.subtitleLabel.text = @"未实名认证";
            }
            tools.subtitleLabel.hidden = NO;
        }else{
            tools.imagesArrow.hidden = NO;
            tools.subtitleLabel.hidden = YES;
        }
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
    if (indexPath.section==0) return IPHONE6_W(126);
    if (indexPath.section==1) return IPHONE6_W(180);
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
//        _tableView.bounces = NO;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,IPHONE6_W(15),0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kWhiteColor;
    }
    return _tableView;
}

#pragma mark ---- 界面布局设置
- (void)initView{
    
    [self.view addSubview:self.tableView];
    [Utils lz_setExtraCellLineHidden:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
    }];
    
    
    [self.view addSubview:self.navBoxView];
    [self.navBoxView addSubview:self.setupButton];
    [self.navBoxView addSubview:self.messageButton];
    
    [self.navBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(44));
        make.top.equalTo(@(kNavBarHeight-44));
    }];
    
    [self.setupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self.navBoxView);
    }];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self.navBoxView);
    }];
}

- (TXMineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TXMineHeaderView alloc] init];
        CGFloat height = IPHONE6_W(325)+kSafeAreaBottomHeight;
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, height);
    }
    return _headerView;
}

- (UIView *)navBoxView{
    if (!_navBoxView) {
        _navBoxView = [UIView lz_viewWithColor:kClearColor];
    }
    return _navBoxView;
}

- (UIButton *)setupButton{
    if (!_setupButton) {
        _setupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setupButton setImage:kGetImage(@"c7_设置") forState:UIControlStateNormal];
    }
    return _setupButton;
}

- (UIButton *)messageButton{
    if (!_messageButton) {
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageButton setImage:kGetImage(@"c7_消息") forState:UIControlStateNormal];
    }
    return _messageButton;
}


- (NSMutableArray *)itemModelArray{
    if (!_itemModelArray) {
        _itemModelArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@[@"实名认证",@"订单中心",@"我的钱包",
                                @"推荐邀请",@"我的团队",@"设置"]];//TXOrderViewController
        NSArray* classArr = @[@[@"TXRealNameViewController",@"TXProductViewController",
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
