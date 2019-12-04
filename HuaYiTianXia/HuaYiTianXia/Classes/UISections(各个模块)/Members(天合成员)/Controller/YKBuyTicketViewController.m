//
//  YKBuyTicketViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/7.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKBuyTicketViewController.h"
#import "TXPassengersTableViewCell.h"
#import "TXTicketModel.h"
#import "YKChoosePayViewController.h"
#import "TXWebViewController.h"
#import "YKPassengersViewController.h"
#import "YKPassengersCollectionViewCell.h"

@interface YKBuyTicketViewController ()<UITableViewDelegate,UITableViewDataSource,YKPassengersCollectionViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *title_label1;
@property (nonatomic, strong) UILabel *title_label2;
@property (nonatomic, strong) UILabel *title_label3;
@property (nonatomic, strong) UILabel *price_label;
@property (nonatomic, strong) UILabel *seat_label;
@property (nonatomic, strong) UIView *box_view;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *agreementBtn;

@property (nonatomic, strong) UIImageView *imagesView1;
@property (nonatomic, strong) UIImageView *imagesView2;
@property (nonatomic, strong) UIImageView *imagesView3;
@property (nonatomic, strong) ServiceInfoModel *serviceModel;
@property (nonatomic, strong) TicketModel *ticketModel;
@property (nonatomic, strong) SeatItems *seatItems;
//// 乘客信息
@property (nonatomic, strong) NSMutableArray *passengersArray;
/// 价格信息
@property (nonatomic, strong) NSMutableArray *priceDatasArray;
/// 航程航线数据
@property (nonatomic, strong) NSMutableArray *segmentsArray;
/// 航程航线数据
@property (nonatomic, copy) NSString *telphone;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
/// 临时的乘机人数据
@property (nonatomic, strong) NSMutableArray *tempArray;
/// 临时的乘机人数据(已经选择的数据)
@property (nonatomic, strong) NSMutableArray *tempSelectedArray;

@end
/// sc_initImageWithText
@implementation YKBuyTicketViewController
- (id)initTicketModel:(TicketModel *)ticketModel seatItems:(SeatItems *)seatItems{
    if ( self = [super init] ){
        self.ticketModel = ticketModel;
        self.seatItems = seatItems;
        
        /// 航班信息(用于下单支付)
        NSMutableDictionary *segment_dic = [[NSMutableDictionary alloc] init];
        [segment_dic setObject:self.ticketModel.flightNo forKey:@"flightNo"];
        [segment_dic setObject:self.ticketModel.depTime forKey:@"depDate"];
        [segment_dic setObject:self.ticketModel.depCode forKey:@"depCode"];
        [segment_dic setObject:self.ticketModel.arrCode forKey:@"arrCode"];
        [segment_dic setObject:self.ticketModel.arrTime forKey:@"arrDate"];
        [segment_dic setObject:self.seatItems.seatCode forKey:@"cabin"];
        [self.segmentsArray addObject:segment_dic];
        
        /// 价格信息
        NSMutableDictionary *price_dic = [[NSMutableDictionary alloc] init];
        [price_dic setObject:self.seatItems.crewType forKey:@"crewType"];
        [price_dic setObject:self.seatItems.price forKey:@"price"];
        [price_dic setObject:self.seatItems.airportTax forKey:@"airportTax"];
        [price_dic setObject:self.seatItems.fuelTax forKey:@"fuelTax"];
        [self.priceDatasArray addObject:price_dic];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.hidden = YES;
    [self initView];
    [self getData];
    [self.nextButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self submitOrderGetSignature];
    }];
    [self addGesture:self.tableView];
    // 注册通知
    [kNotificationCenter addObserver:self selector:@selector(AlipayStatusBlock:) name:@"AlipayStatus" object:nil];
}

- (void)AlipayStatusBlock:(NSNotification *)notification{
    NSDictionary *resultDic = [notification object];
    // 这样就得到了我们在发送通知时候传入的字典了
    TTLog(@"yk----result = %@",[Utils lz_dataWithJSONObject:resultDic]);
    TTLog(@"%@",[resultDic lz_objectForKey:@"memo"]);
    // 解析 auth code
    NSInteger resultCode = [resultDic[@"resultStatus"] integerValue];
    if (resultCode == 9000) {
        Toast(@"订单支付成功!");
        [kNotificationCenter postNotificationName:@"AlipaySuccessful" object:nil];
        [self YKAlipaySuccessful];
    }else if (resultCode == 4000){
        Toast(@"订单支付失败!");
    }else if (resultCode == 5000){
        Toast(@"重复请求!");
    }else if (resultCode == 6001){
        Toast(@"取消支付!");
    }else if (resultCode == 6002){
        Toast(@"网络连接出错!");
    }else if (resultCode == 6004){
        Toast(@"未知支付结果");
    }else{
        Toast(@"未知操作");
    }
}

