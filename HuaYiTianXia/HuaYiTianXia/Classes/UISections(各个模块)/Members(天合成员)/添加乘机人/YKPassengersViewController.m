//
//  YKPassengersViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/11.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKPassengersViewController.h"
#import "YKPassengersTableViewCell.h"
#import "YKBuyTicketIntroduceViewController.h"
#import "LZDatePickerView.h"

@interface YKPassengersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *footerButton;

/// 真实姓名
@property (nonatomic, copy) NSString *realname;
/// 生日
@property (nonatomic, copy) NSString *birthday;
/// 境内电话
@property (nonatomic, copy) NSString *telphone;
/// 证件号码
@property (nonatomic, copy) NSString *idnumber;

@end

@implementation YKPassengersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.contents = (id)kGetImage(@"trip_box_view").CGImage;
    [self initView];
    [self.footerButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self jumpView];
    }];
    [self addGesture:self.tableView];
    self.realname = @"";
    self.birthday = @"";
    self.telphone = @"";
    self.idnumber = @"";
}

- (void) jumpView{
    YKBuyTicketIntroduceViewController *vc = [[YKBuyTicketIntroduceViewController alloc] init];
    CGFloat height = kScreenHeight - (kScreenHeight/4);
    [self sc_bottomPresentController:vc presentedHeight:height completeHandle:^(BOOL presented) {
        if (presented) {
            TTLog(@"弹出了");
        }else{
            TTLog(@"消失了");
        }
    }];
}

- (void) saveData {
    if (self.realname.length==0) {
        Toast(@"请输入真实姓名!");
        return;
    }
    if (self.idnumber.length==0) {
        Toast(@"请输入证件号码!");
        return;
    }
    if (![SCSmallTools tt_simpleVerifyIdentityCardNum:self.idnumber]) {
        Toast(@"请输入正确的身份证号码!");
        return;
    }
    if (self.birthday.length==0) {
        Toast(@"请选择出生日期!");
        return;
    }
    if (self.telphone.length==0) {
        Toast(@"请输入电话号码!");
    }if (![SCSmallTools checkTelNumber:self.telphone]) {
        Toast(@"请输入正确的电话号码!");
        return;
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    /// 真实姓名
    [parameter setObject:self.realname forKey:@"name"];
    /// 1:身份证 2:其他证件
    [parameter setObject:@"1" forKey:@"identityType"];
    /// 证件号码
    [parameter setObject:self.idnumber forKey:@"identityNo"];
    /// 电话号码
    [parameter setObject:self.telphone forKey:@"phoneNum"];
    TTLog(@"parameter ---- %@",parameter);
//    PassengerModel *model = [[PassengerModel alloc] init];
//    model.name = self.realname;
//    model.identityType = @"1";
//    model.identityNo = self.idnumber;
//    model.phoneNum = self.telphone;
    /// 新增乘机人，默认选中
//    model.isSelected = YES;
////    self.returnBlock(model);
//    [self.navigationController popViewControllerAnimated:YES];
    kShowMBProgressHUD(self.view);
    [SCHttpTools postWithURLString:kHttpURL(@"passenger/add") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TTLog(@"result -- %@",result);
        TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
        if (model.errorcode==20000) {
            Toast(model.message);
            PassengerModel *model = [[PassengerModel alloc] init];
            model.name = self.realname;
            model.identityType = @"1";
            model.identityNo = self.idnumber;
            model.phoneNum = self.telphone;
            /// 新增乘机人，默认选中
            model.isSelected = YES;
            self.returnBlock(model);
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            Toast(model.message);
        }
        kHideMBProgressHUD(self.view);
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
        kHideMBProgressHUD(self.view);;
    }];
}

/// 选择机票查询日期
- (void) showDataPicker{
    NSString *maxDateStr = @"";
    NSString *defaultSelValue = [Utils lz_getNdayDate:0 isShowTime:NO];;
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
    [LZDatePickerView showDatePickerWithTitle:@"" dateType:UIDatePickerModeDate defaultSelValue:defaultSelValue minDateStr:nil maxDateStr:maxDateStr isAutoSelect:NO resultBlock:^(NSString *selectValue) {
        weakSelf.birthday = selectValue;
        NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:4 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPaths,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void) initView{
    [self.view addSubview:self.navigationView];
    [self.navigationView addSubview:self.headerView];
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.headerView addSubview:self.cancelButton];
    [self.headerView addSubview:self.saveButton];
    [self.footerView addSubview:self.footerButton];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = self.footerView;
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(kNavBarHeight));
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.navigationView);
        make.height.equalTo(@(44));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.width.equalTo(@(50));
        make.top.bottom.equalTo(self.headerView);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView.mas_right).offset(-15);
        make.width.top.bottom.equalTo(self.cancelButton);
    }];
    [self.footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.top.equalTo(@(20));
    }];
}

- (void) saveBtnClick:(UIButton *)sender{
    [self saveData];
}

