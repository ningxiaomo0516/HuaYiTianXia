//
//  TTBaseTableView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/8.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseTableView.h"

static NSString * const pageIndex = @"page";//获取第几页的根据自己的需求替换
@interface TTBaseTableView (){
    /// 纪录当前页数
    NSInteger _pageNumber;
    /// 出现网络失败
    BOOL _hasNetError;
}
/**添加的footView*/
@property (nonatomic ,strong) UIView *footerView;
@end

@implementation TTBaseTableView

+ (void)load{
    Method originalMethod = class_getInstanceMethod(self, @selector(reloadData));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(tt_reloadData));
    BOOL didAddMethod =
    class_addMethod(self,
                    @selector(reloadData),
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self,
                            @selector(tt_reloadData),
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style] ) {
        [self initTableView];
        [self initialData];
    }
    return self;
}

/// 初始值设置
- (void) initialData{
    self.requestType = YES;
    self.emptyView.imageName = @"c12_live_nodata";
    self.emptyView.hintText = @"暂无数据";
    self.emptyView.hintTextFont = kFontSizeMedium15;
    self.emptyView.hintTextColor = kTextColor102;
    self.emptyView.height = kScreenHeight - self.tableHeaderView.frame.size.height- kNavBarHeight - self.emptyViewHeight;
    
}

- (void)initTableView{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tt_requestData)];
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.estimatedRowHeight  = 0;
    self.estimatedSectionFooterHeight  = 0;
    self.estimatedSectionFooterHeight = 0;
    self.footerView = [UIView new];
    [self setTableFooterView:self.footerView];
    _hasNetError = NO;
    self.canResponseMutiGesture = NO;
}

- (void)tt_reloadData{
    [self tt_reloadData];
    if (self.totalSize == 0 && _hasNetError) {
        //这里是网络出错的数据为空
        self.tableFooterView = self.emptyView;
    }else if (self.totalSize == 0 ){
        //就是数据为空
        self.tableFooterView =  self.emptyView;
    }else{
        [self setTableFooterView:self.footerView];
    }
}

- (NSInteger)totalSize{
    NSInteger sections = 0;
    sections = [self numberOfSections];
    NSInteger items = 0;
    for (NSInteger section = 0; section < sections; section++) {
        items += [self numberOfRowsInSection:section];
    }
    return items;
}

- (void)setUpWithURLString:(NSString *)URLString parameter:(NSDictionary *)parameter tempVC:(UIViewController *)tempVC{
    _requestURL     = URLString;
    _tempVC         = tempVC;
    _parameter      = parameter.mutableCopy;
    if ([parameter.allKeys containsObject:pageIndex]) {
        self.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(tt_footerRefresh)];
    }
    [self.mj_header beginRefreshing];
}


/**
 *  请求方法
 *
 *  @param paramter 请求参数
 *  @param isPullDown 返回bool (YES:下拉刷新  NO:上拉加载)
 */
- (void)setupNetWorkParamter:(NSDictionary *)paramter isPullDown:(BOOL)isPullDown{
    //暂时是模仿数据请求h返回数据 替换下面的数据请求 这里就可以删除
    if ([self.requestDelegate respondsToSelector:@selector(tt_tableView:isPullDown:result:)]) {
        [self.requestDelegate tt_tableView:self isPullDown:isPullDown result:@[]];
    }
    self->_hasNetError = NO;
    [self showLoadingViewWithText:@"加载中..."];
    [self tt_endRefrseh];
    MV(weakSelf)
    //// YES:POST 1:GET(网络数据接口请求)
    if (self.requestType == kHttpGet) {
        [SCHttpTools getWithURLString:_requestURL parameter:paramter success:^(id responseObject) {

            [weakSelf dealwithSuccess:isPullDown result:responseObject];
            [self dismissLoadingView];
        } failure:^(NSError *error) {
            [weakSelf dealwithFailure:isPullDown error:error];
            [self dismissLoadingView];
        }];
    }else if(self.requestType == kHttpPost){
        [SCHttpTools postWithURLString:_requestURL parameter:paramter success:^(id responseObject) {
            
            [weakSelf dealwithSuccess:isPullDown result:responseObject];
            [self dismissLoadingView];
        } failure:^(NSError *error) {
            [weakSelf dealwithFailure:isPullDown error:error];
            [self dismissLoadingView];
        }];
    }else{
        TTLog(@"请设置网络请求类型 --- 参数为 requestType");
    }
}

