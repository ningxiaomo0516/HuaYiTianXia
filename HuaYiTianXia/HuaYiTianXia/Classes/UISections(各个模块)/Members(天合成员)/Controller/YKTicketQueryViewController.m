//
//  YKTicketQueryViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/8.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKTicketQueryViewController.h"
#import "YKTicketQueryBoxView.h"
#import "FMSelectedCityViewController.h"
#import "TXLoginViewController.h"
#import "TXTicketListViewController.h"
#import "LZDatePickerView.h"
#import "YKBuyTicketViewController.h"
#import "YKPassengersViewController.h"
#import "YKReceiveWineViewController.h"

@interface YKTicketQueryViewController ()
@property (nonatomic, strong) UIImageView *imagesView;
@property (nonatomic, strong) UIImageView *imagesView_b;
@property (nonatomic, strong) YKTicketQueryBoxView *boxView;
@property (nonatomic, strong) NSString *dep_date_text;
/// 仓位等级
@property (nonatomic, strong) NSString *cabin_level;
/// 乘客类型
@property (nonatomic, strong) NSString *passenger_type;
@property (nonatomic, strong) NSString *arrCode;
@property (nonatomic, strong) NSString *depCode;
@end

@implementation YKTicketQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.imagesView.image = kGetImage(@"zx_live_bg");
    /// 设置View的背景图
    [self.boxView tt_addShadowToViewWithColor:kColorWithRGB(210, 210, 210)];
    
    self.depCode = @"ZHY";//@"CTU";
    self.arrCode = @"INC";//@"BJS";
    self.boxView.dep_citylabel.text = @"中卫";
    self.boxView.arv_citylabel.text = @"银川";
//    self.boxView.dep_citylabel.text = @"成都";
//    self.boxView.arv_citylabel.text = @"北京";
    self.boxView.dep_titlelabel.text = @"出发日期";
//    self.boxView.dep_datelabel.text = @"9月30日";
//    self.boxView.dep_weeklabel.text = @"周日";
    
    self.boxView.dep_seatlabel.text = @"经济舱";
    /// 默认乘客类型为成人
    self.passenger_type = @"1";
    /// 默认仓位等级
    self.cabin_level = @"3";
    self.dep_date_text = [Utils lz_getNdayDate:0 isShowTime:NO];
    NSArray *dateArray = [self.dep_date_text componentsSeparatedByString:@"-"];
    self.boxView.dep_datelabel.text = [NSString stringWithFormat:@"%@月%@日",dateArray[1],dateArray[2]];
    /// 根据当前日期转换星期
    self.boxView.dep_weeklabel.text = [SCSmallTools tt_weekdayStringFromDate:self.dep_date_text];
    
    MV(weakSelf)
    [self.boxView.babyButtton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        weakSelf.boxView.babyButtton.selected = !weakSelf.boxView.babyButtton.selected;
        if (self.boxView.childButton.selected) {
            self.boxView.childButton.selected = !self.boxView.childButton.selected;
        }
    }];
    [self.boxView.childButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        weakSelf.boxView.childButton.selected = !weakSelf.boxView.childButton.selected;
        if (self.boxView.babyButtton.selected) {
            self.boxView.babyButtton.selected = !self.boxView.babyButtton.selected;
        }
    }];
    [self.boxView.dep_seat_btn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self showSexActionSheet:@[@"头等舱",@"商务舱",@"经济舱"]];
    }];
    [self.boxView.dep_city_btn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf citySelected:self.boxView.dep_city_btn];
    }];
    [self.boxView.arv_city_btn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf citySelected:self.boxView.arv_city_btn];
    }];
    /// 日期选择
    [self.boxView.date_select_btn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf showDataPicker];
    }];
    /// 搜索按
    [self.boxView.searchButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf searchBtnClick];
//        YKPassengersViewController *vc = [[YKPassengersViewController alloc] init];
//        vc.returnBlock = ^(PassengerModel * _Nonnull passengerModel) {
//            TTLog(@" --- %@",passengerModel.identityNo);
//        };
//        TTPushVC(vc);
    }];
}