- (void) cancelBtnClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXGeneralModel *model = self.dataArray[indexPath.row];
    if (indexPath.row==0||indexPath.row==2||indexPath.row==4) {
        YKPassengersTableViewCellArrow *tools = [YKPassengersTableViewCellArrow cellWithTableViewCell:tableView forIndexPath:indexPath];
        tools.selectionStyle = UITableViewCellSelectionStyleNone;
        tools.subtitleLabel.text = model.message;
        tools.titleLabel.text = model.title;
        if (indexPath.row==0) {
            NSString *text = @"姓名需与乘机证件一致，否则会影响登机";
            NSString *amountText =  [NSString stringWithFormat:@"%@%@",model.title,text];
            NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:amountText];
            /// 前面文字颜色
            [mutableAttr addAttribute:NSForegroundColorAttributeName value:HexString(@"#D75218") range:NSMakeRange(0, model.title.length)];
            tools.titleLabel.font = kFontSizeRegular12;
            tools.titleLabel.attributedText = mutableAttr;
            tools.imagesArrow.hidden = YES;
        }else if (indexPath.row==4){
            if (self.birthday.length==0) {
                tools.subtitleLabel.text = model.message;
                tools.subtitleLabel.textColor = kTextColor153;
            }else{
                tools.subtitleLabel.text = self.birthday;
                tools.subtitleLabel.textColor = kTextColor102;
            }
        }
        return tools;
    }else{
        YKPassengersTableViewCell *tools = [YKPassengersTableViewCell cellWithTableViewCell:tableView forIndexPath:indexPath];
        tools.selectionStyle = UITableViewCellSelectionStyleNone;
        tools.titleLabel.text = model.title;
        if (indexPath.row==1||indexPath.row==5||indexPath.row==3) {
            tools.textField.placeholder = model.message;
            tools.textField.tag = indexPath.item;
            if (indexPath.row==1) {
                tools.textField.keyboardType = UIKeyboardTypeDefault;
            }else{
                tools.textField.keyboardType = UIKeyboardTypeNumberPad;
            }
            [tools.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            tools.textField.hidden = NO;
        }
        if (indexPath.row==3) {
            tools.textField.ry_inputType = RYIDCardInputType;
//            tools.sc_textField.placeholder = model.message;
//            tools.sc_textField.tag = indexPath.item;
//            [tools.sc_textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
//            tools.sc_textField.hidden = NO;
        }
        return tools;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 40;
    }
    return 50;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

#pragma mark -- Section HearderView Title
// UITableView在Plain类型下，HeaderView和FooterView不悬浮和不停留的方法viewForHeaderInSection
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = kClearColor;
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==4) {
        [self showDataPicker];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/// 对section设置圆角的方法就在此方法中实现即可
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 5.f;
    cell.backgroundColor = UIColor.clearColor;
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = CGRectInset(cell.bounds, 10, 0);
    BOOL addLine = NO;
    if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    } else if (indexPath.row == 0) {
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        addLine = YES;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        CGPathAddRect(pathRef, nil, bounds);
        addLine = YES;
    }
    layer.path = pathRef;
    CFRelease(pathRef);
    //颜色修改
    layer.fillColor = [UIColor colorWithWhite:1.f alpha:1.0f].CGColor; // cell填充颜色
    layer.strokeColor=[UIColor whiteColor].CGColor; // cell边框颜色
    if (addLine == YES) {
        CALayer *lineLayer = [[CALayer alloc] init];
        CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
        lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
        lineLayer.backgroundColor = tableView.separatorColor.CGColor;
        [layer addSublayer:lineLayer];
    }
    UIView *cellBackView = [[UIView alloc] initWithFrame:bounds];
    [cellBackView.layer insertSublayer:layer atIndex:0];
    cellBackView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = cellBackView;
}

#pragma mark ----- getter/setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 25)];
        [_tableView registerClass:[YKPassengersTableViewCell class] forCellReuseIdentifier:[YKPassengersTableViewCell reuseIdentifier]];
        [_tableView registerClass:[YKPassengersTableViewCellArrow class] forCellReuseIdentifier:[YKPassengersTableViewCellArrow reuseIdentifier]];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = kClearColor;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSArray *titleArr = @[@"提醒:",@"姓名",@"证件类型",@"证件号码",@"出生日期",@"境内电话"];
        NSArray *subtitleArr = @[@"",@"与乘机人证件姓名一致",@"身份证",@"与乘机人的证件号码一致",@"请选择出生日期",@"选填,便于接收航变信息"];
        for (int i=0; i<titleArr.count; i++) {
            TXGeneralModel *model = [[TXGeneralModel alloc] init];
            model.title = titleArr[i];
            model.message = subtitleArr[i];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (UIView *)navigationView{
    if (!_navigationView) {
        _navigationView = [UIView lz_viewWithColor:kClearColor];
    }
    return _navigationView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView lz_viewWithColor:kClearColor];
    }
    return _headerView;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = kFontSizeRegular15;
        [_cancelButton setTitleColor:kWhiteColor  forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _cancelButton.tag = 100;
        MV(weakSelf);
        [_cancelButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf cancelBtnClick:self->_cancelButton];
        }];
    }
    return _cancelButton;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kFontSizeRegular15;
        _saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _saveButton.tag = 200;
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf saveBtnClick:self->_saveButton];
        }];
    }
    return _saveButton;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kClearColor];
        _footerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    }
    return _footerView;
}

- (UIButton *)footerButton{
    if (!_footerButton) {
        _footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_footerButton setTitle:@"儿童婴儿购票说明" forState:UIControlStateNormal];
        [_footerButton setImage:kGetImage(@"购票_须知_右箭头") forState:UIControlStateNormal];
        [_footerButton setTitleColor:HexString(@"#E60012") forState:UIControlStateNormal];
        _footerButton.titleLabel.font = kFontSizeRegular13;
        [Utils lz_setButtonTitleWithImageEdgeInsets:_footerButton postition:kMVImagePositionRight spacing:5];
    }
    return _footerButton;
}

- (void)textFieldWithText:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
            self.realname = textField.text;
            break;
        case 3:
            self.idnumber = textField.text;
            break;
        case 5:
            self.telphone = textField.text;
            break;
        default:
            break;
    }
}

@end