/// 处理成功回调
- (void) dealwithSuccess:(BOOL)isPullDown result:(id)result{
    //不管有没有数据都应该抛出去
    if ([self.requestDelegate respondsToSelector:@selector(tt_tableView:isPullDown:result:)]) {
        [self.requestDelegate tt_tableView:self isPullDown:isPullDown result:result];
    }
    _hasNetError = NO;
    [self tt_endRefrseh];
}

/// 处理失败回调
- (void) dealwithFailure:(BOOL)isPullDown error:(NSError *)error{
    _hasNetError = YES;
    if ([self.requestDelegate respondsToSelector:@selector(tt_tableView:requestFailed:)]) {
        [self.requestDelegate tt_tableView:self requestFailed:error];
    }
    [self tt_endRefrseh];
    if (!isPullDown) {
        [self changeIndexWithStatus:3];
    }
    TTLog(@"error --- post --- %@",error);
}

- (void)setIsHasHeaderRefresh:(BOOL)isHasHeaderRefresh {
    if (!isHasHeaderRefresh) {
        self.mj_header = nil;
    }else{
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(tt_requestData)];
    }
}

- (void)tt_requestData{
    if (_requestURL.length ==0) {
        TTLog(@"TablView:请输入下载网址");
        [self.mj_header endRefreshing];
        return;
    }
    if ([_parameter.allKeys containsObject:pageIndex]) {
        [self changeIndexWithStatus:1];
    }
    [self setupNetWorkParamter:_parameter isPullDown:YES];
}

- (void)tt_footerRefresh {
    [self changeIndexWithStatus:2];
    [self setupNetWorkParamter:_parameter isPullDown:NO];
}

/// 1:下拉  2:上拉  3:减一
- (void)changeIndexWithStatus:(NSInteger)Status {
    _pageNumber = [_parameter[pageIndex] integerValue];
    if (Status == 1) {
        _pageNumber = 1;
    }else if (Status == 2){
        _pageNumber ++;
    }else{
        _pageNumber --;
    }
    [_parameter setObject:[NSNumber numberWithInteger:_pageNumber] forKey:pageIndex];
}

- (void)tt_endRefrseh{
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
}

- (void)setParameter:(NSMutableDictionary *)parameter{
    if (_parameter) {
        [_parameter addEntriesFromDictionary:parameter];
        return;
    }
    _parameter = parameter.mutableCopy;
}

- (void)setRequestURL:(NSString *)requestURL{
    _requestURL = requestURL;
}

- (void)setRequestType:(kRequestType)requestType{
    _requestType = requestType;
}

- (void)setEmptyViewHeight:(CGFloat)emptyViewHeight{
    _emptyViewHeight = emptyViewHeight;
}

- (TTEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[TTEmptyView alloc]init];
        _emptyView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.tableHeaderView.frame.size.height- kNavBarHeight) ;
        _emptyView.backgroundColor = kClearColor;
    }
    return _emptyView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return self.canResponseMutiGesture;
}
@end


/***************************  以下是空白界面的View  **************************************************/
@interface TTEmptyView ()
@property (nonatomic ,strong) UILabel *hintLabel;
@property (nonatomic ,strong) UIImageView *imagesView;
@end
@implementation TTEmptyView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initEmptyView];
    }
    return self;
}

- (void)initEmptyView{
    [self addSubview:self.imagesView];
    
    self.hintLabel = [[UILabel alloc]init];
    [self addSubview:self.hintLabel];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).multipliedBy(0.6);
    }];

    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imagesView.mas_bottom).offset(IPHONE6_W(10));
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        [_imagesView sizeToFit];
        [_imagesView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _imagesView;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium15];
        [_hintLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.numberOfLines = 0;
    }
    return _hintLabel;
}

- (void)setImageName:(NSString *)imageName{
    self.imagesView.image = kGetImage(imageName);
}

- (void)setHintText:(NSString *)hintText{
    self.hintLabel.text = hintText;
}

- (void)setHintTextFont:(UIFont *)hintTextFont{
    self.hintLabel.font = hintTextFont;
}

- (void)setHintTextColor:(UIColor *)hintTextColor{
    self.hintLabel.textColor = hintTextColor;
}

- (void)setHintAttributedText:(NSAttributedString *)hintAttributedText{
    self.hintLabel.attributedText = hintAttributedText;
}

@end
