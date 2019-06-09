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
#import "TXMineBannerTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXRealNameViewController.h"
#import "TXWebViewController.h"
#import "TXBecomeVipViewController.h"
#import "TXPushViewController.h"
#import "TXSetupViewController.h"
#import "TXInvitationViewController.h"
#import "TXLoginViewController.h"

static NSString * const reuseIdentifier = @"TXMineViewCell";
static NSString * const reuseIdentifierHeader = @"TXMineHeaderTableViewCell";
static NSString * const reuseIdentifierBanner = @"TXMineBannerTableViewCell";

@interface TXMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) TXMineHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
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
        [weakSelf jumpBecomeVipVC:[[TXPushViewController alloc] init]];
    }];
    [self.setupButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf jumpBecomeVipVC:[[TXSetupViewController alloc] init]];
    }];
    [kNotificationCenter addObserver:self selector:@selector(receiveNotification:) name:@"dealwithTeamPushMessage" object:nil];
    
//    self.navigationController.tabBarItem.badgeValue = @"20";
}

- (void)receiveNotification:(NSNotification *)infoNotification {
//    NSDictionary *resultDic = [infoNotification userInfo];
//    NSString *kid = [resultDic lz_objectForKey:@"info"];
//    NSString *messageType = [resultDic lz_objectForKey:@"messageType"];
    TXInvitationViewController *vc = [[TXInvitationViewController alloc] init];
    vc.title = @"我的邀请";
    [self jumpBecomeVipVC:vc];
    
    UITabBarController *tab=self.tabBarController;
    if (tab){
        TTLog(@"I have a tab bar");
        [self.tabBarController setSelectedIndex:4];
    } else{
        TTLog(@"I don't have");
    }
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
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section == 0) {
        TXMineHeaderTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
        tools.userModel = self.userModel;
        return tools;

    }/*else if (indexPath.section == 1){
      // 隐藏个人中心banner(2019-05-29)
        TXMineBannerTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
        tools.bannerArray = self.bannerArray;
        return tools;
    }*/else{
        TXMineViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        TXGeneralModel* model = self.dataArray[indexPath.section][indexPath.row];
        model.index = indexPath.item;
        tools.titleLabel.text = model.title;
        NSString *imagesName = [NSString stringWithFormat:@"c44_%@",model.title];
        tools.imagesView.image = kGetImage(imagesName);
        if (indexPath.row==0&&indexPath.section==1){
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
    return self.dataArray.count;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section<1) return 1;
    NSArray *subArray = [self.dataArray lz_safeObjectAtIndex:section];
    return subArray.count;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) return 0.001f;
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) return IPHONE6_W(126);
    /**if (indexPath.section==1) return IPHONE6_W(180);*/
    return IPHONE6_W(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0) return;
    TXGeneralModel* model = self.dataArray[indexPath.section][indexPath.row];
    NSString *className = model.showClass;
    if (indexPath.section>0) {
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
            vc.webUrl = kAppendH5URL(DomainName, InvataionH5,kUserInfo.userid);
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
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXMineHeaderTableViewCell class] forCellReuseIdentifier:reuseIdentifierHeader];
        [_tableView registerClass:[TXMineViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXMineBannerTableViewCell class] forCellReuseIdentifier:reuseIdentifierBanner];
//        _tableView.bounces = NO;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,IPHONE6_W(15),0,0)];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kClearColor;
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
        make.height.width.equalTo(self.navBoxView.mas_height);
    }];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self.navBoxView);
        make.height.width.equalTo(self.setupButton);
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


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@[],
                              @[@"实名认证",@"订单中心",@"我的钱包"],
                              @[@"我的团队",@"我的邀请",@"推荐邀请"],
                              @[@"设置"]];
        NSArray* classArr = @[@[],
                              @[@"TXRealNameViewController",@"TXProductViewController",@"TXWalletViewController"],
                              @[@"TXMineTeamViewController",@"TXInvitationViewController",@"TXWebViewController"],
                              @[@"TXSetupViewController"]];
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
            [_dataArray addObject:subArray];
        }
    }
    return _dataArray;
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


@implementation TXMineViewCell
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
        [self initView];
    }
    return self;
}

- (void) initView{
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.imagesArrow];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right).offset(IPHONE6_W(10));
        make.centerY.equalTo(self);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imagesArrow.mas_left);
        make.centerY.equalTo(self);
    }];
    
    [self.imagesArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor128 font:kFontSizeMedium15];
        _subtitleLabel.hidden = YES;
    }
    return _subtitleLabel;
}

- (UIImageView *)imagesArrow{
    if (!_imagesArrow) {
        _imagesArrow = [[UIImageView alloc] init];
        _imagesArrow.image = kGetImage(@"mine_btn_enter");
    }
    return _imagesArrow;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}
@end
