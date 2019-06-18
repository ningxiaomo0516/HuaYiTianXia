//
//  TXLogisticViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/14.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXLogisticViewController.h"
#import "TXLogisticTableViewCell.h"
#import "TXLogisticProductCell.h"

static NSString * const reuseIdentifier = @"TXLogisticTableViewCell";
static NSString * const reuseIdentifierProduct = @"TXLogisticProductCell";

@interface TXLogisticViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation TXLogisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = @"物流跟踪";
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.left.right.equalTo(self.view);
    }];
}

- (void) get_data{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@"" forKey:@"orderNo"];
    [parameter setObject:@"" forKey:@"abbreviation"];
    [parameter setObject:@"" forKey:@"logisticsNo"];
    [SCHttpTools postWithURLString:kHttpURL(@"expresscompany/queryExpressInfo") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TXLogisticProductCell *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierProduct forIndexPath:indexPath];
        return tools;
    }else{
        TXLogisticTableViewCell  *tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        if (indexPath.row==0) {
            tools.imagesView.image = kGetImage(@"签收");
            tools.date_label.text = @"06-11";
            tools.time_label.text = @"05:16";
            tools.title_label.text = @"已签收";
            tools.subtitle_label.text = @"签收人凭提货码签收";
        }else{
            tools.imagesView.image = kGetImage(@"派送");
            tools.date_label.text = @"06-11";
            tools.time_label.text = @"05:16";
            tools.title_label.text = @"已签收";
            tools.subtitle_label.text = @"【成都市】成都市高新区便民服务服务部派件员小何：电话12354565446正在为您派件";
        }
        
        return tools;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) return IPHONE6_W(160);
    return UITableViewAutomaticDimension;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----- getter/setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        [_tableView registerClass:[TXLogisticTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView registerClass:[TXLogisticProductCell class] forCellReuseIdentifier:reuseIdentifierProduct];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 200;
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