/// 签名成功处理
- (void) YKAlipaySuccessful{
    /// 跳转支付宝或微信进行支付
    [self.navigationController popToRootViewControllerAnimated:YES];
    //    [self.navigationController.tabBarController setSelectedIndex:4];
    /// 是否跳转成功,未知,没测
    UITabBarController *tab=self.tabBarController;
    if (tab){
        TTLog(@"I have a tab bar");
        [self.tabBarController setSelectedIndex:4];
    } else{
        TTLog(@"I don't have");
    }
}


/// 提交订单,获取支付签名
- (void) submitOrderGetSignature{
    
    if (self.tempSelectedArray.count>0) {
        [self.passengersArray removeAllObjects];
    }
    for (PassengerModel *model in self.tempSelectedArray) {
        /// 遍历已选择的乘机信息
        NSMutableDictionary *ppassenger_dic = [[NSMutableDictionary alloc] init];
        [ppassenger_dic setObject:model.name forKey:@"name"];
        /// 证件类型 1 身份证 2 其他证件
        [ppassenger_dic setObject:@(1) forKey:@"identityType"];
        /// 乘机人类型 1:成人 2:儿童 3:婴儿(暂不使 用)
        [ppassenger_dic setObject:self.seatItems.crewType forKey:@"crewType"];
        [ppassenger_dic setObject:model.phoneNum forKey:@"phoneNum"];
        [ppassenger_dic setObject:model.identityNo forKey:@"identityNo"];
        [self.passengersArray addObject:ppassenger_dic];
    }
    
    if (self.passengersArray.count==0) {
        Toast(@"请选择乘机人");
        return;
    }
    if (self.telphone.length == 0) {
        Toast(@"请填写取票电话");
        return;
    }
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    /// 起飞航站楼
    [parameter setObject:self.ticketModel.depJetquay forKey:@"depJetquay"];
    /// 抵达航站楼
    [parameter setObject:self.ticketModel.arrJetquay forKey:@"arrJetquay"];
    /// 里程
    [parameter setObject:self.ticketModel.distance forKey:@"distance"];
    /// 是否有餐食
    [parameter setObject:self.ticketModel.meal forKey:@"meal"];
    /// 机型
    [parameter setObject:self.ticketModel.planeType forKey:@"planeType"];
    
    /// 通过查询返回的产品ID 如:1­19291223
    [parameter setObject:self.seatItems.policys.policyId forKey:@"policyId"];
    /// 航程类型 OW 单程，RT 往返， 目前仅支持单程
    [parameter setObject:@"OW" forKey:@"routeType"];
    /// 乘客类型: 1.成人、2.儿童、3.成人+儿童 4.成人+婴儿 5. 成人+儿童+婴儿 目前不支持婴儿查询
    [parameter setObject:@(1) forKey:@"passengerType"];
    /// 取票电话
    [parameter setObject:self.telphone forKey:@"ctct"];
    /// 支付方式 0:支付宝 1:微信(默认支付宝)
    [parameter setObject:@"0" forKey:@"payType"];
    /// 出发城市
    [parameter setObject:self.ticketModel.depCname forKey:@"depCname"];
    /// 抵达城市
    [parameter setObject:self.ticketModel.arrCname forKey:@"arrCname"];
    /// 乘客信息 Arrays
    [parameter setObject:self.passengersArray forKey:@"passengers"];
    /// 航程航线数据
    [parameter setObject:self.segmentsArray forKey:@"segments"];
    /// 价格信息 :传入时平台验价后 生成订单 不传入价格 有 平台规则生成订单
    [parameter setObject:self.priceDatasArray forKey:@"priceDatas"];
    TTLog(@"参数 -- %@",parameter);
    YKChoosePayViewController *vc = [[YKChoosePayViewController alloc] initDictionary:parameter];
    CGFloat height = kScreenHeight-kScreenHeight/3;
    [self sc_bottomPresentController:vc presentedHeight:height completeHandle:^(BOOL presented) {
        if (presented) {
            TTLog(@"弹出了");
        }else{
            TTLog(@"消失了");
        }
    }];
}

