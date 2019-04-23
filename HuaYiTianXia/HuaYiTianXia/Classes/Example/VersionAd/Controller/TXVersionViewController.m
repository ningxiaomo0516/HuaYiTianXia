//
//  TXVersionViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXVersionViewController.h"
#import "TXVersionTableViewCell.h"
#import "LZRootViewController.h"
#import "TXAdsViewController.h"

@interface TXVersionViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>
{
@private
    UITableView *_tableView;
}
@property(nonatomic,strong,readonly)UITableView * tableView;
@property(nonatomic,strong)UIButton *stopButton;
@property(nonatomic,strong)UIButton *updateButton;
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,assign)BOOL isData;//是否请求到数据

@end

@implementation TXVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //背景imageView
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *boxView = [UIView lz_viewWithColor:kColorWithRGB(254, 252, 252)];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:kGetImage(@"c18_启动页_无广告")];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:boxView];
    [boxView addSubview:imageView];
    [boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(IPHONE6_W(90)+kSafeAreaBottomHeight));
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(boxView);
        make.height.equalTo(@(IPHONE6_W(90)));
    }];
    [self performSelector:@selector(skipClick) withObject:nil afterDelay:3];
    [self loadVersionAndADsRequest];
}

- (void)skipClick{
    if (self.isData) {
        return;
    }
    [self updateVersionAndAdsInfo];
}

//下载版本控制信息和引导广告
- (void)loadVersionAndADsRequest{
    NSMutableArray * pramas = [NSMutableArray array];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@(1) forKey:@"status"];
    SCHttpToolsModel* versionModel = [[SCHttpToolsModel alloc]  initIsGetOrPost:false Url:versionManage param:dic];
    [pramas addObject:versionModel];
    
    SCHttpToolsModel* adsModel = [[SCHttpToolsModel alloc]  initIsGetOrPost:true Url:startPage param:nil];
    [pramas addObject:adsModel];
    
    __weak typeof(self) weakSelf = self;
    [SCHttpTools getMoreDataWithParams:pramas success:^(id result) {
        if (result) {
            if (result[@"0"]) {
//                NSArray *versionArray = [NSArray yy_modelArrayWithClass:[TXVersionModel class] json:result[@"0"]];
//                for (TXVersionModel * model in versionArray) {
//                    if (model.type == 2) {
//                        weakSelf.versionModel = model;
//                    }
//                }
                TTVersionData *versionModel = [TTVersionData mj_objectWithKeyValues:result[@"0"]];
                weakSelf.versionModel = versionModel.data;
            }
            if (result[@"1"]) {
//                weakSelf.adsArray = [NSArray yy_modelArrayWithClass:[TXAdsModel class] json:result[@"1"]];
//                TTAdsData *adsModel = [TTAdsData mj_objectWithKeyValues:result[@"1"]];
                NSDictionary * dic = [result lz_objectForKey:@"1"];
                TTLog(@" --- dic %@",dic);
                TTAdsData *model = [TTAdsData mj_objectWithKeyValues:dic];

                if (model.errorcode == 20000) {
                    [weakSelf.adsArray addObject:model.data];
                }
            }
        }
        weakSelf.isData = YES;
        [weakSelf updateVersionAndAdsInfo];
    } failure:^(NSArray *errors) {
        weakSelf.isData = YES;
        [weakSelf updateVersionAndAdsInfo];
    }];
}

- (void)updateAdsInfo{
    //    __weak typeof(self) weakSelf = self;
    if(self.adsArray.count > 0){
        TXAdsViewController * vc = [[TXAdsViewController alloc] init];
        vc.adsArray  = [NSMutableArray arrayWithArray:self.adsArray];;
        [self presentViewController:vc animated:NO completion:nil];
        //        [self presentViewController:vc animated:NO completion:^{
        //            [[UIApplication sharedApplication] keyWindow].rootViewController = vc;
        //            [weakSelf removeFromParentViewController];
        //        }];
    }else{
        LZRootViewController *rootVC  = [[LZRootViewController alloc] init];
        //        [self presentViewController:rootVC animated:NO completion:^{
        kAppDelegate.window.rootViewController = rootVC;
        //            [weakSelf removeFromParentViewController];
        //        }];
        
    }
}

- (void)updateVersionAndAdsInfo{
    if (self.versionModel.codeVerison > 1) { //跳版本页面
        [self updateAllData];
        return;
    }
    [self updateAdsInfo];
    
}

- (void)updateAllData{
    float height = [self sx_getTableViewHeight];
    [self setUpUI:height];
}

- (void)dealloc{
    
}

