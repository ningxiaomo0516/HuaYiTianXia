//
//  YKTicketOrderChildViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/10.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKTicketOrderChildViewController.h"
#import "YXTicketOrderChildTableViewCell.h"
#import "YKTicketBookingHeaderView.h"
#import "TXPassengersTableViewCell.h"

@interface YKTicketOrderChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) YKTicketBookingHeaderView *headerView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *status_label;
@property (nonatomic, strong) UILabel *order_label;
@property (nonatomic, strong) UILabel *price_label;
@property (nonatomic, strong) TicketListModel *ticketModel;

@end

@implementation YKTicketOrderChildViewController
- (id)initTicketOrderModel:(TicketListModel *)ticketModel{
    if ( self = [super init] ){
        self.ticketModel = ticketModel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.contents = (id)kGetImage(@"trip_box_view").CGImage;
    [self initView];
    [self requestTicketOrderData];
}

- (void) setupViewData:(TicketOrderDataChildModel *)model{
    NSArray *depTimeArray = [model.segment.depDate componentsSeparatedByString:@" "];
    NSArray *arrTimeArray = [model.segment.arrDate componentsSeparatedByString:@" "];
    
    NSArray *depTimeArray1 = [depTimeArray[1] componentsSeparatedByString:@":"];
    NSArray *arrTimeArray1 = [arrTimeArray[1] componentsSeparatedByString:@":"];
    
    self.headerView.dep_timeLabel.text = [NSString stringWithFormat:@"%@:%@",depTimeArray1[0],depTimeArray1[1]];
    self.headerView.arv_timeLabel.text = [NSString stringWithFormat:@"%@:%@",arrTimeArray1[0],arrTimeArray1[1]];
    
    self.headerView.dep_airportLabel.text = [NSString stringWithFormat:@"%@ %@ %@",model.segment.depCityCName,model.segment.depAirportCName,self.ticketModel.depJetquay];
    
    self.headerView.arv_airportLabel.text = [NSString stringWithFormat:@"%@ %@ %@",model.segment.arrCityCName,model.segment.arrAirportCName,self.ticketModel.arrJetquay];
    self.headerView.flightNoLabel.text = model.segment.flightNo;//@"EU2235";
    self.headerView.planeTypeLabel.text = self.ticketModel.planeType;//@"里程:1339km";
    NSArray *distanceArray = [self.ticketModel.distance componentsSeparatedByString:@"."];
    NSString *distanceText = [NSString stringWithFormat:@"里程%@km",distanceArray[0]];
    self.headerView.distanceLabel.text = distanceText;
    if (self.ticketModel.meal.boolValue) {
        self.headerView.mealLabel.text = @"有餐食";
    }else{
        self.headerView.mealLabel.text = @"无餐食";
    }
    
    NSString *text = @"￥";
    NSString *amountText =  [NSString stringWithFormat:@"%@%@",text,model.totalPay];
    
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:amountText];
    /// 前面文字大小
    [mutableAttr addAttribute:NSFontAttributeName value:kFontSizeRegular15 range:NSMakeRange(0, text.length)];
    self.price_label.attributedText = mutableAttr;
    
    self.order_label.text = [NSString stringWithFormat:@"订单号:%@",model.orderNo];///@"订单号：262666566665";

    self.status_label.text = model.statusName;
}

- (void) requestTicketOrderData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.ticketModel.kid forKey:@"id"];
    [SCHttpTools getWithURLString:kHttpURL(@"flight-order/flightOrderDetails") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TicketOrderChildModel *model = [TicketOrderChildModel mj_objectWithKeyValues:result];
        if (model.errorcode == 20000) {
            [self.dataArray addObjectsFromArray:model.data.passengers];
            [self setupViewData:model.data];
        }else{
            Toast(model.message);
        }
        [self.tableView reloadData];
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        TTLog(@" -- error -- %@",error);
        [self.view dismissLoadingView];
    }];
}

- (void) initView{
    
    [self.view addSubview:self.boxView];
    [self.boxView addSubview:self.status_label];
    [self.boxView addSubview:self.order_label];
    [self.boxView addSubview:self.price_label];
    self.tableView.tableHeaderView = self.headerView;
    [Utils lz_setExtraCellLineHidden:self.tableView];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.boxView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(80));
    }];
    
    [self.status_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.top.equalTo(@(25));
    }];
    [self.order_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.status_label);
        make.bottom.equalTo(self.boxView.mas_bottom).offset(-5);
    }];
    [self.price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.order_label);
        make.right.equalTo(self.boxView.mas_right).offset(-25);
    }];
}

