//
//  TXTicketQueryViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTicketQueryViewController.h"
#import "LZDatePickerView.h"
#import "TXTicketListViewController.h"
#import "FMSelectedCityViewController.h"
#import "TXLoginViewController.h"


@interface TXTicketQueryViewController ()

@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIView *navigationBarView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

/// 出发城市按钮
@property (nonatomic, strong) IBOutlet UIButton *dep_city_btn;
/// 出发城市
@property (nonatomic, strong) IBOutlet UILabel *dep_city_label;
/// 出发城市天气
@property (nonatomic, strong) IBOutlet UIImageView *dep_city_weather;
/// 到达城市按钮
@property (nonatomic, strong) IBOutlet UIButton *arv_city_btn;
/// 到达城市
@property (nonatomic, strong) IBOutlet UILabel *arv_city_label;
/// 到达城市天气
@property (nonatomic, strong) IBOutlet UIImageView *arv_city_weather;

/// 选择的年月日
@property (nonatomic, strong) IBOutlet UILabel *date_select_label;
/// 年月日对应的星期几
@property (nonatomic, strong) IBOutlet UILabel *week_select_label;
/// 选择日期的按钮
@property (nonatomic, strong) IBOutlet UIButton *date_select_btn;

/// 搜索按钮
@property (nonatomic, strong) IBOutlet UIButton *searchButton;
@end

@implementation TXTicketQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
    NSString* province = [kUserDefaults objectForKey:@"city"];
    self.dep_city_label.text = province;
    self.arv_city_label.text = @"北京";
    self.date_select_label.text = [Utils lz_getNdayDate:3 isShowTime:NO];
    /// 根据当前日期转换星期
    self.week_select_label.text = [SCSmallTools tt_weekdayStringFromDate:[Utils lz_getNdayDate:3 isShowTime:NO]];
    self.dep_city_btn.tag = 100;
    self.arv_city_btn.tag = 200;
    MV(weakSelf)
    /// 出发城市选择
    [self.dep_city_btn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf citySelected:self.dep_city_btn];
    }];
    /// 到达城市选择
    [self.arv_city_btn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf citySelected:self.arv_city_btn];
    }];
    /// 日期选择
    [self.date_select_btn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf showDataPicker];
    }];
    /// 搜索按
    [self.searchButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf searchBtnClick];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void) citySelected:(UIButton *) sender{
    MV(weakSelf)
    FMSelectedCityViewController *vc= [[FMSelectedCityViewController alloc] init];
    LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:vc];
    [vc returnText:^(NSString *cityname) {
        if (sender.tag == 100) {
            weakSelf.dep_city_label.text = cityname;
        }else{
            weakSelf.arv_city_label.text = cityname;
        }
    }];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        TTLog(@"城市选择");
    }];
}

/// 选择机票查询日期
- (void) showDataPicker{
    [self tapGesture];
    
    NSString *minDateStr = [Utils lz_getNdayDate:3 isShowTime:YES];
    NSString *maxDateStr = @"";
    NSString *defaultSelValue = self.date_select_label.text;
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
        weakSelf.date_select_label.text = selectValue;
        weakSelf.week_select_label.text = [SCSmallTools tt_weekdayStringFromDate:selectValue];
    }];
}

/** 保存 */
- (void) searchBtnClick{
    
    if (!kUserInfo.isLogin) {
        TXLoginViewController *vc = [[TXLoginViewController alloc] init];
        LZNavigationController *navigation = [[LZNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navigation animated:YES completion:^{
            TTLog(@"登录界面");
        }];
        return;
    }
    
    NSString *startPlace= self.dep_city_label.text;
    NSString *endPlace = self.arv_city_label.text;
    
    if (startPlace.length == 0) {
        Toast(@"请输入出发地");
        return;
    }
    if (endPlace.length == 0) {
        Toast(@"请输入目的地");
        return;
    }
    NSString *URLString = @"https://api.shenjian.io/?appid=7c0ec630c4f4bd5179c8978365d999da";
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.dep_city_label.text forKey:@"fromCity"];
    [parameter setObject:self.arv_city_label.text forKey:@"toCity"];
    [parameter setObject:self.date_select_label.text forKey:@"date"];
    /// 机票查询接口
    TXTicketListViewController *vc = [[TXTicketListViewController alloc] initTicketListWithURLString:URLString parameter:parameter];
    TTPushVC(vc);
}


- (void) initView{
    [Utils lz_setButtonWithBGImage:self.searchButton isRadius:YES];
    [self.view addSubview:self.navigationView];
    [self.navigationView addSubview:self.navigationBarView];
    [self.navigationBarView addSubview:self.leftButton];
    [self.navigationBarView addSubview:self.rightButton];
    
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@(kNavBarHeight));
    }];
    
    [self.navigationBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.navigationView);
        make.height.equalTo(@(kNavBarHeight-20));
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self.navigationBarView);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationBarView.mas_right).offset(IPHONE6_W(-15));
        make.centerY.equalTo(self.navigationBarView);
    }];
}

- (UIView *)navigationView{
    if (!_navigationView) {
        _navigationView = [UIView lz_viewWithColor:kClearColor];
    }
    return _navigationView;
}

- (UIView *)navigationBarView{
    if (!_navigationBarView) {
        _navigationBarView = [UIView lz_viewWithColor:kClearColor];
    }
    return _navigationBarView;
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:kGetImage(@"live_btn_back") forState:UIControlStateNormal];
        MV(weakSelf)
        [_leftButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        _leftButton.hidden = YES;
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitleColor:kTextColor51 forState:UIControlStateNormal];
        _rightButton.titleLabel.font = kFontSizeMedium12;
        [_rightButton setTitle:[kUserDefaults objectForKey:@"city"] forState:UIControlStateNormal];
        [Utils lz_setButtonTitleWithImageEdgeInsets:_rightButton postition:kMVImagePositionLeft spacing:5.0];
        [_rightButton setImage:kGetImage(@"c48_btn_定位") forState:UIControlStateNormal];
    }
    return _rightButton;
}

@end

