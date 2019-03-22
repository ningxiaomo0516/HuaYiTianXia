//
//  TXAddressAddViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXAddressAddViewController.h"
#import "TXRolloutTableViewCell.h"
#import "TXPersonModel.h"
#import "TXAddressTextViewCell.h"
#import "TXSwitchTableViewCell.h"

static NSString * const reuseIdentifier = @"TXRolloutTableViewCell";
static NSString * const reuseIdentifierTextView = @"TXAddressTextViewCell";
static NSString * const reuseIdentifierSwitch = @"TXSwitchTableViewCell";

@interface TXAddressAddViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (strong, nonatomic) UIButton *saveButton;
@property (strong, nonatomic) UIView *footerView;
@end


@implementation TXAddressAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

/** 保存 */
- (void) saveBtnClick:(UIButton *) sender{
    
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
    TXPersonModel* model = self.dataArray[indexPath.section][indexPath.row];
    model.index = indexPath.item;
    if (indexPath.section==0 && indexPath.row==3) {
        TXAddressTextViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTextView forIndexPath:indexPath];
        tools.titleLabel.text = model.title;
        return tools;
    }else if(indexPath.section==1){
        TXSwitchTableViewCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSwitch forIndexPath:indexPath];
        tools.titleLabel.text = model.title;
        return tools;
    }else{
        TXRolloutTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        tools.titleLabel.text = model.title;
        if (indexPath.row==2) {
            tools.subtitleLabel.text = model.imageText;
            tools.subtitleLabel.hidden = NO;
            tools.imagesArrow.hidden = NO;
            tools.textField.hidden = YES;
        }else if(indexPath.section==2){
            tools.titleLabel.textColor = HexString(@"#E74949");
            tools.textField.enabled = NO;
        }else if(indexPath.section==0){
            tools.textField.placeholder = model.imageText;
            tools.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
        NSArray* titleArr = @[@[@"收货人",@"手机号码",@"所在地区",@"详细地址"],
                              @[@"设为默认地址"],
                              @[@"删除收货地址"]];
        NSArray* subtitleArr = @[@[@"请输入收件人姓名",@"请填写收货手机号码",@"",@""],@[],@[]];
        for (int i=0; i<titleArr.count; i++) {
            NSArray *titlesArray = [titleArr lz_safeObjectAtIndex:i];
            NSArray *subtitleArray = [subtitleArr lz_safeObjectAtIndex:i];
            NSMutableArray *subArray = [NSMutableArray array];
            for (int j = 0; j < titlesArray.count; j ++) {
                TXPersonModel* personModel = [[TXPersonModel alloc] init];
                personModel.title = [titlesArray lz_safeObjectAtIndex:j];
                personModel.imageText = [subtitleArray lz_safeObjectAtIndex:j];
                [subArray addObject:personModel];
            }
            [_dataArray addObject:subArray];
        }
    }
    return _dataArray;
}

@end
