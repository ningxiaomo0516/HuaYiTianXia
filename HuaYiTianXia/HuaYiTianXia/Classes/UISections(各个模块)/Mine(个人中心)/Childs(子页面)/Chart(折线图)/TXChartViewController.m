//
//  TXChartViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/7/3.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXChartViewController.h"
#import "TTChartView.h"
#import "TXChartModel.h"

@interface TXChartViewController ()<UIScrollViewDelegate>
/// AH近七日释放情况(释放)
@property (nonatomic, strong) TTChartView *chartView;
/// VH近七日释放情况(释放)
@property (nonatomic, strong) TTChartView *chartView1;
/// 复投七日倍数变化情况市值(%)
@property (nonatomic, strong) TTChartView *chartView2;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *title_label_1;
@property (nonatomic, strong) UILabel *title_label_2;
@property (nonatomic, strong) UILabel *title_label_3;

@end

@implementation TXChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"近期积分变动情况";
    [self.view showLoadingViewWithText:@"加载中..."];
    [self get_integral];
    
    // 下拉刷新
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self get_integral];
    }];
}

/// 获取积分数据变化情况
- (void) get_integral{
    [SCHttpTools getWithURLString:kHttpURL(@"customer/assetsChange") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXChartModel *chartModel = [TXChartModel mj_objectWithKeyValues:result];
        if (chartModel.errorcode==20000) {
            NSMutableArray *dataArray0 = [[NSMutableArray alloc] init];
            NSMutableArray *dataArray1 = [[NSMutableArray alloc] init];
            NSMutableArray *dataArray2 = [[NSMutableArray alloc] init];
            for (ChartModel *model in chartModel.data.AH) {
                [dataArray0 addObject:model.count];
            }
            for (ChartModel *model in chartModel.data.VH) {
                [dataArray1 addObject:model.count];
            }
            for (ChartModel *model in chartModel.data.FT) {
                [dataArray2 addObject:model.count];
            }
            
            NSInteger count0 = 7 - dataArray0.count;
            NSInteger count1 = 7 - dataArray1.count;
            NSInteger count2 = 7 - dataArray2.count;
            for (int i=0; i<count0; i++) {
//                [dataArray0 insertObject:[NSString stringWithFormat:@"%d",(i+1)*kRandomNumber(100)] atIndex:i];
                [dataArray0 insertObject:@"0" atIndex:i];
            }
            for (int i=0; i<count1; i++) {
                [dataArray1 insertObject:@"0" atIndex:i];
            }
            for (int i=0; i<count2; i++) {
                [dataArray2 insertObject:@"0" atIndex:i];
            }
            [self initView:dataArray0 dataArray1:dataArray1 dataArray2:dataArray2];
        }
        [self.view dismissLoadingView];
        [self.scrollView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.view dismissLoadingView];
        [self.scrollView.mj_header endRefreshing];
    }];
}

- (void) initView:(NSArray *)dataArray0 dataArray1:(NSArray *)dataArray1 dataArray2:(NSArray *)dataArray2{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.title_label_1];
    [self.scrollView addSubview:self.title_label_2];
    [self.scrollView addSubview:self.title_label_3];
    
    self.title_label_1.frame = CGRectMake(0, 10, kScreenWidth, 44);
//    NSArray *dataArray = @[@"123",@"440",@"88", @"45",@"33",@"100",@"220"];
    CGRect rect = CGRectMake(0, CGRectGetMaxY(self.title_label_1.frame), kScreenWidth, 300);
    _chartView = [[TTChartView alloc]initWithFrame:rect dataSource:dataArray0 countFoyY:7];
    [self initChartView:_chartView title_y:@"释放/AH"];
    [_chartView pointDidTapedCompletion:^(NSString *value, NSInteger index) {
        TTLog(@"....%@....%ld", value, (long)index);
    }];
    
    
    self.title_label_2.frame = CGRectMake(0, CGRectGetMaxY(_chartView.frame)+10, kScreenWidth, 44);
    CGRect rect1 = CGRectMake(0, CGRectGetMaxY(self.title_label_2.frame), kScreenWidth, 300);
    _chartView1 = [[TTChartView alloc]initWithFrame:rect1 dataSource:dataArray1 countFoyY:7];
    [self initChartView:_chartView1 title_y:@"释放/VH"];
    [_chartView1 pointDidTapedCompletion:^(NSString *value, NSInteger index) {
        TTLog(@"....%@....%ld", value, (long)index);
    }];
    
//    NSArray *dataArray2 = @[@"123",@"176",@"88", @"45",@"33",@"100",@"220"];
    self.title_label_3.frame = CGRectMake(0, CGRectGetMaxY(_chartView1.frame)+10, kScreenWidth, 44);
    CGRect rect3 = CGRectMake(0, CGRectGetMaxY(self.title_label_3.frame), kScreenWidth, 300);
    _chartView2 = [[TTChartView alloc] initWithFrame:rect3 dataSource:dataArray2 countFoyY:7];
    [self initChartView:_chartView2 title_y:@"释放/复投"];
    [_chartView2 pointDidTapedCompletion:^(NSString *value, NSInteger index) {
        TTLog(@"....%@....%ld", value, (long)index);
    }];
    [self.scrollView addSubview:_chartView];
    [self.scrollView addSubview:_chartView1];
    [self.scrollView addSubview:_chartView2];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_chartView2.frame)+kNavBarHeight+kSafeAreaBottomHeight);
}

- (void) initChartView:(TTChartView *)chartView title_y:(NSString *) title_y{
    chartView.duration = 2.0f;
    chartView.lineColor = kThemeColorHex;
    chartView.style = ChatViewStyleSingleCurve;
    chartView.titleForX = @"日期/日";
    chartView.titleForY = title_y;//@"收益/元";
    chartView.maskColors = @[kThemeColorHex,kWhiteColor];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = kViewColorNormal;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+1);
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

- (UILabel *)title_label_1{
    if (!_title_label_1) {
        _title_label_1 = [UILabel lz_labelWithTitle:@"AH近七日释放情况(释放)" color:kTextColor51 font:kFontSizeMedium15];
        _title_label_1.textAlignment = NSTextAlignmentCenter;
        _title_label_1.backgroundColor = kWhiteColor;
    }
    return _title_label_1;
}

- (UILabel *)title_label_2{
    if (!_title_label_2) {
        _title_label_2 = [UILabel lz_labelWithTitle:@"VH近七日释放情况(释放)" color:kTextColor51 font:kFontSizeMedium15];
        _title_label_2.textAlignment = NSTextAlignmentCenter;
        _title_label_2.backgroundColor = kWhiteColor;
    }
    return _title_label_2;
}

- (UILabel *)title_label_3{
    if (!_title_label_3) {
        _title_label_3 = [UILabel lz_labelWithTitle:@"复投七日倍数变化情况市值(%)" color:kTextColor51 font:kFontSizeMedium15];
        _title_label_3.textAlignment = NSTextAlignmentCenter;
        _title_label_3.backgroundColor = kWhiteColor;
    }
    return _title_label_3;
}
@end
