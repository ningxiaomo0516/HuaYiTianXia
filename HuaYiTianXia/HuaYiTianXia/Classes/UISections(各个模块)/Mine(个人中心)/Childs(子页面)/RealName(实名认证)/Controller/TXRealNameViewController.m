//
//  TXRealNameViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXRealNameViewController.h"
#import "TXLoginViewController.h"
#import "SCImagePicker.h"

@interface TXRealNameViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;

/// 姓名
@property (strong, nonatomic) IBOutlet UITableViewCell *nickNameCell;
/// 性别
@property (strong, nonatomic) IBOutlet UITableViewCell *sexCell;
/// 身份证号
@property (strong, nonatomic) IBOutlet UITableViewCell *idnumberCell;
/// 联系方式
@property (strong, nonatomic) IBOutlet UITableViewCell *telCell;
/// 身份证照片
@property (strong, nonatomic) IBOutlet UITableViewCell *idcardCell;

@property (strong, nonatomic) IBOutlet UILabel *idnumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *sexLabel;
@property (strong, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *idnumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *telTextField;

//  图片1
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
//  添加按钮1
@property (weak, nonatomic) IBOutlet UIButton *addButton1;
//  图片2
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
//  添加按钮2
@property (weak, nonatomic) IBOutlet UIButton *addButton2;
//  *身份证正面照
@property (weak, nonatomic) IBOutlet UILabel *idcardLabel1;
//  *身份证反面照
@property (weak, nonatomic) IBOutlet UILabel *idcardLabel2;
@property (nonatomic, strong) SCImagePicker *imagePicker;

//  图片1地址
@property (copy, nonatomic) NSString *imageText1;
//  图片2地址
@property (copy, nonatomic) NSString *imageText2;
//  图片2地址
@property (assign, nonatomic) NSInteger sex;
@end

@implementation TXRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    MV(weakSelf)
    if (self.typePage==0) {
        [self.addButton1 lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf chooseCameraBtnClick:self.addButton1];
        }];
        [self.addButton2 lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf chooseCameraBtnClick:self.addButton2];
        }];
    }else{
        self.addButton1.hidden = YES;
        self.addButton2.hidden = YES;
        self.nickNameTextField.enabled = NO;
        self.idnumberTextField.enabled = NO;
        self.saveButton.hidden = YES;
        [self requestRealNameData];
    }
}

- (void) requestRealNameData{
    [SCHttpTools getWithURLString:kHttpURL(@"customer/UserData") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTUserDataModel *model = [TTUserDataModel mj_objectWithKeyValues:result];
            TTUserModel *userModel = model.data;
            if (model.errorcode == 20000) {
                self.nickNameTextField.text = userModel.username;
                if (userModel.idnumber.length<15) {
                    self.idnumberTextField.text = @"未填写";
                }else{
                    self.idnumberTextField.text = [SCSmallTools idCardNumber:userModel.idnumber];
                }
                self.sexLabel.text = (userModel.sex==0)?@"男":@"女";
                [self.imageView1 sd_setImageWithURL:kGetImageURL(userModel.imgz) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
                [self.imageView2 sd_setImageWithURL:kGetImageURL(userModel.imgb) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
                [self.tableView reloadData];
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"认证数据获取失败");
        }
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
    }];
}

- (void) initView{
    [self addGesture:self.tableView];
    // 隐藏多余分割线
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
    /// 设置身份证照片提示的富文本
    self.idcardLabel1.attributedText = [SCSmallTools setupTextColor:HexString(@"#FA7C7C") currentText:self.idcardLabel1.text index:0 endIndex:1];
    self.idcardLabel2.attributedText = [SCSmallTools setupTextColor:HexString(@"#FA7C7C") currentText:self.idcardLabel2.text index:0 endIndex:1];
    
    self.addButton1.tag = 100;
    self.addButton2.tag = 200;
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    [self inspectionIntegrity];
}

