//
//  TXAddressAddViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXAddressAddViewController.h"
#import "TXRolloutTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXAddressTextViewCell.h"
#import "TXSwitchTableViewCell.h"

#import "TTPickerView.h"
#import "TTPickerModel.h"

static NSString * const reuseIdentifier = @"TXRolloutTableViewCell";
static NSString * const reuseIdentifierTextView = @"TXAddressTextViewCell";
static NSString * const reuseIdentifierSwitch = @"TXSwitchTableViewCell";

@interface TXAddressAddViewController ()<UITableViewDelegate,UITableViewDataSource,TTPickerViewDelegate,UITextViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) TTPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *pro;
/// 省市县
@property (nonatomic, strong) NSString *citytext;
/// 收货人
@property (nonatomic, strong) NSString *username;
/// 电话
@property (nonatomic, strong) NSString *telphone;
/// 详细地址
@property (nonatomic, strong) NSString *address;
/// 是否为默认地址（0:否 1:默认）
@property (nonatomic, strong) NSString *isDefault;
@end


@implementation TXAddressAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.citytext = @"";
    self.username = @"";
    self.telphone = @"";
    self.address = @"";
    self.isDefault = @"0";
    [self addGesture:self.tableView];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"addr" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions|NSJSONWritingPrettyPrinted error:nil] mutableCopy];
    MV(weakSelf)
    [jsonArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.pro addObject:[TTPickerModel mj_objectWithKeyValues:obj]];
    }];
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    
    if (self.username.length==0) {
        Toast(@"请输入收货人姓名");
        return;
    }
    
    if (self.telphone.length == 0) {
        Toast(@"请输入电话号码");
        return;
    }
    
    if (![SCSmallTools checkTelNumber:self.telphone]) {
        Toast(@"请输入正确的电话号码");
        return;
    }
    
    if (self.citytext.length == 0) {
        Toast(@"请选择所在城市");
        return;
    }
    
    if (self.address.length==0) {
        Toast(@"请输入详细地址");
        return;
    }
    [self saveAddressRequest];
}

/// 保存收货地址
- (void) saveAddressRequest{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *addressText = kStringFormat(self.citytext, self.address);
    [parameter setObject:self.username forKey:@"userName"];
    [parameter setObject:self.telphone forKey:@"phot"];
    [parameter setObject:addressText forKey:@"adder"];
    [parameter setObject:self.isDefault forKey:@"status"];
    [SCHttpTools postWithURLString:kHttpURL(@"address/AddAddress") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                Toast(@"添加成功");
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                Toast(@"添加失败");
            }
        }
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
    }];
}

- (void)tt_pickerView:(TTPickerView *)pickerView completeArray:(NSMutableArray<TTPickerModel *> *)comArray completeStr:(NSString *)comStr{
    TTLog(@"comStr --- %@",comStr);
    self.citytext = comStr;
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
    
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = self.footerView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];[self.footerView addSubview:self.saveButton];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(30));
        make.left.equalTo(@(15));
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@(45));
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXGeneralModel* model = self.dataArray[indexPath.section][indexPath.row];
    model.index = indexPath.item;
    if (indexPath.section==0 && indexPath.row==3) {
        TXAddressTextViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTextView forIndexPath:indexPath];
        tools.titleLabel.text = model.title;
        tools.textView.delegate = self;
        return tools;
    }else if(indexPath.section==1){
        TXSwitchTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSwitch forIndexPath:indexPath];
        tools.titleLabel.text = model.title;
        [tools.isSwitch addTarget:self action:@selector(valueSwitchChanged:) forControlEvents:(UIControlEventValueChanged)];
        return tools;
    }else{
        TXRolloutTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.titleLabel.text = model.title;
        tools.textField.tag = indexPath.item;
        [tools.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        if (indexPath.row==2) {
            tools.subtitleLabel.text = model.imageText;
            tools.subtitleLabel.hidden = NO;
            tools.subtitleLabel.text = self.citytext;
            tools.subtitleLabel.textColor = kTextColor102;
            tools.imagesArrow.hidden = NO;
            tools.textField.hidden = YES;
        }else if(indexPath.section==2){
            tools.titleLabel.textColor = HexString(@"#E74949");
            tools.textField.enabled = NO;
        }else if(indexPath.section==0){
            tools.textField.placeholder = model.imageText;
            tools.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row==0) {
                tools.textField.keyboardType = UIKeyboardTypeDefault;
            }
        }
        return tools;
    }
    return [UITableViewCell new];
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.currentType==AddInfo) {
        return self.dataArray.count-1;
    }else{
        return self.dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subArray = [self.dataArray lz_safeObjectAtIndex:section];
    return subArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0&&indexPath.row==3) {
        return IPHONE6_W(80);
    }
    return IPHONE6_W(55);
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        [self click2One];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldWithText:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
            self.username = textField.text;
            break;
        case 1:
            self.telphone = textField.text;
            break;
        default:
            break;
    }
}

- (void) valueSwitchChanged:(UISwitch *) isSwitch{
    if (isSwitch.on) {
        self.isDefault = @"1";
    }else{
        self.isDefault = @"0";
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (!textView.markedTextRange) {
        self.address = textView.text;
    }
}


#pragma mark ------ setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXRolloutTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXAddressTextViewCell class] forCellReuseIdentifier:reuseIdentifierTextView];
        [_tableView registerClass:[TXSwitchTableViewCell class] forCellReuseIdentifier:reuseIdentifierSwitch];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kTableViewInSectionColor;
    }
    return _tableView;
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
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:kGetImage(@"c31_denglu") forState:UIControlStateNormal];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf saveBtnClick:self.saveButton];
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

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
        NSArray* titleArr = @[@[@"收货人",@"手机号码",@"所在地区",@"详细地址"],
                              @[@"设为默认地址"],
                              @[@"删除收货地址"]];
        NSArray* subtitleArr = @[@[@"请输入收货人姓名",@"请填写收货手机号码",@"",@""],@[],@[]];
        for (int i=0; i<titleArr.count; i++) {
            NSArray *titlesArray = [titleArr lz_safeObjectAtIndex:i];
            NSArray *subtitleArray = [subtitleArr lz_safeObjectAtIndex:i];
            NSMutableArray *subArray = [NSMutableArray array];
            for (int j = 0; j < titlesArray.count; j ++) {
                TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
                generalModel.title = [titlesArray lz_safeObjectAtIndex:j];
                generalModel.imageText = [subtitleArray lz_safeObjectAtIndex:j];
                [subArray addObject:generalModel];
            }
            [_dataArray addObject:subArray];
        }
    }
    return _dataArray;
}

@end
