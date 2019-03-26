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


static NSString * const reuseIdentifierReceiveAddress = @"TXReceiveAddressTableViewCell";
static NSString * const reuseIdentifierShopping = @"TXShoppingTableViewCell";
static NSString * const reuseIdentifierChoosePay = @"TXChoosePayTableViewCell";

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

@end

@implementation TXSubmitOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付中心";
    [self initView];
    
    self.totalAmountLabel.text = @"10000.00";
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
        make.right.equalTo(self.footerView.mas_right).offset(IPHONE6_W(-15));
        make.height.equalTo(@(IPHONE6_W(35)));
        make.width.equalTo(@(IPHONE6_W(85)));
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

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TXReceiveAddressTableViewCell*tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiveAddress forIndexPath:indexPath];
        tools.nicknameLabel.text = @"李阿九";
        tools.telphoneLabel.text = @"13566667888";
        tools.addressLabel.text = @"四川 成都 高新区 环球中心W6区 1518室";
        return tools;
    }else if(indexPath.section==2){
        TXShoppingTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierShopping forIndexPath:indexPath];
        tools.titleLabel.text = @"法国进口红酒 传奇波尔多干葡萄";
        tools.imagesView.image = kGetImage(@"test_work");
        tools.specLabel.text = @"规格:苏哈相机";
        tools.subtitleLabel.text = @"Mavic 2带屏升级版火爆销售中，5.5寸高亮屏，高清图片上传会员减免优币抵现";
        tools.priceLabel.text = @"¥399.00";
        return tools;
    }else{
        TXChoosePayTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierChoosePay forIndexPath:indexPath];
//        tools.titleLabel.text = @"法国进口红酒 传奇波尔多干葡萄";
//        tools.imagesView.image = kGetImage(@"test_work");
//        tools.specLabel.text = @"规格:苏哈相机";
//        tools.subtitleLabel.text = @"Mavic 2带屏升级版火爆销售中，5.5寸高亮屏，高清图片上传会员减免优币抵现";
//        tools.priceLabel.text = @"¥399.00";
        return tools;
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
    if (indexPath.section==0) return IPHONE6_W(65);
    return IPHONE6_W(120);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXReceiveAddressTableViewCell class] forCellReuseIdentifier:reuseIdentifierReceiveAddress];
        [_tableView registerClass:[TXShoppingTableViewCell class] forCellReuseIdentifier:reuseIdentifierShopping];
        [_tableView registerClass:[TXChoosePayTableViewCell class] forCellReuseIdentifier:reuseIdentifierChoosePay];
        
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,IPHONE6_W(15),0,0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kWhiteColor;
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
            //            [weakSelf saveBtnClick:self._submitButton];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