/** 保存 */
- (void) searchBtnClick{
    NSString *startPlace= self.boxView.dep_citylabel.text;
    NSString *endPlace = self.boxView.arv_citylabel.text;
    
    if (startPlace.length == 0) {
        Toast(@"请输入出发地");
        return;
    }
    if (endPlace.length == 0) {
        Toast(@"请输入目的地");
        return;
    }
    
    NSString *URLString = kHttpURL(@"flight/getFlightList");
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.arrCode forKey:@"arrCode"];
    [parameter setObject:self.depCode forKey:@"depCode"];
    /// cabinClass 仓位等级 1:头等舱 2:商务舱 3:经济舱
    [parameter setObject:self.cabin_level forKey:@"cabinClass"];
    /// 乘客类型 乘客类型1:成人 2:儿童 3:成人+儿童 4:成人+婴儿 5:成人+儿童+婴儿 (目前不支持婴儿查询)
    [parameter setObject:self.passenger_type forKey:@"passengerType"];
    [parameter setObject:self.dep_date_text forKey:@"depTime"];
    /// 机票查询接口
    TXTicketListViewController *vc = [[TXTicketListViewController alloc] initTicketListWithURLString:URLString parameter:parameter];
    TTPushVC(vc);
}

/// 选择机票查询日期
- (void) showDataPicker{
    [self tapGesture];
    
    NSString *minDateStr = [Utils lz_getNdayDate:0 isShowTime:YES];
    NSString *maxDateStr = @"";
    NSString *defaultSelValue = self.dep_date_text;
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
        weakSelf.dep_date_text = selectValue;
        weakSelf.boxView.dep_weeklabel.text = [SCSmallTools tt_weekdayStringFromDate:selectValue];
        NSArray *dateArray = [weakSelf.dep_date_text componentsSeparatedByString:@"-"];
        self.boxView.dep_datelabel.text = [NSString stringWithFormat:@"%@月%@日",dateArray[1],dateArray[2]];
    }];
}

- (void) citySelected:(UIButton *) sender{
    MV(weakSelf)
    FMSelectedCityViewController *vc= [[FMSelectedCityViewController alloc] init];
    LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:vc];
    [vc returnText:^(CityModel *cityModel) {
        if (sender.tag == 100) {
            weakSelf.boxView.dep_citylabel.text = cityModel.cityCName;
            self.depCode = cityModel.cityCode;
        }else{
            weakSelf.boxView.arv_citylabel.text = cityModel.cityCName;
            self.arrCode = cityModel.cityCode;
        }
    }];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        TTLog(@"城市选择");
    }];
}

/// 选择性别
- (void) showSexActionSheet:(NSArray *)dataArray{
    // 使用方式
    LZActionSheet *actionSheet = [[LZActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:dataArray actionSheetBlock:^(NSInteger buttonIndex) {
        [self clickedButtonAtIndex:buttonIndex];
    }];
    [actionSheet showView];
}

/// 性别设置
- (void) clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        self.cabin_level = @"1";
        self.boxView.dep_seatlabel.text = @"头等舱";
    }else if(buttonIndex==1){
        self.cabin_level = @"2";
        self.boxView.dep_seatlabel.text = @"商务舱";
    }else if(buttonIndex==2){
        self.cabin_level = @"3";
        self.boxView.dep_seatlabel.text = @"经济舱";
    }
}

- (void) initView{
    [self.view addSubview:self.imagesView];
    [self.view addSubview:self.boxView];
    [self.view addSubview:self.imagesView_b];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
    }];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagesView.mas_bottom).offset(-40);
        make.left.equalTo(@(15));
        make.height.equalTo(@(300));
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    
    [self.imagesView_b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.boxView.mas_bottom).offset(16);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (YKTicketQueryBoxView *)boxView{
    if (!_boxView) {
        _boxView = [[YKTicketQueryBoxView alloc] init];
    }
    return _boxView;
}

- (UIImageView *)imagesView_b{
    if (!_imagesView_b) {
        _imagesView_b = [[UIImageView alloc] init];
        _imagesView_b.image = kGetImage(@"旅行_消费_送礼");
        _imagesView_b.userInteractionEnabled = YES;//打开用户交互
        //初始化一个手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        //为图片添加手势
        [_imagesView_b addGestureRecognizer:tapGesture];
    }
    return _imagesView_b;
}

//点击事件
- (void)singleTapAction:(UITapGestureRecognizer *) recognizer{
//    YKReceiveWineViewController *vc = [[YKReceiveWineViewController alloc] init];
//    vc.webURL = kAppendH5URL(DomainName, @"appH5/index.html",@"");
//    //        [self.navigationController presentViewController:vc animated:YES completion:nil];
//    TTPushVC(vc);
}
@end
