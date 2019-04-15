//
//  TXSubmitOrderViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/26.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXSubmitOrderViewController.h"
#import "TXReceiveAddressTableViewCell.h"
#import "TXShoppingTableViewCell.h"
#import "TXChoosePayTableViewCell.h"
#import "TXPurchaseQuantityTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXAddressViewController.h"
#import "TXAddressModel.h"


static NSString * const reuseIdentifierReceiveAddress = @"TXReceiveAddressTableViewCell";
static NSString * const reuseIdentifierShopping = @"TXShoppingTableViewCell";
static NSString * const reuseIdentifierChoosePay = @"TXChoosePayTableViewCell";
static NSString * const reuseIdentifierPurchase = @"TXPurchaseQuantityTableViewCell";

@interface TXSubmitOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 底部视图
@property (nonatomic, strong) UIView        *footerView;
/// 提交按钮
@property (nonatomic, strong) UIButton      *submitButton;
/// 提交按钮
@property (nonatomic, strong) UILabel       *totalTitleLabel;
/// 提交按钮
@property (nonatomic, strong) UILabel       *totalAmountLabel;
/// 付款方式数组
@property (nonatomic, strong) NSMutableArray *paymentArray;
@property (nonatomic, strong) AddressModel  *addressModel;
@property (nonatomic, assign) NSInteger  addressNum;
/// 产品Model
@property (strong, nonatomic)  NewsRecordsModel *model;
/// 2:默认没选择支付方式 0:微信 1:支付宝
@property (assign, nonatomic)  NSInteger payType;

@end

@implementation TXSubmitOrderViewController
- (id) initNewsRecordsModel:(NewsRecordsModel *)model{
    if ( self = [super init] ){
        self.model = model;
        self.payType = 2;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付中心";
    [self initView];
    self.addressModel = [[AddressModel alloc] init];
    NSInteger totalAmount = self.model.buyCount*[self.model.price integerValue];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%ld.00",(long)totalAmount];
    /// 通知得到默认收货地址
//    [kNotificationCenter postNotificationName:@"reloadAddressData" object:nil];
    [self getAddressModel];
}

- (void) submitBtnClick:(UIButton *)sender{
    if (self.payType==2) {
        Toast(@"请选择支付方式");
        return;
    }
}

- (void) getAddressModel{
    [SCHttpTools getWithURLString:kHttpURL(@"address/GetAddress") parameter:nil success:^(id responseObject) {
        NSDictionary *results = responseObject;
        if ([results isKindOfClass:[NSDictionary class]]) {
            TXAddressModel *addressModel = [TXAddressModel mj_objectWithKeyValues:results];
            if (addressModel.errorcode == 20000) {
                self.addressNum = addressModel.data.count;
                for (AddressModel *model in addressModel.data) {
                    if (model.isDefault) {
                        self.addressModel = model;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
                    }
                }
                [self.tableView reloadData];
            }else{
                Toast(addressModel.message);
            }
        }
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
    }];
}

#pragma mark ---- 界面布局设置
- (void)initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [self.footerView addSubview:self.submitButton];
    [self.footerView addSubview:self.totalTitleLabel];
    [self.footerView addSubview:self.totalAmountLabel];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(kTabBarHeight));
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat height = IPHONE6_W(35);
        CGFloat top = (kTabBarHeight-height-kSafeAreaBottomHeight)/2;
        make.right.equalTo(self.footerView.mas_right).offset(IPHONE6_W(-15));
        make.height.equalTo(@(height));
        make.width.equalTo(@(IPHONE6_W(85)));
        make.top.equalTo(@(top));
    }];
    
    [self.totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.submitButton.mas_left).offset(-15);
        make.centerY.equalTo(self.submitButton);
    }];
    
    [self.totalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalAmountLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.submitButton);
    }];
}

/**
 *  点击增加按钮
 *  tag:0 增加 tag:1 减少
 *  @param sender 当前按钮
 */
