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
    
    [self requestPersonalCenterData];
}

- (void) requestPersonalCenterData{
    [SCHttpTools getWithURLString:HttpURL(@"customer/Wallet") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTUserDataModel *model = [TTUserDataModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                self.userModel = model.data;
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
            tools.subtitleLabel.hidden = NO;
            tools.subtitleLabel.text = @"未实名认证";
            tools.subtitleLabel.textColor = HexString(@"#FF9B9B");
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
    if ([model.showClass isEqualToString:@""]) {
        
    }else{
        Class controller = NSClassFromString(className);
        
        //    id controller = [[NSClassFromString(className) alloc] init];
        if (controller &&  [controller isSubclassOfClass:[UIViewController class]]){
            UIViewController *view = [[controller alloc] init];
            view.title = model.title;
            [view setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:view animated:YES];
        }
    }    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
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
                                @"TXWalletViewController",@"TXRecommendedViewController",
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


@end
