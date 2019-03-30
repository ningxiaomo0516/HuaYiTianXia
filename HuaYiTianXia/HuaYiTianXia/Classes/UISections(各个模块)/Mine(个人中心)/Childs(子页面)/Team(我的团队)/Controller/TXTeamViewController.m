//
//  TXTeamViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXTeamViewController.h"
#import "TXTeamTableViewCell.h"
#import "TXTeamModel.h"

static NSString * const reuseIdentifier = @"TXTeamTableViewCell";

@interface TXTeamViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end


@implementation TXTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self requestPersonalCenterData];
}

- (void) requestPersonalCenterData{
    [SCHttpTools getWithURLString:HttpURL(@"customer/MyTeam") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXTeamModel *model = [TXTeamModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000) {
                [self.dataArray addObjectsFromArray:model.data];
                [self.tableView reloadData];
            }else{
                Toast(model.message);
            }
        }else{
            Toast(@"个人中心数据获取失败");
        }
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
    }];
}

- (void) initView{
    
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXTeamTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.teamModel = self.dataArray[indexPath.section];
    return cell;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(90);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXTeamTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kTableViewInSectionColor;
    }
    return _tableView;
}

//- (SCNoDataView *)noDataView {
//    if (!_noDataView) {
//        _noDataView = [[SCNoDataView alloc] initWithFrame:self.view.bounds
//                                                imageName:@"live_k_yuyue"
//                                            tipsLabelText:@"没有预约的商家哦~"];
//        _noDataView.userInteractionEnabled = YES;
//        [self.view insertSubview:_noDataView aboveSubview:self.tableView];
//        [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_offset(0);
//            make.centerY.mas_equalTo(self.view.mas_centerY);
//            make.height.mas_equalTo(150);
//        }];
//    }
//    return _noDataView;
//}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
