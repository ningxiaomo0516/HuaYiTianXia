//
//  TXRegisteredViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXRegisteredViewController.h"
#import "TXRegisteredTableViewCell.h"
#import "TXRegisterTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXRegisterPasswordViewController.h"

static NSString * const reuseIdentifier = @"TXRegisterTableViewCell";
static NSString * const reuseIdentifiers = @"TXRegisteredTableViewCell";

@interface TXRegisteredViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation TXRegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addGesture:self.tableView];
    [self initView];
}

- (void) initView{
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kWhiteColor;
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    TXRegisterPasswordViewController *vc = [[TXRegisterPasswordViewController alloc] init];
    vc.pageType = self.pageType;
    if (self.pageType==0) {
        vc.title = @"设置密码";
    }else{
        vc.title = @"设置密码2";
    }
    TTPushVC(vc);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TXGeneralModel *model = self.dataArray[indexPath.row];
    if (indexPath.row==0) {
        TXRegisterTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.titleLabel.text = model.title;
        tools.textField.placeholder = model.imageText;
        return tools;
    }else{
        TXRegisteredTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifiers forIndexPath:indexPath];
        TXGeneralModel *model = self.dataArray[indexPath.row];
        tools.titleLabel.text = model.title;
        tools.textField.placeholder = model.imageText;
        return tools;
    }
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
        [_saveButton setTitle:@"下一步" forState:UIControlStateNormal];
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
        
        NSArray* titleArr = @[@"手机号",@"验证码"];
        NSArray* classArr = @[@"请输入手机号码",@"请输入验证码"];
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
