//
//  TXConversionViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXConversionViewController.h"
#import "TXRepeatCastTemplateTableViewCell.h"
#import "TXRolloutTableViewCell.h"
#import "TXRolloutTypeViewController.h"
#import "TXPayPasswordViewController.h"

static NSString * const reuseIdentifier = @"TXRepeatCastTemplateTableViewCell";
static NSString * const reuseIdentifierRollout = @"TXRolloutTableViewCell";

@interface TXConversionViewController ()<UITableViewDelegate,UITableViewDataSource,TTPopupViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIView *footerView;
@property (strong, nonatomic) UILabel *titlelabel;
/// 复投金额
@property (copy, nonatomic) NSString *amountText;
/// 货币类型
@property (copy, nonatomic) NSString *currencyText;
@property (copy, nonatomic) NSString *kid;

@end

@implementation TXConversionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.title = @"AH转换";
    // 注册通知
    [kNotificationCenter addObserver:self selector:@selector(dealwithNotice) name:@"conversionRequest" object:nil];
}

- (void) dealwithNotice{
    [self dismissedButtonClicked];
    /// 目前只支持AH转换VH
    NSString *URLString = [NSString new];
    if ([self.kid integerValue]==0) {
        URLString = kHttpURL(@"customer/ARToStock");
    }else{
        URLString = kHttpURL(@"customer/ARToStock");
    }
    kShowMBProgressHUD(self.view);
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.amountText forKey:@"arcurrency"];
    [SCHttpTools postWithURLString:URLString parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTLog(@"result -- %@",result);
            TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
            if (model.errorcode==20000) {
                Toast(@"转换成功");
                [kNotificationCenter addObserver:self selector:@selector(reloadData) name:@"reloadMineData" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"获取城市数据失败");
        }
        kHideMBProgressHUD(self.view);;
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
        kHideMBProgressHUD(self.view);;
    }];
}


/** 完成转换按钮 */
- (void) doneBtnClick:(UIButton *) sender{
    if (self.currencyText.length == 0) {
        Toast(@"请选择类型");
        return;
    }
    if (self.amountText.length == 0) {
        Toast(@"请输入转换金额");
        return;
    }
    TXPayPasswordViewController *viewController = [[TXPayPasswordViewController alloc] init];
    viewController.pageType = 2;
    viewController.tipsText = @"VH";
    viewController.integralText = self.amountText;
    viewController.delegate = self;
    [self presentPopupViewController:viewController animationType:TTPopupViewAnimationFade];
}

/// 关闭当前交易密码弹出的窗口
- (void)dismissedButtonClicked{
    [self dismissPopupViewControllerWithanimationType:TTPopupViewAnimationFade];
}

- (void) initView{
    
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.footerView addSubview:self.titlelabel];
    [self.footerView addSubview:self.doneButton];
    self.tableView.tableFooterView = self.footerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(IPHONE6_W(15)));
    }];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titlelabel.mas_bottom).offset(IPHONE6_W(25));
        make.left.equalTo(@(IPHONE6_W(15)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-15));
        make.height.equalTo(@(45));
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        TXRepeatCastTemplateTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.integralText = kStringFormat(@"AH资产余额:", kUserInfo.arcurrency);
        return tools;
    }else{
        TXRolloutTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRollout forIndexPath:indexPath];
        tools.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            if (self.currencyText.length==0) {
                tools.subtitleLabel.text = @"选择转换资产";
            }else{
                tools.subtitleLabel.text = self.currencyText;
            }
            tools.subtitleLabel.hidden = NO;
            tools.imagesArrow.hidden = NO;
            tools.textField.hidden = YES;
            tools.titleLabel.text = @"转换类型";
        }else{
            tools.titleLabel.text = @"转换金额";
            tools.textField.placeholder = @"请输入转换金额";
            tools.textField.ry_inputType = RYFloatInputType;
            [tools.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        }
        return tools;
    }
    return [UITableViewCell new];
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==1) return 2;
    return 1;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) return IPHONE6_W(48);
    return IPHONE6_W(55);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1 && indexPath.row==0) {
        TXRolloutTypeViewController *vc = [[TXRolloutTypeViewController alloc] init];
        vc.pageType = 0;
        MV(weakSelf)
        vc.typeBlock = ^(NSString * _Nonnull text, NSString * _Nonnull kid) {
            weakSelf.kid = kid;
            weakSelf.currencyText = text;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        CGFloat height = kiPhoneX_T(IPHONE6_W(70));
        [self sc_bottomPresentController:vc presentedHeight:height completeHandle:^(BOOL presented) {
            if (presented) {
                TTLog(@"弹出了");
            }else{
                TTLog(@"消失了");
            }
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldWithText:(UITextField *)textField{
    self.amountText = textField.text;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXRepeatCastTemplateTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXRolloutTableViewCell class] forCellReuseIdentifier:reuseIdentifierRollout];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kTableViewInSectionColor;
    }
    return _tableView;
}

- (UIButton *)doneButton{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _doneButton.titleLabel.font = kFontSizeMedium15;
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton setBackgroundImage:kGetImage(@"c31_denglu") forState:UIControlStateNormal];
        MV(weakSelf);
        [_doneButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf doneBtnClick:self.doneButton];
        }];
    }
    return _doneButton;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor128 font:kFontSizeMedium13];
        _titlelabel.text = @"规则：输入的金额为100的倍数";
    }
    return _titlelabel;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kClearColor];
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    }
    return _footerView;
}

- (void)dealloc{
    [kNotificationCenter removeObserver:self];
}
@end
