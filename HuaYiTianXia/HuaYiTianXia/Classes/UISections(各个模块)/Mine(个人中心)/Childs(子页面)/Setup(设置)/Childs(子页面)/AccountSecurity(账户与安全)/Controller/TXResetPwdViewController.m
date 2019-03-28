//
//  TXResetPwdViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXResetPwdViewController.h"
#import "TXRolloutTableViewCell.h"
#import "TXGeneralModel.h"

static NSString * const reuseIdentifier = @"TXRolloutTableViewCell";

@interface TXResetPwdViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIView *footerView;

@end

@implementation TXResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    
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

    TXRolloutTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    TXGeneralModel* model = self.dataArray[indexPath.row];
    model.index = indexPath.item;
    tools.titleLabel.text = model.title;
    tools.textField.placeholder = model.imageText;
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
    return tools;
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

#pragma mark ----- getter/setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXRolloutTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
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
        [_saveButton setTitle:@"完成" forState:UIControlStateNormal];
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
        NSArray* titleArr = @[@"旧密码",@"新密码",@"确认密码"];
        NSArray* subtitleArr = @[@"请输入登录旧密码",@"请输入登录新密码",@"请再次输入新密码"];
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
