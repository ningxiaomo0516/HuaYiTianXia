//
//  TXRealNameViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXRealNameViewController.h"

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


@end

@implementation TXRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    
    NSString *current = self.idnumberLabel.text;
    /// 修改身份证号提示文字颜色
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:current];
    /// 后面文字颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:HexString(@"#FA7C7C")
                          range:NSMakeRange(4, current.length-4)];
    // 后面文字大小
    [attributedStr addAttribute:NSFontAttributeName
                          value:kFontSizeMedium12
                          range:NSMakeRange(4, current.length-4)];
    self.idnumberLabel.attributedText = attributedStr;

    self.idcardLabel1.attributedText = [self setupTextColor:self.idcardLabel1.text];
    self.idcardLabel2.attributedText = [self setupTextColor:self.idcardLabel2.text];
}

- (NSMutableAttributedString *) setupTextColor:(NSString *)currentText{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:currentText];
    /// 后面文字颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                           value:HexString(@"#FA7C7C")
                           range:NSMakeRange(0, 1)];
    return attributedStr;
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{

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
        _sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _sexCell;
    }
    if (row == 2) {
        _idnumberCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _idnumberCell;
    }
    if (row == 3) {
        _idcardCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _idcardCell;
    }
    return cell;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==3) {
        return IPHONE6_W(160);
    }
    return IPHONE6_W(50);
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
