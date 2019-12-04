//
//  YKChoosePayViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/10.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKChoosePayViewController.h"
#import "AlipayManager.h"

@interface YKChoosePayViewController ()
/// 关闭按钮
@property (nonatomic, strong) UIView *headerView;
/// 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
/// 关闭按钮
@property (nonatomic, strong) UIButton *submitButton;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 分割线
@property (nonatomic, strong) UIView *linerView;
/// 分割线
@property (nonatomic, strong) NSMutableDictionary *parameter;
@property (nonatomic, strong) ChoosePayModel *pay_model;
@end

@implementation YKChoosePayViewController
- (id)initDictionary:(NSMutableDictionary *)parameter{
    if ( self = [super init] ){
        self.parameter = parameter;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view lz_setCornerRadius:10.0];
    [self initView];
    [self.submitButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self submitOrderGetSignature];
    }];
}

/// 提交订单,获取支付签名
- (void) submitOrderGetSignature{
    NSString *URLString = kHttpURL(@"flight-order/addFlightOrder");
    kShowMBProgressHUD(self.view);
    TTLog(@"参数 -- %@",self.parameter);
    [SCHttpTools postWithURLString:URLString parameter:self.parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TTLog(@"result --- %@",result);
        TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000) {
            if (self.pay_model.kid.integerValue==0) {
                [AlipayManager doAlipayPay:model];
            }else if(self.pay_model.kid.integerValue==1){
                [AlipayManager doWechatPay:model];
            }else{
                Toast(@"未知支付方式");
            }
            [self sc_dismissVC];
        }else{
            Toast(model.message);
        }
        kHideMBProgressHUD(self.view);
    } failure:^(NSError *error) {
        kHideMBProgressHUD(self.view);
    }];
}

- (void) initView{
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.linerView];
    [self.headerView addSubview:self.closeButton];
    [self.view addSubview:self.paySingleView];
    [self.view addSubview:self.submitButton];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(50));
    }];
    [self.linerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.headerView);
        make.height.equalTo(@(0.5));
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.height.width.equalTo(self.headerView.mas_height);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.headerView);
    }];
    
    [self.paySingleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linerView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(140));
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(IPHONE6_W(45)));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:kGetImage(@"c31_btn_close") forState:UIControlStateNormal];
        MV(weakSelf);
        [_closeButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _closeButton;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"立即支付" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_submitButton isRadius:YES];
    }
    return _submitButton;
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

- (TXChoosePaySingleView *)paySingleView {
    if (!_paySingleView) {
        _paySingleView = [TXChoosePaySingleView initTableWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
        //        _paySingleView.dataArray = self.dataArray;
        //        _paySingleView.chooseContent = self.selectMusicStr;
        [_paySingleView reloadData];
        //选中内容
        MV(weakSelf)
        _paySingleView.chooseBlock = ^(ChoosePayModel * _Nonnull model) {
            TTLog(@"数据：%@ ；第%@行",model.titleName,model.kid);
            weakSelf.pay_model = model;
            [weakSelf.parameter setObject:model.kid forKey:@"payType"];
        };
    }
    return _paySingleView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView  = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _headerView;
}
@end