/// 获取服务费用
- (void) getData {
    [self.view showLoadingViewWithText:@"请稍后..."];
    [SCHttpTools getWithURLString:kHttpURL(@"flight-tax/info") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        FlightServiceModel *model = [FlightServiceModel mj_objectWithKeyValues:result];
        if (model.errorcode==20000) {
            self.serviceModel = model.data;
            FlightTaxModel *tax_model = self.serviceModel.flightTax;
            NSInteger cost = [tax_model.serviceTax integerValue] +
                             [tax_model.fuelTax integerValue] +
                             [tax_model.insureTax integerValue];
            if (model.data.customer.usertype==0) {
                cost = cost + [self.seatItems.price integerValue];
            }else{
                
            }
            NSString *tipText = @"￥";
            NSString *amountText =  [NSString stringWithFormat:@"%@%ld",tipText,(long)cost];
            NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:amountText];
            /// 前面文字大小
            [mutableAttr addAttribute:NSFontAttributeName value:kFontSizeMedium13 range:NSMakeRange(0, tipText.length)];
            self.price_label.attributedText = mutableAttr;
            self.seat_label.text = self.seatItems.seatMsg;
            self.telphone = model.data.customer.mobile;
            
            if (model.data.customer.usertype == 0) {
                /// 如果乘机人数组不为空，则添加所有
//                self.passengersArray = model.data.idCards;
                for (IdCardsModel *cardModel in model.data.idCards) {
                    PassengerModel *model_ = [[PassengerModel alloc] init];
                    model_.isAdd = NO;
                    model_.name = cardModel.name;
                    model_.identityNo = cardModel.identityNo;
                    model_.identityNo = cardModel.identityNo;
                    model_.phoneNum = cardModel.phoneNum;
                    [self.tempArray addObject:model_];
                }
            }else{
                /// 乘机人数组为空，则添加会员信息
                NSMutableDictionary *ppassenger_dic = [[NSMutableDictionary alloc] init];
                [ppassenger_dic setObject:model.data.customer.name forKey:@"name"];
                /// 证件类型 1 身份证 2 其他证件
                [ppassenger_dic setObject:@(1) forKey:@"identityType"];
                /// 乘机人类型 1:成人 2:儿童 3:婴儿(暂不使 用)
                [ppassenger_dic setObject:self.seatItems.crewType forKey:@"crewType"];
                [ppassenger_dic setObject:model.data.customer.mobile forKey:@"phoneNum"];
                [ppassenger_dic setObject:model.data.customer.code forKey:@"identityNo"];
                [self.passengersArray addObject:ppassenger_dic];
            }
            
            
            [self.tableView reloadData];
            self.tableView.hidden = NO;
        }else{
            Toast(model.message);
        }
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        [self.view dismissLoadingView];
    }];
}

- (void)textFieldWithText:(UITextField *)textField{
    self.telphone = textField.text;
}

- (void) initView{
    [self.view addSubview:self.bottomView];
    [self.box_view addSubview:self.price_label];
    [self.box_view addSubview:self.seat_label];
    [self.box_view addSubview:self.nextButton];
    [Utils lz_setExtraCellLineHidden:self.tableView];
    self.tableView.tableFooterView = self.footerView;
    [self.footerView addSubview:self.title_label1];
    [self.footerView addSubview:self.agreementBtn];
    [self.footerView addSubview:self.title_label2];
    [self.footerView addSubview:self.title_label3];
    [self.footerView addSubview:self.imagesView1];
    [self.footerView addSubview:self.imagesView2];
    [self.footerView addSubview:self.imagesView3];
    [self.view addSubview:self.tableView];
    [self initViewConstraints];
    
    self.title_label1.text = @"点击去付款表示您已阅读并同意.";
    self.title_label2.text = @"飞机票无法保证100%出票,如出票失败将短信通知,票款将原路返回到您的账户,请您谅解.";
    self.title_label3.text = @"服务费为商家收取(含技术费、手续费等),如退票服务费不退.";
    [self.agreementBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        TXWebViewController *vc = [[TXWebViewController alloc] init];
        vc.title = @"《共享航空预定协议》";
        vc.webUrl = [NSString stringWithFormat:@"%@%@",DomainName,@"service.html"];
        TTPushVC(vc);
    }];
}

