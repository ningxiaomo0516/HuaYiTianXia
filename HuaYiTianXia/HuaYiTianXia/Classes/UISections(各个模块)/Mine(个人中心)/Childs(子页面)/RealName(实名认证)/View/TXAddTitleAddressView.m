//
//  TXAddTitleAddressView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/10.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXAddTitleAddressView.h"
#import "TXAddressModel.h"
@interface TXAddTitleAddressView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIScrollView *titleScrollView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
/// 默认为第一个数据 1
@property(nonatomic,assign)NSInteger idx;
@property(nonatomic,copy)NSString *selectValue;
@property(nonatomic,copy)NSString *selectID;
@end

@implementation TXAddTitleAddressView


- (UIView *)initAddressView{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtnAndcancelBtnClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //设置添加地址的View
    self.addAddressView = [[UIView alloc] init];
    self.addAddressView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, _defaultHeight);
    self.addAddressView.backgroundColor = kWhiteColor;
    [self addSubview:self.addAddressView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, kScreenWidth - 80, 30)];
    titleLabel.text = _title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self.addAddressView addSubview:titleLabel];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame =CGRectMake(CGRectGetMaxX(self.addAddressView.frame) - 40, 10, 30, 30);
    cancelBtn.tag = 1;
    [cancelBtn setImage:kGetImage(@"c31_btn_close") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(tapBtnAndcancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.addAddressView addSubview:cancelBtn];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, 0.5)];
    lineView.backgroundColor = kLinerViewColor;
    [self.addAddressView addSubview:(lineView)];
    
    [self.addAddressView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.addAddressView);
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(self.addAddressView.mas_bottom).offset(-kNavBarHeight);
    }];
    return self;
}

- (void)addAnimate{
    self.hidden = NO;
    self.idx = 1;
    self.selectValue = @"";
    [UIView animateWithDuration:0.25 animations:^{
        self.addAddressView.frame = CGRectMake(0, kScreenHeight - self.defaultHeight, kScreenWidth, self.defaultHeight);
    }];
    [self getCityData:0];
}

- (void)tapBtnAndcancelBtnClick{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.addAddressView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

/// 去掉弹窗保留蒙版的手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass(touch.view.classForCoder) isEqualToString: @"UITableViewCellContentView"] || touch.view == self.addAddressView || touch.view == self.titleScrollView) {
        return NO;
    }
    return YES;
}

#pragma mark ------ 地址列表 ------
#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * AddressAdministerCellIdentifier = @"AddressAdministerCellIdentifier";
    UITableViewCell *tools = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:AddressAdministerCellIdentifier];
    if (!tools) {
        tools = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddressAdministerCellIdentifier];
    }
    TXCityModel *model = self.dataArray[indexPath.row];
    tools.textLabel.text = model.areaName;
    return tools;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    TXCityModel *model = self.dataArray[indexPath.row];
    self.selectValue = [self.selectValue stringByAppendingFormat:@" %@",model.areaName];
    self.selectID = model.kid;
    if (self.idx>=3) {
        [self tapBtnAndcancelBtnClick];
        self.selectBlock(self.selectValue, self.selectID);
    }else{
        self.idx += 1;
        [self getCityData:model.kid.integerValue];
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
        _tableView.backgroundColor = kWhiteColor;
        [Utils lz_setExtraCellLineHidden:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark ------ 获取接口地址 ------
- (void) getCityData:(NSInteger)parentId{
    kShowMBProgressHUD(self);
//    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [SCHttpTools getWithURLString:@"city/getList" parameter:@{@"parentId":@(parentId)} success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXCityData *model = [TXCityData mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                if (model.list.count == 0) {
                    [self tapBtnAndcancelBtnClick];
                    self.selectBlock(self.selectValue, self.selectID);
                }
                self.dataArray = model.list;
            }else{
                Toast(@"获取数据失败");
            }
        }
        [self.tableView reloadData];
        kHideMBProgressHUD(self);
    } failure:^(NSError *error) {
        kHideMBProgressHUD(self);
    }];
}
@end