- (void)onClickBtn:(UIButton *)sender {
    if (sender.tag==0) {
        self.model.buyCount += 1;
    }else{
        self.model.buyCount = (self.model.buyCount<2) ? 1 : (self.model.buyCount-= 1);
    }
    NSInteger totalAmount = self.model.buyCount*[self.model.price integerValue];
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%ld.00",(long)totalAmount];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            TXReceiveAddressTableViewCell*tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiveAddress forIndexPath:indexPath];
            tools.nicknameLabel.text = self.addressModel.username;//@"李阿九";
            tools.telphoneLabel.text = self.addressModel.telphone;//@"13566667888";
            tools.addressLabel.text = self.addressModel.address;//@"四川 成都 高新区 环球中心W6区 1518室";
            tools.addButton.userInteractionEnabled = NO;
            if ((self.addressNum==0)&&(!self.addressModel.isDefault)) {
                tools.imagesView.hidden = YES;
                tools.imagesView.hidden = NO;
            }
            return tools;
        }
            break;
        case 1: {
            TXShoppingTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierShopping forIndexPath:indexPath];
            tools.model = self.model;
            return tools;
        }
            break;
        case 2: {
            TXPurchaseQuantityTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPurchase forIndexPath:indexPath];
            MV(weakSelf)
            [tools.reductionBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                [weakSelf onClickBtn:tools.reductionBtn];
            }];
            [tools.increaseBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                [weakSelf onClickBtn:tools.increaseBtn];
            }];
            tools.quantityLabel.text = [NSString stringWithFormat:@"%ld",(long)self.model.buyCount];
            return tools;
        }
            break;
        case 3: {
            TXGeneralModel *model = self.paymentArray[indexPath.row];
            TXChoosePayTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierChoosePay forIndexPath:indexPath];
            tools.titleLabel.text = model.title;
            tools.chooseBtn.tag = indexPath.row;
            tools.chooseBtn.selected = indexPath.row ==0?YES:NO;
            tools.imagesView.image = kGetImage(model.imageText);
            tools.linerView.hidden = (indexPath.row!=self.paymentArray.count-1)?NO:YES;
            return tools;
        }
            break;
    }
    return [UITableViewCell new];
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==3) return self.paymentArray.count;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) return IPHONE6_W(70);
    if (indexPath.section==1) return IPHONE6_W(120);
    return IPHONE6_W(50);
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0||section==2) return 0;
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        TXAddressViewController *vc = [[TXAddressViewController alloc] init];
        MV(weakSelf)
        vc.selectedAddressBlock = ^(AddressModel * _Nonnull model) {
            weakSelf.addressModel = model;
            NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        TTPushVC(vc);
    }else if (indexPath.section==3){
        self.payType = indexPath.row;
        TXChoosePayTableViewCell *currentCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierChoosePay];
        UIButton *tmpBtn = (UIButton *)[currentCell viewWithTag:indexPath.row];
        TTLog(@"labelType -- %ld",(long)tmpBtn.tag);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXReceiveAddressTableViewCell class] forCellReuseIdentifier:reuseIdentifierReceiveAddress];
        [_tableView registerClass:[TXShoppingTableViewCell class] forCellReuseIdentifier:reuseIdentifierShopping];
        [_tableView registerClass:[TXChoosePayTableViewCell class] forCellReuseIdentifier:reuseIdentifierChoosePay];
        [_tableView registerClass:[TXPurchaseQuantityTableViewCell class] forCellReuseIdentifier:reuseIdentifierPurchase];
        
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
    }
    return _tableView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _footerView;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _submitButton.titleLabel.font = kFontSizeMedium15;
        [_submitButton setTitle:@"立即支付" forState:UIControlStateNormal];
        UIImage *image = [UIImage lz_imageWithColor:kColorWithRGB(211, 0, 0)];
        [_submitButton setBackgroundImage:image forState:UIControlStateNormal];
        [_submitButton lz_setCornerRadius:3.0];
        MV(weakSelf);
        [_submitButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                [weakSelf submitBtnClick:self.submitButton];
        }];
    }
    return _submitButton;
}

- (UILabel *)totalAmountLabel{
    if (!_totalAmountLabel) {
        _totalAmountLabel = [UILabel lz_labelWithTitle:@"" color:kColorWithRGB(211, 0, 0) font:kFontSizeMedium15];
    }
    return _totalAmountLabel;
}

- (UILabel *)totalTitleLabel{
    if (!_totalTitleLabel) {
        _totalTitleLabel = [UILabel lz_labelWithTitle:@"总计:" color:kTextColor102 font:kFontSizeMedium15];
    }
    return _totalTitleLabel;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)paymentArray{
    if (!_paymentArray) {
        _paymentArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@"微信支付",@"支付宝"];
        NSArray* classArr = @[@"c31_btn_wxzf",@"c31_btn_zfb"];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:j];
            generalModel.imageText = [classArr lz_safeObjectAtIndex:j];
            [_paymentArray addObject:generalModel];
        }
    }
    return _paymentArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
