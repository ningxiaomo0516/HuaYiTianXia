//
//  TXRegisterPasswordViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXRegisterPasswordViewController.h"
#import "TXRegisteredTableViewCell.h"
#import "TXRegisterTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXRegisterPasswordViewController.h"

static NSString * const reuseIdentifier = @"TXRegisterTableViewCell";
static NSString * const reuseIdentifiers = @"TXRegisteredTableViewCell";

@interface TXRegisterPasswordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation TXRegisterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addGesture:self.tableView];
    [self initView];
}

- (void) initView{
    [self.view addSubview:self.tableView];
    NSInteger count = self.lz_navigationController.lz_viewControllers.count;
    TTLog(@"count = %ld",count);
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kWhiteColor;
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    if (self.pageType==0) {
        Toast(@"注册完成");
    }else{
        Toast(@"修改密码完成");
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TXGeneralModel *model = self.dataArray[indexPath.row];
    TXRegisterTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.titleLabel.text = model.title;
    tools.textField.placeholder = model.imageText;
    return tools;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.pageType==0)?self.dataArray.count:2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return IPHONE6_W(55);
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TXRegisterTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXRegisteredTableViewCell class] forCellReuseIdentifier:reuseIdentifiers];
        // 拖动tableView时收起键盘
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kClearColor;
    }
    return _tableView;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = kFontSizeMedium15;
        [_saveButton setTitle:@"完成" forState:UIControlStateNormal];
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

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
        NSArray* titleArr = @[@"密码",@"确认密码",@"邀请码"];
        NSArray* classArr = @[@"请输入登录密码",@"请再次输入密码",@"邀请码（选填）"];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:j];
            generalModel.imageText = [classArr lz_safeObjectAtIndex:j];
            [_dataArray addObject:generalModel];
        }
    }
    return _dataArray;
}
@end
