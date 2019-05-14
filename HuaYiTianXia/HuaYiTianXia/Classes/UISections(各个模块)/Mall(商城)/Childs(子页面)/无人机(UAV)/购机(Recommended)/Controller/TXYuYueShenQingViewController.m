//
//  TXYuYueShenQingViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXYuYueShenQingViewController.h"
#import "TXAddTitleAddressView.h"

@interface TXYuYueShenQingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *nicknameCell;   // 昵称Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *cityCell;       // 所在区域Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *telCell;        // 联系电话Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *addressCell;    // 详细地址Cell
@property (strong, nonatomic) IBOutlet UITableViewCell *dateCell;       // 日期Cell
@property (strong, nonatomic) IBOutlet UIView *footerView;              // 按钮View


@property (strong, nonatomic) IBOutlet UITextField  *nicknameTextField; // 昵称
@property (strong, nonatomic) IBOutlet UILabel      *cityLabel;         // 所在区域
@property (strong, nonatomic) IBOutlet UITextField  *telTextField;      // 联系电话
@property (strong, nonatomic) IBOutlet SCTextView   *textView;          // 详细地址
@property (strong, nonatomic) IBOutlet UILabel      *dateLabel;         // 日期
@property (strong, nonatomic) IBOutlet UIButton     *saveButton;        // 按钮
@property (strong, nonatomic) TXAddTitleAddressView *addTitleAddressView;
@end

@implementation TXYuYueShenQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    self.title = @"预约申请";
    MV(weakSelf)
    [self.saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//        [weakSelf chooseCameraBtnClick:self.addButton1];
    }];
}

- (void) initView{
    [_addressCell.contentView addSubview:self.textView];
    [self addGesture:self.tableView];
    // 隐藏多余分割线
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = _footerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    MV(weakSelf)
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(100)));
        make.right.equalTo(weakSelf.addressCell.mas_right).offset(-20);
        make.top.bottom.equalTo(@(0));
    }];
    
    self.addTitleAddressView = [[TXAddTitleAddressView alloc]init];
    self.addTitleAddressView.title = @"选择地址";
    self.addTitleAddressView.defaultHeight = kScreenHeight-kScreenHeight/3;
    self.addTitleAddressView.titleScrollViewH = 37;
    [self.view addSubview:[self.addTitleAddressView initAddressView]];
    //// 选择城市后的block
    self.addTitleAddressView.selectBlock = ^(NSString * _Nonnull areaText, NSString * _Nonnull parentId) {
        weakSelf.cityLabel.text = areaText;
//        weakSelf.parentId = parentId;
        TTLog( @"%@", [NSString stringWithFormat:@"打印的对应省市县的id=%@",parentId]);
        [weakSelf.tableView reloadData];
    };
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    [self inspectionIntegrity];
}

/// 检查是否输入完整了
- (void) inspectionIntegrity{
//    NSString *username = self.nicknameTextField.text;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if (row == 0) return _nicknameCell;
    if (row == 1) return _telCell;
    if (row == 2) return _dateCell;
    if (row == 3) return _cityCell;
    if (row == 4) return _addressCell;
    return [UITableViewCell new];
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==4) return IPHONE6_W(100);
    return IPHONE6_W(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        Toast(@"选择日期");
    } else if (indexPath.row==3) {
        [self.addTitleAddressView addAnimate];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
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

- (SCTextView *)textView{
    if (!_textView) {
        _textView = [[SCTextView alloc] init];
        _textView.font = kFontSizeMedium15;
        _textView.textColor = kTextColor102;
        _textView.placeholder = @"街道、楼牌号等";
    }
    return _textView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