#pragma mark ---- 约束布局
- (void) initViewConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.imagesView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(@(25));
    }];
    [self.title_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(35));
        make.centerY.equalTo(self.imagesView1);
        make.right.equalTo(self.view.mas_right).offset(-15);
    }];
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_label1);
        make.top.equalTo(self.title_label1.mas_bottom).offset(-3);
    }];
    [self.imagesView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView1);
        make.top.equalTo(self.agreementBtn.mas_bottom).offset(1);
    }];
    [self.title_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_label1);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.imagesView2);
    }];
    [self.imagesView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView1);
        make.top.equalTo(self.title_label2.mas_bottom).offset(10);
    }];
    [self.title_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_label1);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.imagesView3.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kTabBarHeight));
    }];
    
    [self.price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.centerY.equalTo(self.box_view);
    }];
    [self.seat_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.box_view);
        make.left.equalTo(self.price_label.mas_right).offset(10);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.width.equalTo(@(90));
        make.height.equalTo(@(35));
        make.centerY.equalTo(self.box_view);
    }];
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


#pragma mark - Table view data sourceFMMerchantsHomeAddressTableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            TXPassengersTableViewCell2 *tools = [TXPassengersTableViewCell2 cellWithTableViewCell:tableView forIndexPath:indexPath];
            tools.title_label.text = @"当先价格仅剩不多，下手要快哦！";
            FlightTaxModel *model = self.serviceModel.flightTax;
            NSString *serviceText;
            if (self.serviceModel.customer.usertype==0) {
                /// 非会员情况下需展示票面价
                serviceText = [NSString stringWithFormat:@"票价%@燃油费%@+服务费%@+保险费%@",
                               self.seatItems.price,model.serviceTax,model.fuelTax,model.insureTax];
            }else{
                serviceText = [NSString stringWithFormat:@"燃油费%@+服务费%@+保险费%@",
                               model.serviceTax,model.fuelTax,model.insureTax];
            }
            /// @"成人票￥520+机建燃油费￥50+服务费9元+保险费￥39元"
            tools.subtitle_label.text = serviceText;
            return tools;
        }else if(indexPath.row==0){
            TXPassengersTableViewCell *tools = [TXPassengersTableViewCell cellWithTableViewCell:tableView forIndexPath:indexPath];
            tools.date_label.text = self.ticketModel.dep_date;//@"9月30日";
            tools.week_label.text = self.ticketModel.dep_week;//@"周三";
            tools.time_label.text = self.ticketModel.dep_time;//@"10:40";
            tools.seat_label.text = self.seatItems.seatMsg;///@"经济舱";
            return tools;
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            TXPassengersTableViewCell3 *tools = [TXPassengersTableViewCell3 cellWithTableViewCell:tableView forIndexPath:indexPath];
            if (self.serviceModel.customer.usertype==0) {
                tools.title_label.text = @"选择乘机人";
                tools.subtitle_label.hidden = YES;
                tools.imagesView.hidden = YES;
            }else{
                tools.title_label.text = @"乘机人";
            }
            tools.subtitle_label.text = @"至尊会员";
            return tools;
        }else{
            /// 非会员情况
            if (self.serviceModel.customer.usertype==0&&indexPath.row==1) {
                YKPassengersCollectionViewCell *tools = [YKPassengersCollectionViewCell cellWithTableViewCell:tableView forIndexPath:indexPath];
                tools.delegate = self;
                tools.indexPath = indexPath;
                TTLog(@"tempArray -- %@",self.tempArray);
                tools.dataArray = self.tempArray;
                return tools;
            }else{
                TXPassengersTableViewCell4 *tools = [TXPassengersTableViewCell4 cellWithTableViewCell:tableView forIndexPath:indexPath];
                if (self.serviceModel.customer.usertype==0) {
                    PassengerModel *model = self.tempSelectedArray[indexPath.row-2];
                    if (!model.isAdd) {
                        tools.username_label.text = model.name;
                        tools.idcard_label.text = [NSString stringWithFormat:@"身份证 %@",model.identityNo];
                        tools.ticket_type_label.text = @"成人票";
                    }
                }else{
                    tools.username_label.text = self.serviceModel.customer.name;
                    tools.idcard_label.text = [NSString stringWithFormat:@"身份证 %@",self.serviceModel.customer.code];
                    tools.ticket_type_label.text = @"成人票";
                }
                return tools;
            }
        }
    }else if (indexPath.section == 2){
        TXPassengersTableViewCell5 *tools = [TXPassengersTableViewCell5 cellWithTableViewCell:tableView forIndexPath:indexPath];
        tools.title_label.text = @"取票电话";
        [tools.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        tools.textField.text = self.telphone;
        return tools;
    }else if (indexPath.section==3){
        if (indexPath.row==0) {
            TXPassengersTableViewCell6 *tools = [TXPassengersTableViewCell6 cellWithTableViewCell:tableView forIndexPath:indexPath];
            tools.title_label.text = @"出行保障";
            tools.subtitle_label.text = @"让家人多一份安心";
            return tools;
        }else{
            TXPassengersTableViewCell7 *tools = [TXPassengersTableViewCell7 cellWithTableViewCell:tableView forIndexPath:indexPath];
            tools.title_label.text = @"航意险";
            tools.subtitle_label.text = @"最高保额320万，让您一路安心";
            return tools;
        }
    }
    return [UITableViewCell new];
}

