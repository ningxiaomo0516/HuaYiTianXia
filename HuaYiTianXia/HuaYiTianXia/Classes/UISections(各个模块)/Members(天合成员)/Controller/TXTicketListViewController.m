//
//  TXTicketListViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXTicketListViewController.h"
#import "TXTicketModel.h"
#import "TXTicketListTableViewCell.h"

static NSString* reuseIdentifier = @"TXTicketListTableViewCell";

@interface TXTicketListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *parameter;
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation TXTicketListViewController
- (id)initTicketListWithURLString:URLString parameter:(NSMutableDictionary *)parameter{
    if ( self = [super init] ){
        self.parameter = parameter;
        self.URLString = URLString;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查询详情";
    [self.view showLoadingViewWithText:@"加载中..."];
    [self initView];
}

- (void) GetTicketDataRequest{
    [SCHttpTools getTicketWithURLString:self.URLString parameter:self.parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
            TXTicketModel *model = [TXTicketModel mj_objectWithKeyValues:result];
            if (model.errorcode==0) {
                /// 查询列表
                
            }else{
                Toast(model.message);
            }
        }
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        TTLog(@"机票查询信息 -- %@", error);
        [self.view dismissLoadingView];
    }];
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
}


#pragma mark ---- 约束布局
- (void) initViewConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kTabBarHeight);
    }];
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.bannerArray.count>0&&indexPath.section==0) {
//        TXMallGoodsBannerTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierBanner forIndexPath:indexPath];
//        tools.bannerArray = self.bannerArray;
//        return tools;
//    }else{
//        TXNewTemplateTableViewCell  *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
//        tools.recordsModel = self.dataArray[indexPath.row];
//        return tools;
//    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return IPHONE6_W(90);
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
//
//#pragma mark -------------- 设置Header高度 --------------
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section!=0) {
//        return 0.0f;
//    }
//    return 10.0f;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----- getter/setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        [_tableView registerClass:[TXTicketListTableViewCell class] forHeaderFooterViewReuseIdentifier:reuseIdentifier];
        //1 禁用系统自带的分割线
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
