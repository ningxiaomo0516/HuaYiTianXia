//
//  TXRolloutViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXRolloutViewController.h"
#import "TXMineHeaderTableViewCell.h"
#import "TXRolloutTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXRolloutTypeViewController.h"

static NSString * const reuseIdentifier = @"TXRolloutTableViewCell";
static NSString * const reuseIdentifierHeader = @"TXMineHeaderTableViewCell";

@interface TXRolloutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) UIButton *saveButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) UIView *footerView;
/// 货币类型
@property (copy, nonatomic) NSString *currencyText;
/// 收款账户
@property (copy, nonatomic) NSString *accountText;
/// 确认收款账户
@property (copy, nonatomic) NSString *accountsText;
/// 金额
@property (copy, nonatomic) NSString *amountText;

@end

@implementation TXRolloutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];
}

/** 确认转账 */
- (void) saveBtnClick:(UIButton *) sender{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.accountText forKey:@"mobile"];
    [parameter setObject:self.accountsText forKey:@"confirmMobile"];
    [parameter setObject:self.currencyText forKey:@"currency"];
    [parameter setObject:self.amountText forKey:@"money"];
    [SCHttpTools postWithURLString:kHttpURL(@"customer/TurnOut") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTLog(@"result -- %@",result);
            TXNewsArrayModel *model = [TXNewsArrayModel mj_objectWithKeyValues:result];
            [self.dataArray addObjectsFromArray:model.data.records];
        }else{
            Toast(@"获取城市数据失败");
        }
    } failure:^(NSError *error) {
        TTLog(@"error --- %@",error);
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
    if (indexPath.section == 0) {
        TXMineHeaderTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
        return tools;
    } else {
        TXRolloutTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        TXGeneralModel *generalModel = self.dataArray[indexPath.row];
        generalModel.index = indexPath.item;
        tools.titleLabel.text = generalModel.title;
        tools.textField.tag = indexPath.row;
        [tools.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        if (indexPath.row==2) {
            tools.subtitleLabel.text = generalModel.imageText;
            tools.subtitleLabel.hidden = NO;
            tools.imagesArrow.hidden = NO;
            tools.textField.hidden = YES;
        }else{
            tools.textField.placeholder = generalModel.imageText;
            tools.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return tools;
    }
    return [UITableViewCell new];
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/// 返回多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return 1;
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        return IPHONE6_W(55);
    }else {
        return UITableViewAutomaticDimension;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        TXRolloutTypeViewController *vc = [[TXRolloutTypeViewController alloc] init];
        MV(weakSelf)
        vc.typeBlock = ^(NSString * _Nonnull text) {
            weakSelf.currencyText = text;
        };
        CGFloat height = kiPhoneX_T(IPHONE6_W(110));
        [self sc_bottomPresentController:vc presentedHeight:height completeHandle:^(BOOL presented) {
            if (presented) {
                TTLog(@"弹出了");
            }else{
                TTLog(@"消失了");
            }
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldWithText:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
            self.accountText = textField.text;
            break;
        case 1:
            self.accountsText = textField.text;
            break;
        case 3:
            self.amountText = textField.text;
            break;
        default:
            break;
    }
}

#pragma mark ----- getter/setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXRolloutTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXMineHeaderTableViewCell class] forCellReuseIdentifier:reuseIdentifierHeader];
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
        [_saveButton setTitle:@"确认转账" forState:UIControlStateNormal];
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
        NSArray* titleArr = @[@"账号",@"确认账号",@"类型",@"金额"];
        NSArray* subtitleArr = @[@"请输入账号或ID",@"再次输入账号或ID",@"请选择类型",@"请输入转账金额"];
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
