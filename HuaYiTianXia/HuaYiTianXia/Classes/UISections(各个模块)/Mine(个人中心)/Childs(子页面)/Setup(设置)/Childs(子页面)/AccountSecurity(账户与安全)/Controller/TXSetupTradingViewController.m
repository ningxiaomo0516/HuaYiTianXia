//
//  TXSetupTradingViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/4.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXSetupTradingViewController.h"
#import "TXResetTradingViewController.h"

@interface TXSetupTradingViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) IBOutlet UITableViewCell *realnameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *idnumberCell;

@property (strong, nonatomic) IBOutlet UITextField *realnameTextField;
@property (strong, nonatomic) IBOutlet UITextField *idnumberTextField;

@end

@implementation TXSetupTradingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"身份校验";
    [self initView];
}

/** 身份校验过程 */
- (void) saveBtnClick:(UIButton *) sender{
    NSString *realname = self.realnameTextField.text;
    NSString *idnumber = self.idnumberTextField.text;
    if (realname.length==0) {
        Toast(@"请输入真实姓名");
    }
    
    if (idnumber.length==0) {
        Toast(@"请输入身份证号");
        return;
    }
    
    if (![SCSmallTools tt_simpleVerifyIdentityCardNum:idnumber]) {
        Toast(@"请输入正确的身份证号码");
        return;
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:realname forKey:@"name"];
    [parameter setObject:idnumber forKey:@"code"];
    [self validationIdentityInfo:parameter];
}

- (void) validationIdentityInfo:(NSMutableDictionary *)parameter{
    kShowMBProgressHUD(self.view);
    [SCHttpTools postWithURLString:kHttpURL(@"customer/VerifTranPwd") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                Toast(@"身份验证成功");
                TXResetTradingViewController *vc = [[TXResetTradingViewController alloc] init];
                vc.pageType = 0;
                TTPushVC(vc);
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"身份验证失败");
        }
        kHideMBProgressHUD(self.view);
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        kHideMBProgressHUD(self.view);;
    }];
}

- (void) initView{
    [self addGesture:self.tableView];
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    
    [self.footerView addSubview:self.saveButton];
    
    self.tableView.tableFooterView = self.footerView;
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
    
    NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"TXRealNameViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (row == 0) {
        _realnameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _realnameCell;
    }
    if (row == 1) {
        _idnumberCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _idnumberCell;
    }
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag==1) {
        if (range.location + string.length > 18) {
            return NO;
        }
    }
    return YES;
}

#pragma mark ---- UITextFieldDelegate
/// 控制键盘是否回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

#pragma mark ----- getter/setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
        _tableView.rowHeight = UITableViewAutomaticDimension;
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
        [_saveButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:kGetImage(@"c31_denglu") forState:UIControlStateNormal];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf saveBtnClick:self.saveButton];
        }];
    }
    return _saveButton;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        NSArray* titleArr = @[@"真实姓名",@"身份证号"];
        NSArray* subtitleArr = @[@"请输入身份证姓名",@"请输入身份证号"];
        for (int i=0; i<titleArr.count; i++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:i];
            generalModel.imageText = [subtitleArr lz_safeObjectAtIndex:i];
            [_dataArray addObject:generalModel];
        }
    }
    return _dataArray;
}

@end