#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        TicketOrderChildPassengersModel *model = self.dataArray[indexPath.row];
        YXTicketOrderChildTableViewCell *tools = [YXTicketOrderChildTableViewCell cellWithTableViewCell:tableView forIndexPath:indexPath];
        tools.selectionStyle = UITableViewCellSelectionStyleNone;
        tools.title_label.text = @"出行人";
        if (indexPath.row==0) {
            tools.title_label.hidden = NO;
        }else{
            tools.title_label.hidden = YES;
        }
        tools.username_label.text = model.name;//@"张小明";
        NSString *ticketNo = model.ticketNo.length==0?@"尚未出票":model.ticketNo;
        tools.ticketno_label.text = [NSString stringWithFormat:@"票号：%@",ticketNo];//@"586-565569666666";
        tools.identityno_label.text = [NSString stringWithFormat:@"身份证：%@",model.certificateNum];//@"5101**********123";
        return tools;
    }else{
        TXPassengersTableViewCell5 *tools = [TXPassengersTableViewCell5 cellWithTableViewCell:tableView forIndexPath:indexPath];
        tools.title_label.text = @"取票电话";
        tools.textField.enabled = NO;
        tools.textField.text = self.ticketModel.ctct.length==0?@"无":self.ticketModel.ctct;
        return tools;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        return 50;
    }
    return 95;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.dataArray.count;
    }
    return 1;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

#pragma mark -- Section HearderView Title
// UITableView在Plain类型下，HeaderView和FooterView不悬浮和不停留的方法viewForHeaderInSection
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = kClearColor;
    return sectionView;
}

/// 对section设置圆角的方法就在此方法中实现即可
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section == 1) {
    //圆率
    CGFloat cornerRadius = 10.0;
    //大小
    //        CGRect bounds = cell.bounds;
    CGRect bounds = CGRectMake(cell.bounds.origin.x+10, cell.bounds.origin.y, cell.bounds.size.width-20, cell.bounds.size.height);
    //行数
    NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
    //绘制曲线
    UIBezierPath *bezierPath = nil;
    if (indexPath.row == 0 && numberOfRows == 1) {
        //一个为一组时,四个角都为圆角
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    } else if (indexPath.row == 0) {
        //为组的第一行时,左上、右上角为圆角
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    } else if (indexPath.row == numberOfRows - 1) {
        //为组的最后一行,左下、右下角为圆角
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    } else {
        //中间的都为矩形
        bezierPath = [UIBezierPath bezierPathWithRect:bounds];
    }
    //cell的背景色透明
    cell.backgroundColor = [UIColor clearColor];
    //新建一个图层
    CAShapeLayer *layer = [CAShapeLayer layer];
    //图层边框路径
    layer.path = bezierPath.CGPath;
    //图层填充色,也就是cell的底色
    layer.fillColor = [UIColor whiteColor].CGColor;
    //图层边框线条颜色
    /*
     如果self.tableView.style = UITableViewStyleGrouped时,每一组的首尾都会有一根分割线,目前我还没找到去掉每组首尾分割线,保留cell分割线的办法。
     所以这里取巧,用带颜色的图层边框替代分割线。
     这里为了美观,最好设为和tableView的底色一致。
     设为透明,好像不起作用。
     */
    layer.strokeColor = [UIColor whiteColor].CGColor;
    //将图层添加到cell的图层中,并插到最底层
    [cell.layer insertSublayer:layer atIndex:0];
    //    }
}

#pragma mark ----- getter/setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_tableView registerClass:[YXTicketOrderChildTableViewCell class] forCellReuseIdentifier:[YXTicketOrderChildTableViewCell reuseIdentifier]];
        [_tableView registerClass:[TXPassengersTableViewCell5 class] forCellReuseIdentifier:[TXPassengersTableViewCell5 reuseIdentifier]];
        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kClearColor;
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

- (YKTicketBookingHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YKTicketBookingHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, 160);
    }
    return _headerView;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kClearColor];
    }
    return _boxView;
}

- (UILabel *)status_label{
    if (!_status_label) {
        _status_label = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium18];
    }
    return _status_label;
}

- (UILabel *)order_label{
    if (!_order_label) {
        _order_label = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium14];
    }
    return _order_label;
}

- (UILabel *)price_label{
    if (!_price_label) {
        _price_label = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium28];
    }
    return _price_label;
}

@end
