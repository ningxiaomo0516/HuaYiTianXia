//
//  TXYuYueShenQingViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXYuYueShenQingViewController.h"
//// 收货地址中的城市选择
#import "TTPickerView.h"
#import "TTPickerModel.h"
#import "LZDatePickerView.h"
#import "TTBottomShowView.h"
#import "AlipayManager.h"
#import "TXConventionSucceViewController.h"

@interface TXYuYueShenQingViewController ()<UITableViewDelegate,UITableViewDataSource,TTPickerViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *nicknameCell;   // 昵称Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *cityCell;       // 所在区域Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *telCell;        // 联系电话Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *addressCell;    // 详细地址Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;       // 日期Cell
@property (strong, nonatomic) UIView *footerView;              // 按钮View


@property (strong, nonatomic) IBOutlet UITextField  *nicknameTextField; // 昵称
@property (strong, nonatomic) IBOutlet UILabel      *cityLabel;         // 所在区域
@property (strong, nonatomic) IBOutlet UITextField  *telTextField;      // 联系电话
@property (strong, nonatomic) IBOutlet SCTextView   *textView;          // 详细地址
@property (strong, nonatomic) IBOutlet UILabel      *dateLabel;         // 日期
@property (strong, nonatomic) IBOutlet UIButton     *saveButton;        // 按钮
@property (strong, nonatomic) TTBottomShowView *showView;               // 底部支付选择


//// 日期选择
@property (nonatomic, strong) TTPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *pro;
@property (nonatomic, strong) TXRecommendedModel *recommendedModel;
@end

@implementation TXYuYueShenQingViewController
- (id)initWidthRecommendedModel:(TXRecommendedModel *)recommendedModel{
    if (self = [super init] ){
        self.recommendedModel = recommendedModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    self.title = @"预约申请";
    [self.footerView addSubview:self.saveButton];
    self.tableView.tableFooterView = self.footerView;
    MV(weakSelf)
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"addr" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions|NSJSONWritingPrettyPrinted error:nil] mutableCopy];

    [jsonArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.pro addObject:[TTPickerModel mj_objectWithKeyValues:obj]];
    }];
    
    self.showView = [[TTBottomShowView alloc] init];
    self.showView.defaultHeight = kScreenHeight-kScreenHeight/3;
    self.showView.amountText = self.recommendedModel.data.deposit;
    [self.view addSubview:[self.showView initMaskView]];
    //// 选择城市后的block
    self.showView.selectBlock = ^(NSInteger idx) {
        [weakSelf GenerateOrderData:idx];
    };
}

- (void) handleControlEvent:(UIButton *)sender{
    if (self.nicknameTextField.text.length == 0) {
        Toast(@"请填写姓名");
        return;
    }
    if (self.telTextField.text.length == 0) {
        Toast(@"请填联系电话");
        return;
    }
    if (self.dateLabel.text.length == 0) {
        Toast(@"请填选择预约时间");
        return;
    }
    if (self.cityLabel.text.length == 0) {
        Toast(@"请填选择所在地区");
        return;
    }
    [self submitDataRequest];
}

- (void)tt_pickerView:(TTPickerView *)pickerView completeArray:(NSMutableArray<TTPickerModel *> *)comArray completeStr:(NSString *)comStr{
    self.cityLabel.text = comStr;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSMutableArray<TTPickerModel *> *)tt_pickerView:(TTPickerView *)pickerView didSelcetedTier:(NSInteger)tier selcetedValue:(TTPickerModel *)value{
    __block NSMutableArray *tempTown = [NSMutableArray array];
    [value.child enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempTown addObject:[TTPickerModel mj_objectWithKeyValues:obj]];
    }];
    return tempTown;
}

- (void) initView{
    [_addressCell.contentView addSubview:self.textView];
    [self addGesture:self.tableView];
    // 隐藏多余分割线
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = self.footerView;
    [self.footerView addSubview:self.saveButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    MV(weakSelf)
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(100)));
        make.right.equalTo(weakSelf.addressCell.mas_right).offset(-20);
        make.top.bottom.equalTo(@(0));
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(30));
        make.height.equalTo(@(45));
        make.left.equalTo(@(IPHONE6_W(15)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-15));
    }];
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    [self inspectionIntegrity];
}