/// 检查是否输入完整了
- (void) inspectionIntegrity{
    NSString *username = self.nickNameTextField.text;
    NSString *idnumber = self.idnumberTextField.text;
    NSString *telphone = self.telTextField.text;
    
    if (username.length == 0) {
        Toast(@"请输入真实姓名");
        return;
    }
    
    if ([self.sexLabel.text isEqualToString:@"请选择"]) {
        Toast(@"请选择性别");
        return;
    }
    
    if (idnumber.length == 0) {
        Toast(@"清输入身份证号");
        return;
    }
    
    if (![SCSmallTools tt_simpleVerifyIdentityCardNum:idnumber]) {
        Toast(@"请输入正确的身份证号码");
        return;
    }
    
    if (telphone.length == 0) {
        Toast(@"请输入电话号码");
        return;
    }
    
    if (![SCSmallTools checkTelNumber:telphone]) {
        Toast(@"请输入正确的电话号码");
        return;
    }
    
    if (self.imageText1.length<=0) {
        Toast(@"请上传身份证正面照");
        return;
    }
    
    if (self.imageText2.length<=0) {
        Toast(@"请上传身份证反面照");
        return;
    }
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:username forKey:@"name"];
    [parameter setObject:idnumber forKey:@"code"];
    [parameter setObject:telphone forKey:@"phone"];
    [parameter setObject:@(self.sex) forKey:@"sex"];
    [parameter setObject:self.imageText1 forKey:@"imgz"];
    [parameter setObject:self.imageText2 forKey:@"imgb"];
    [self saveRealNameData:parameter];
}

//// 保存实名认证数据
- (void) saveRealNameData:(NSDictionary *)parameter{
    [SCHttpTools postWithURLString:kHttpURL(@"customer/Certification") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTUserDataModel *model = [TTUserDataModel mj_objectWithKeyValues:result];
            TTUserModel *userModel = model.data;
            if (model.errorcode == 20000) {
                self.nickNameTextField.text = userModel.username;
                if (userModel.idnumber.length>14) {
                    self.idnumberTextField.text = [SCSmallTools idCardNumber:userModel.idnumber];
                }
                self.sexLabel.text = (userModel.sex==0)?@"男":@"女";
                [self.imageView1 sd_setImageWithURL:kGetImageURL(userModel.imgz) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
                [self.imageView2 sd_setImageWithURL:kGetImageURL(userModel.imgb) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
                [self.tableView reloadData];
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"认证数据获取失败");
        }
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
    }];
}

/// 选择身份证照片
- (void) chooseCameraBtnClick:(UIButton *)sender{
    [self imageURLReload:sender];
}

/// 更新x上传的图片地址
- (void) imageURLReload:(UIButton *)sender{
    MV(weakSelf)
    [self.imagePicker sc_pickWithTarget:self completionHandler:^(UIImage *image, NSString *imageURL) {
        TTLog(@"image -- %@",image);
        sender.backgroundColor = kClearColor;
        [sender setImage:[UIImage lz_imageWithColor:kClearColor] forState:UIControlStateNormal];
        if (sender.tag==100) {
            weakSelf.imageText1 = imageURL;
            [weakSelf.imageView1 sd_setImageWithURL:kGetImageURL(imageURL) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
        }else if (sender.tag==200){
            weakSelf.imageText2 = imageURL;
            [weakSelf.imageView2 sd_setImageWithURL:kGetImageURL(imageURL) placeholderImage:kGetImage(VERTICALMAPBITMAP)];
        }
        [weakSelf.tableView reloadData];
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
    if (buttonIndex!=2) {
        self.sex = buttonIndex;
    }
    if (buttonIndex==0) {
        self.sexLabel.text = @"男";
    }else if(buttonIndex==1){
        self.sexLabel.text = @"女";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSUInteger row = [indexPath row];
    static NSString *CellIdentifier = @"TXRealNameViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (row == 0) {
        _nickNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _nickNameCell;
    }
    if (row == 1) {
        return _sexCell;
    }
    if (row == 2) {
        _idnumberCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _idnumberCell;
    }
    if (self.typePage==0) {
        if (row == 3) {
            _telCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _telCell;
        }
        if (row == 4) {
            _idcardCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _idcardCell;
        }
    }else{
        if (row == 3) {
            _idcardCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _idcardCell;
        }
    }
    
    return cell;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.typePage==0) return 5;
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.typePage==0) {
        if (indexPath.row==4) return IPHONE6_W(160);
    }else{
        if (indexPath.row==3) return IPHONE6_W(160);
    }
    
    return IPHONE6_W(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1&&self.typePage==0) {
        [self showSexActionSheet:@[@"女",@"男"]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
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

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kFontSizeMedium15;
        [_saveButton setTitle:@"提交" forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:kGetImage(@"c31_denglu") forState:UIControlStateNormal];
        MV(weakSelf);
        [_saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf saveBtnClick:self.saveButton];
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

- (SCImagePicker *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[SCImagePicker alloc] init];
        _imagePicker.isEditor = YES;
    }
    return _imagePicker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