#pragma mark ====== Second Section======
- (void)updateSecondTableViewCellHeight:(YKPassengersCollectionViewCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath {
    if (![self.heightAtIndexPath[indexPath] isEqualToNumber:@(height)]) {
        self.heightAtIndexPath[indexPath] = @(height);
        [self.tableView reloadData];
    }
}

#pragma mark ====== onClick Second Section 热门城市======
- (void)didPassengerSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath withModel:(nonnull PassengerModel *)model{
    if (model.isAdd) {
        YKPassengersViewController *vc = [[YKPassengersViewController alloc] init];
        vc.returnBlock = ^(PassengerModel * _Nonnull passengerModel) {
            [self.tempSelectedArray addObject:passengerModel];
            [self.tempArray addObject:passengerModel];
            //一个section刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:1];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self.navigationController presentViewController:vc animated:YES completion:nil];
//        TTPushVC(vc);
    }else{
        PassengerModel *updateModel = self.tempArray[indexPath.row];
        if (model.isSelected) {
            updateModel.isSelected = NO;
            [self.tempSelectedArray removeObject:model];
        }else{
            updateModel.isSelected = YES;
            [self.tempSelectedArray addObject:model];
        }
        
        //一个section刷新
        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        FlightTaxModel *tax_model = self.serviceModel.flightTax;
        NSInteger cost = [tax_model.serviceTax integerValue] +
                         [tax_model.fuelTax integerValue] +
                         [tax_model.insureTax integerValue];
        if (self.serviceModel.customer.usertype==0) {
            cost = cost + [self.seatItems.price integerValue];
        }
        NSString *tipText = @"￥";
        NSString *amountText =  [NSString stringWithFormat:@"%@%ld",tipText,(long)cost*self.tempSelectedArray.count];
        NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:amountText];
        /// 前面文字大小
        [mutableAttr addAttribute:NSFontAttributeName value:kFontSizeMedium13 range:NSMakeRange(0, tipText.length)];
        self.price_label.attributedText = mutableAttr;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0||indexPath.section==2) {
        if (indexPath.row==0) {
            return 50;
        }else{
            return UITableViewAutomaticDimension;
        }
    }else if(indexPath.section==1&&self.serviceModel.customer.usertype==0){
        if (self.serviceModel.customer.usertype==0&&indexPath.row==1) {
            if (self.heightAtIndexPath[indexPath]) {
                NSNumber *num = self.heightAtIndexPath[indexPath];
                /// collectionView 底部还有七个像素
                TTLog(@"[num floatValue] --- %f",[num floatValue]);
                return [num floatValue];
            }else {
                return 64;
            }
        }else{
            if (indexPath.row==0) {
                return 40;
            }else if(indexPath.row==0){
                return UITableViewAutomaticDimension;
            }else{
                return 70;
            }
        }
    } else{
        if (indexPath.row==0) {
            return 40;
        }else{
            return 70;
        }
    }
    return 100;
}

// 多少个分组 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

/// 返回多少
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==1) {
        if (self.serviceModel.customer.usertype==0) {
            return self.tempSelectedArray.count+2;
        }else{
            return 2;
        }
    }
    if (section==2) return 1;
    return 2;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (self.serviceModel.customer.usertype==0&&indexPath.row>1) {
            
        }else{
            
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ----- getter/setter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 25)];
        [_tableView registerClass:[TXPassengersTableViewCell class] forCellReuseIdentifier:[TXPassengersTableViewCell reuseIdentifier]];
        [_tableView registerClass:[TXPassengersTableViewCell2 class] forCellReuseIdentifier:[TXPassengersTableViewCell2 reuseIdentifier]];
        [_tableView registerClass:[TXPassengersTableViewCell3 class] forCellReuseIdentifier:[TXPassengersTableViewCell3 reuseIdentifier]];
        [_tableView registerClass:[TXPassengersTableViewCell4 class] forCellReuseIdentifier:[TXPassengersTableViewCell4 reuseIdentifier]];
        [_tableView registerClass:[TXPassengersTableViewCell5 class] forCellReuseIdentifier:[TXPassengersTableViewCell5 reuseIdentifier]];
        [_tableView registerClass:[TXPassengersTableViewCell6 class] forCellReuseIdentifier:[TXPassengersTableViewCell6 reuseIdentifier]];
        [_tableView registerClass:[TXPassengersTableViewCell7 class] forCellReuseIdentifier:[TXPassengersTableViewCell7 reuseIdentifier]];
        [_tableView registerClass:[YKPassengersCollectionViewCell class] forCellReuseIdentifier:[YKPassengersCollectionViewCell reuseIdentifier]];

        //1 禁用系统自带的分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kViewColorNormal;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kClearColor];
        _footerView.frame = CGRectMake(0, 25, kScreenWidth, 140);
    }
    return _footerView;
}