/// 检查是否输入完整了
- (void) inspectionIntegrity{
//    NSString *username = self.nicknameTextField.text;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (row == 0) return _nicknameCell;
    if (row == 1) return _telCell;
    if (row == 2) return _dateCell;
    if (row == 3) return _cityCell;
    if (row == 4) return _addressCell;
    return [UITableViewCell new];
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==4) return IPHONE6_W(100);
    return IPHONE6_W(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        [self showDataPicker];
    } else if (indexPath.row==3) {
        [self click2One];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        // 拖动tableView时收起键盘
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kColorWithRGB(245, 244, 249);
    }
    return _tableView;
}

- (SCTextView *)textView{
    if (!_textView) {
        _textView = [[SCTextView alloc] init];
        _textView.font = kFontSizeMedium15;
        _textView.textColor = kTextColor102;
        _textView.placeholder = @"街道、楼牌号等";
    }
    return _textView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kClearColor];
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    }
    return _footerView;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kFontSizeMedium15;
        [_saveButton setTitle:@"确定申请" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_saveButton isRadius:YES];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf handleControlEvent:self.saveButton];
        }];
    }
    return _saveButton;
}

- (void) click2One{
    _pickerView = [[TTPickerView alloc] initWithFrame:self.view.bounds];
    _pickerView.delegate = self;
    _pickerView.titleText = @"选择区域";
    _pickerView.dataArray = self.pro;
    [self.view addSubview:self.pickerView];
}

- (NSMutableArray *)pro{
    if (!_pro) {
        _pro = [[NSMutableArray alloc] init];
    }
    return _pro;
}

