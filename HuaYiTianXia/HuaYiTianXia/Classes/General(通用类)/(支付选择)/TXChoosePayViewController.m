//
//  TXChoosePayViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/10.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXChoosePayViewController.h"
#import "TXChoosePayTableViewCell.h"

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
@end

@implementation TXChoosePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
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
    tools.chooseBtn.hidden = YES;
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

- (void) submitOrderData{
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
    
    [parameter setObject:@"农用植保产品" forKey:@"title"];
    [parameter setObject:@(2) forKey:@"purchaseType"];
    [parameter setObject:@(100) forKey:@"priceMoney"];
    [parameter setObject:@"1" forKey:@"number"];
    [parameter setObject:@(59) forKey:@"proID"];
    [parameter setObject:@"" forKey:@"addressID"];
    [parameter setObject:@"" forKey:@"spec"];
    [parameter setObject:@"" forKey:@"color"];
    [parameter setObject:@"" forKey:@"remarks"];
    [parameter setObject:@(1) forKey:@"payType"];
    [parameter setObject:@"" forKey:@"currency"];
    [SCHttpTools postWithURLString:kHttpURL(@"orderform/PayFrom") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSString *str = [Utils lz_dataWithJSONObject:result];
            TTLog(@"str == %@",str);
            TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
//                [self sc_dismissVC];
                NSDictionary *dict = [Utils dictionaryWithJsonString:model.obj];
                OrderData *o = [OrderData mj_objectWithKeyValues:dict];
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
//                req.openID = o.appid;
                /** 商家向财付通申请的商家id */
                req.partnerId           = [dict lz_objectForKey:@"partnerid"];
                /** 预支付订单 */
                req.prepayId            = [dict lz_objectForKey:@"prepayid"];
                /** 随机串，防重发 */
                req.nonceStr            = [dict lz_objectForKey:@"noncestr"];
                /** 时间戳，防重发 */
                req.timeStamp           = [[dict lz_objectForKey:@"timestamp"] intValue];
                /** 商家根据财付通文档填写的数据和签名(//这个比较特殊，是固定的，只能是即req.package = Sign=WXPay)*/
                req.package             = @"Sign=WXPay";
                /** 商家根据微信开放平台文档对数据做的签名 */
                req.sign                = [dict lz_objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                TTLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",o.appid,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            }else{
                Toast(model.message);
            }
        }
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self submitOrderData];
    
//    return @"";
//    TXGeneralModel *model = self.dataArray[indexPath.row];
//    if (self.typeBlock) {
//        self.typeBlock(model.title,indexPath.row);
//    }
//    [self dismissViewControllerAnimated:YES completion:nil];
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
        NSArray* titleArr = @[@"微信支付",@"支付宝"];
        NSArray* classArr = @[@"c31_btn_wxzf",@"c31_btn_zfb"];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:j];
            generalModel.imageText = [classArr lz_safeObjectAtIndex:j];
            [_dataArray addObject:generalModel];
        }
    }
    return _dataArray;
}


@end