- (UILabel *)title_label1{
    if (!_title_label1) {
        _title_label1 = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
    }
    return _title_label1;
}

- (UILabel *)title_label2{
    if (!_title_label2) {
        _title_label2 = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
    }
    return _title_label2;
}

- (UILabel *)title_label3{
    if (!_title_label3) {
        _title_label3 = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
    }
    return _title_label3;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView lz_viewWithColor:kWhiteColor];
        [_bottomView addSubview:self.box_view];
        [_box_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self->_bottomView);
            make.height.equalTo(@(49));
        }];
    }
    return _bottomView;
}

- (UILabel *)price_label{
    if (!_price_label) {
        _price_label = [UILabel lz_labelWithTitle:@"" color:kColorWithRGB(230, 0, 18) font:kFontSizeMedium20];
    }
    return _price_label;
}
- (UILabel *)seat_label{
    if (!_seat_label) {
        _seat_label = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium11];
    }
    return _seat_label;
}

- (UIView *)box_view{
    if (!_box_view) {
        _box_view = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _box_view;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_nextButton isRadius:YES];
    }
    return _nextButton;
}

- (UIButton *)agreementBtn{
    if (!_agreementBtn) {
        _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreementBtn setTitle:@"《共享航空预定协议》" forState:UIControlStateNormal];
        _agreementBtn.titleLabel.font = kFontSizeMedium13;
        [_agreementBtn setTitleColor:kColorWithRGB(199, 167, 101) forState:UIControlStateNormal];
    }
    return _agreementBtn;
}

- (UIImageView *)imagesView1{
    if (!_imagesView1) {
        _imagesView1 = [[UIImageView alloc] init];
        _imagesView1.image = kGetImage(@"感叹号");
    }
    return _imagesView1;
}
- (UIImageView *)imagesView2{
    if (!_imagesView2) {
        _imagesView2 = [[UIImageView alloc] init];
        _imagesView2.image = kGetImage(@"感叹号");
    }
    return _imagesView2;
}
- (UIImageView *)imagesView3{
    if (!_imagesView3) {
        _imagesView3 = [[UIImageView alloc] init];
        _imagesView3.image = kGetImage(@"感叹号");
    }
    return _imagesView3;
}

- (NSMutableArray *)passengersArray{
    if (!_passengersArray) {
        _passengersArray = [[NSMutableArray alloc] init];
    }
    return _passengersArray;
}

- (NSMutableArray *)priceDatasArray{
    if (!_priceDatasArray) {
        _priceDatasArray = [[NSMutableArray alloc] init];
    }
    return _priceDatasArray;
}

- (NSMutableArray *)segmentsArray{
    if (!_segmentsArray) {
        _segmentsArray = [[NSMutableArray alloc] init];
    }
    return _segmentsArray;
}

- (NSMutableDictionary *)heightAtIndexPath {
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [[NSMutableDictionary alloc] init];
    }
    return _heightAtIndexPath;
}

- (NSMutableArray *)tempArray{
    if (!_tempArray) {
        _tempArray = [[NSMutableArray alloc] init];
        PassengerModel *model = [[PassengerModel alloc] init];
        model.isAdd = YES;
        model.name = @"51622";
        [_tempArray addObject:model];
    }
    return _tempArray;
}

- (NSMutableArray *)tempSelectedArray{
    if (!_tempSelectedArray) {
        _tempSelectedArray = [[NSMutableArray alloc] init];
    }
    return _tempSelectedArray;
}
@end