/// 选择机票查询日期
- (void) showDataPicker{
    [self tapGesture];
    NSString *minDateStr = [Utils lz_getCurrentTime];
    NSString *maxDateStr = @"";
    NSString *defaultSelValue = [self.dateLabel.text isEqualToString:@"请选择"]?[Utils lz_getCurrentDate]:self.dateLabel.text;
    MV(weakSelf)
    /**
     *  显示时间选择器
     *
     *  @param title            标题
     *  @param type             类型（时间、日期、日期和时间、倒计时）
     *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
     *  @param minDateStr       最小时间（如：2015-08-28 00:00:00），可为空
     *  @param maxDateStr       最大时间（如：2018-05-05 00:00:00），可为空
     *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
     *  @param resultBlock      选择结果的回调
     *
     */
    [LZDatePickerView showDatePickerWithTitle:@"" dateType:UIDatePickerModeDate defaultSelValue:defaultSelValue minDateStr:minDateStr maxDateStr:maxDateStr isAutoSelect:NO resultBlock:^(NSString *selectValue) {
        weakSelf.dateLabel.text = selectValue;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 生成订单且支付
- (void) GenerateOrderData:(NSInteger) idx{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    
    //    title    是    String    标题（当purchaseType=0时可传入固定值“会员充值”，purchaseType=6时可传入固定值“天合成员充值”，另外的情况请传入商品标题）
    //    purchaseType    是    int    支付类型 0：充值； 1：无人机商城产品；2：农用植保产品； 3：VR产品 4：纵横矿机产品 5：共享飞行产品; 6：天合成员充值；7：生态农业商城产品（消费）；8：飞机订票订单；9：购机预约订单（只能现金支付）；10：培训预约订单（只能现金支付）；11：体验预约订单（只能现金支付）
    //    priceMoney    是    double    单价金额
    //    number    是    double    产品数量(默认传1)
    //    proID    否    int    产品ID（当purchaseType=0（充值）或=6（天合成员充值）时不传）
    //    addressID    否    int    用户选择的收货地址表ID（当purchaseType=1或7必传）
    //    spec    否    String    用户选择规格
    //    color    否    String    用户选择颜色
    //    remarks    否    String    用户购买备注
    //    payType    是    int    0:支付宝 1:微信 2：余额支付
    //    currency    是    Double    vr币数量
    //    subscribeID    否    int    预约表ID（插入预约表后，必传）
    kShowMBProgressHUD(self.view);
    RecommendChildModel *model = self.recommendedModel.data;
    [parameter setObject:model.title forKey:@"title"];
    [parameter setObject:@(9) forKey:@"purchaseType"];
    [parameter setObject:@([model.deposit doubleValue]) forKey:@"priceMoney"];
    [parameter setObject:@(1) forKey:@"number"];
    [parameter setObject:@([model.kid integerValue]) forKey:@"proID"];
    [parameter setObject:@"" forKey:@"addressID"];
    [parameter setObject:@"" forKey:@"spec"];
    [parameter setObject:@"" forKey:@"color"];
    [parameter setObject:@"" forKey:@"remarks"];
    [parameter setObject:@(idx) forKey:@"payType"];/// 支付方式  0:支付宝 1:微信 2：余额支付
    [parameter setObject:@"" forKey:@"currency"];
    [SCHttpTools postWithURLString:kHttpURL(@"orderform/PayFrom") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000) {
            if (idx==0) {/// 支付宝支付
                [AlipayManager doAlipayPay:model];
            }else if(idx==1){/// 微信支付
                NSString *str = [Utils lz_dataWithJSONObject:result];
                TTLog(@"str == %@",str);
                [AlipayManager doWechatPay:model];
            }else if(idx==2){
                Toast(@"支付成功");
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                Toast(@"未知支付");
            }
        }else{
            Toast(model.message);
        }
        kHideMBProgressHUD(self.view);;
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
        kHideMBProgressHUD(self.view);;
    }];
}

- (void) submitDataRequest{
    
    /**
     contacts    是    String    联系人
     phone    是    String    联系电话
     type    是    int    预约类型1：购机预约；2：培训预约；3：体验预约
     fpID    是    int    飞行产品信息ID或飞行培训表ID
     subscribeTime    否    String    预约时间(type=1或3时必填)
     subscribeAddress    否    String    预约地址(type=1或3时必填)
     subscribeCourseName    否    String    预约课程名称(type=2时必填)
     subscribeCourseId    否    int    预约课程ID(type=2时必填)
     subscribeModelName    否    String    预约机型名称(type=2时必填)
     subscribeModelId    否    int    预约机型ID(type=2时必填)
     */
    
    RecommendChildModel *model = self.recommendedModel.data;
    NSString *addressText = [NSString stringWithFormat:@"%@%@",self.cityLabel.text,self.textView.text];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.nicknameTextField.text forKey:@"contacts"];
    [parameter setObject:self.telTextField.text forKey:@"phone"];
    [parameter setObject:@"1" forKey:@"type"];
    [parameter setObject:model.kid forKey:@"fpID"];
    [parameter setObject:self.dateLabel.text forKey:@"subscribeTime"];
    [parameter setObject:addressText forKey:@"subscribeAddress"];
    //    [parameter setObject:model. forKey:@"subscribeCourseName"];
    [parameter setObject:@"" forKey:@"subscribeCourseId"];
    [parameter setObject:@"" forKey:@"subscribeModelName"];
    [parameter setObject:@"" forKey:@"subscribeModelId"];
    kShowMBProgressHUD(self.view);
    MV(weakSelf)
    [SCHttpTools postWithURLString:kHttpURL(@"flightproduct/flightProductPage") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000) {
            TTLog(@"  --- %@",self.recommendedModel.data.deposit);
            NSString *amountText = self.recommendedModel.data.deposit;
            if (amountText.floatValue!=0) {
                [self.showView addAnimate];
            }else{
                TXConventionSucceViewController *viewController = [[TXConventionSucceViewController alloc] init];
                [weakSelf sc_centerPresentController:viewController presentedSize:CGSizeMake(IPHONE6_W(280), IPHONE6_W(260)) completeHandle:^(BOOL presented) {
                    if (presented) {
                        TTLog(@"弹出");
                    }else{
                        TTLog(@"消失");
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        }
        kHideMBProgressHUD(self.view);
    } failure:^(NSError *error) {
        kHideMBProgressHUD(self.view);
    }];
}

@end