//数据请求到后设置UI
- (void)setUpUI:(float)tableHeight{
    UIView * coverView = [UIView lz_viewWithColor:[UIColor lz_colorWithHex:0x060606]];
    coverView.alpha = 0.5;
    [self.view addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(-20);
        make.width.equalTo(@235);
        make.height.equalTo(@(107 + 20 + tableHeight + 44 + 15)); // 15 距离上边距5 下边距10
    }];
    
    UIImageView * topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_img_pop2"]];
    [backView addSubview:topView];
    UIView * bottomView = [UIView lz_viewWithColor:[UIColor whiteColor]];
    bottomView.layer.cornerRadius = 10;
    [backView addSubview:bottomView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView);
        make.centerX.mas_offset(0);
        make.width.equalTo(@235);
        make.height.equalTo(@(107));
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(-0.5);
        make.centerX.mas_offset(0);
        make.width.equalTo(@235);
        make.bottom.equalTo(backView);
    }];
    
    UILabel *titleLabel = [UILabel lz_labelWithTitle:@"软件更新" color:[UIColor lz_colorWithHex:0x000000] font:kFontSizeMedium15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.width.equalTo(@(100));
        make.top.mas_equalTo(0);
        make.height.equalTo(@(20));
    }];
    [bottomView addSubview:self.tableView];
    [bottomView addSubview:self.stopButton];
    [bottomView addSubview:self.updateButton];
    
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView);
        make.height.equalTo(@44);
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView.mas_centerX);
    }];
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stopButton);
        make.bottom.equalTo(self.stopButton);
        make.right.equalTo(bottomView);
        make.left.equalTo(bottomView.mas_centerX);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.height.equalTo(@(tableHeight));
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView);
    }];
    
    //两个图片，遮住上下圆角
    UIView *corView1 = [UIView lz_viewWithColor:[UIColor whiteColor]];
    UIView *corView2 = [UIView lz_viewWithColor:[UIColor whiteColor]];
    [backView addSubview:corView1];
    [backView addSubview:corView2];
    [corView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.top.equalTo(topView.mas_bottom).offset(-10);
        make.bottom.equalTo(bottomView.mas_top).offset(10);
        make.width.equalTo(@10);
    }];
    [corView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.top.equalTo(topView.mas_bottom).offset(-10);
        make.bottom.equalTo(bottomView.mas_top).offset(10);
        make.width.equalTo(@10);
    }];
    
    //分割线
    UIView *lineView1 = [UIView lz_viewWithColor:[UIColor lz_colorWithHex:0xdddddd]];
    UIView *lineView2 = [UIView lz_viewWithColor:[UIColor lz_colorWithHex:0xdddddd]];
    [backView addSubview:lineView1];
    [backView addSubview:lineView2];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.right.equalTo(backView);
        make.height.equalTo(@1);
        make.bottom.equalTo(backView).offset(-44);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1);
        make.bottom.equalTo(backView);
        make.centerX.equalTo(backView);
        make.width.equalTo(@1);
    }];
}

//获取到高度并且处理model
- (CGFloat)sx_getTableViewHeight{
    NSArray * titleArray = [self.versionModel.updateInfo componentsSeparatedByString:@"\n"];
    float height = 0.0;
    for (int i = 0; i<titleArray.count; i++) {
        TXVersionCellModel * model = [[TXVersionCellModel alloc] init];
        NSString * string = [NSString stringWithFormat:@"%@",[titleArray lz_safeObjectAtIndex:i]];
        string = [string stringByReplacingOccurrencesOfString:@"；" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
        model.updateText = string;
        model.cellheight = [self updateCellHeight:model.updateText];
        height =  height + model.cellheight;
        [self.listArray addObject:model];
    }
    if (height > (kScreenHeight - 107 - 20 -44 - 15 - 80 - 120)) {
        height = kScreenHeight - 107 - 20 -44 - 15 - 80 - 120;
    }
    if (height > 260) {
        height = 260;
    }
    return MAX(height, 20);
}
//更新单元格model
- (float)updateCellHeight:(NSString *)string{
    CGSize maxSize = CGSizeMake(235-44, MAXFLOAT);
    CGSize size =  [string boundingRectWithSize:maxSize
                                        options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}
                                        context:nil].size;
    
    return MAX(ceil(size.height) + 5, 20);
}

//更新
- (void)updateBtnClicked{
    NSString *AppURL = @"https://itunes.apple.com/cn/app/%E7%86%8A%E7%8C%AB%E8%A7%86%E9%A2%91-%E5%9B%9B%E5%B7%9D%E6%9C%80%E5%A4%A9%E5%BA%9C%E6%8E%8C%E4%B8%8A%E8%A7%86%E9%A2%91%E6%92%AD%E6%94%BE%E5%B9%B3%E5%8F%B0/id1460229512?l=zh&ls=1&mt=8";
    [[UIApplication sharedApplication] openURL:kGetImageURL(AppURL)];
}
//取消
- (void)stopBtnClicked{
    if (self.versionModel.updateType) {
        exit(0);
        return;
    }
    [self updateAdsInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MAX(self.listArray.count, 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TXVersionCellModel * model = [self.listArray lz_safeObjectAtIndex:indexPath.row];
    return MAX(model.cellheight, 20);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TXVersionTableView";
    TXVersionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TXVersionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TXVersionCellModel * model = [self.listArray lz_safeObjectAtIndex:indexPath.row];
    cell.textLabel.text = model.updateText;
    return  cell;
    
}


#pragma setter,getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kClearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        DisableAutoAdjustScrollViewInsets(_tableView, self);
    }
    return _tableView;
}

- (UIButton *)stopButton{
    if (!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton setTitleColor:[UIColor lz_colorWithHex:0x808080] forState:UIControlStateNormal];
        [_stopButton setTitle:self.versionModel.updateType?@"退出":@"暂不" forState:UIControlStateNormal];
        _stopButton.titleLabel.font = kFontSizeMedium15;
        [_stopButton addTarget:self action:@selector(stopBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}

- (UIButton *)updateButton{
    if (!_updateButton) {
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updateButton setTitleColor:[UIColor lz_colorWithHex:0x00c5ed] forState:UIControlStateNormal];
        [_updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
        _updateButton.titleLabel.font = kFontSizeMedium15;
        [_updateButton addTarget:self action:@selector(updateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateButton;
}

- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableArray *)adsArray{
    if (!_adsArray) {
        _adsArray = [NSMutableArray array];
    }
    return _adsArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
