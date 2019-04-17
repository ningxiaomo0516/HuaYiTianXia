//
//  TXChoosePayViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/10.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXChoosePayViewController.h"
#import "TXChoosePayTableViewCell.h"
#import "AlipayManager.h"

static NSString * const reuseIdentifier = @"TXChoosePayTableViewCell";

@interface TXChoosePayViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 分割线
@property (nonatomic, strong) UIView *linerView;
/// 产品Model
@property (strong, nonatomic)  NewsRecordsModel *recordsModel;
@end

@implementation TXChoosePayViewController
- (id) initNewsRecordsModel:(NewsRecordsModel *)recordsModel{
    if ( self = [super init] ){
        self.recordsModel = recordsModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    
    // 注册通知
    [kNotificationCenter addObserver:self selector:@selector(AlipayStatusBlock:) name:@"AlipayStatus" object:nil];
}

- (void)AlipayStatusBlock:(NSNotification *)notification{
    NSDictionary *resultDic = [notification object];
    // 这样就得到了我们在发送通知时候传入的字典了
    TTLog(@"result = %@",[Utils lz_dataWithJSONObject:resultDic]);
    TTLog(@"%@",[resultDic lz_objectForKey:@"memo"]);
    // 解析 auth code
    NSInteger resultCode = [resultDic[@"resultStatus"] integerValue];
    if (resultCode == 9000) {
        Toast(@"订单支付成功!");
        [kNotificationCenter postNotificationName:@"AlipaySuccessful" object:nil];
    }else if (resultCode == 4000){
        Toast(@"订单支付失败!");
    }else if (resultCode == 5000){
        Toast(@"重复请求!");
    }else if (resultCode == 6001){
        Toast(@"取消支付!");
    }else if (resultCode == 6002){
        Toast(@"网络连接出错!");
    }else if (resultCode == 6004){
        Toast(@"未知支付结果");
    }else{
        Toast(@"未知操作");
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kWhiteColor;
}

- (void) initView{
    [self addGesture:self.tableView];
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.linerView];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.tableView];
    
    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(0.5));
        make.top.equalTo(@(60));
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.width.equalTo(@(60));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.linerView.mas_top);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kiPhoneX_T(0));
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXGeneralModel *model = self.dataArray[indexPath.row];
    TXChoosePayTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.titleLabel.text = model.title;
    tools.imagesView.image = kGetImage(model.imageText);
    
    return tools;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/// 返回多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return IPHONE6_W(55);
}

//// 生成订单且支付
- (void) GenerateOrderData:(NSInteger) idx{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    
    //    title    是    String    标题（当purchaseType=0时可传入固定值“会员充值”，purchaseType=6时可传入固定值“天合成员充值”，另外的情况请传入商品标题）
    //    purchaseType    是    int    支付类型 0：充值； 1：无人机商城产品；2：农用植保产品； 3：VR产品 4：纵横矿机产品 5：共享飞行产品; 6：天合成员充值；7：生态农业商城产品（消费）
    //    priceMoney    是    double    单价金额
    //    number    是    double    产品数量(默认传1)
    //    proID    否    int    产品ID（当purchaseType=0（充值）或=6（天合成员充值）时不传）
    //    addressID    否    int    用户选择的收货地址表ID（当purchaseType=1或7必传）
    //    spec    否    String    用户选择规格
    //    color    否    String    用户选择颜色
    //    remarks    否    String    用户购买备注
    //    payType    是    int    0:支付宝 1:微信 2：余额支付
    //    currency    是    Double    vr币数量
    kMBShowHUD(@"");
    [parameter setObject:self.recordsModel.title forKey:@"title"];
    [parameter setObject:@(self.recordsModel.purchaseType) forKey:@"purchaseType"];
    [parameter setObject:@([self.recordsModel.price doubleValue]) forKey:@"priceMoney"];
    [parameter setObject:@(1) forKey:@"number"];
    [parameter setObject:@([self.recordsModel.kid integerValue]) forKey:@"proID"];
    [parameter setObject:@"" forKey:@"addressID"];
    [parameter setObject:@"" forKey:@"spec"];
    [parameter setObject:@"" forKey:@"color"];
    [parameter setObject:@"" forKey:@"remarks"];
    [parameter setObject:@(idx) forKey:@"payType"];/// 支付方式  0:支付宝 1:微信 2：余额支付
    [parameter setObject:@"" forKey:@"currency"];
    [self sc_dismissVC];
    [SCHttpTools postWithURLString:kHttpURL(@"orderform/PayFrom") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                if (idx==0) {/// 支付宝支付
                    [AlipayManager doAlipayPay:model];
                }else if(idx==1){/// 微信支付
                    NSString *str = [Utils lz_dataWithJSONObject:result];
                    TTLog(@"str == %@",str);
                    [AlipayManager doWechatPay:model];
                }else{
                    Toast(@"未知支付");
                }
            }else{
                Toast(model.message);
            }
        }
        kMBHideHUD;
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
        kMBHideHUD;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self GenerateOrderData:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark ----- getter/setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXChoosePayTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:kGetImage(@"c12_btn_close") forState:UIControlStateNormal];
        MV(weakSelf);
        [_closeButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _closeButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"选择支付方式" color:kTextColor51 font:kFontSizeMedium17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)linerView{
    if (!_linerView) {
        _linerView = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@"支付宝",@"微信支付"];
        NSArray* classArr = @[@"c31_btn_zfb",@"c31_btn_wxzf"];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:j];
            generalModel.imageText = [classArr lz_safeObjectAtIndex:j];
            [_dataArray addObject:generalModel];
        }
    }
    return _dataArray;
}

- (void)dealloc{
    [kNotificationCenter removeObserver:self];
}
@end
