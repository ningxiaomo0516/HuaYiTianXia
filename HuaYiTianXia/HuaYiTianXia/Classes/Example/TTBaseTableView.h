//
//  TTBaseTableView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/8.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TTBaseTableView,TTEmptyView;
@protocol TTTableViewRequestDelegate <NSObject>
@required
/**
 *  返回请求到的数据
 *  @param tt_tableView 返回自己
 *  @param PullDown     返回bool 表明  YES:下拉刷新  NO:上拉加载
 *  @param result       返回的数据
 */
- (void)tt_tableView:(TTBaseTableView *)tt_tableView isPullDown:(BOOL)PullDown result:(id)result;

/**
 *  返回网络错误的状态
 *
 *  @param tt_tableView self
 *  @param error 错误error
 */
- (void)tt_tableView:(TTBaseTableView *)tt_tableView requestFailed:(NSError *)error;

@end

//// 定义TableView接口请求类型
typedef NS_ENUM(NSInteger, kRequestType){
    /// POST 请求
    kHttpPost = 0,
    /// GET 响应
    kHttpGet
};

@interface TTBaseTableView : UITableView<UIGestureRecognizerDelegate>

@property (assign,nonatomic) id<TTTableViewRequestDelegate> requestDelegate;

/// 获取tableView偏移量的Block(配合MCHoveringView使用的属性)
@property (nonatomic, copy) void(^scrollViewDidScroll)(UIScrollView * scrollView);
/// 是否同时响应多个手势 默认NO(配合MCHoveringView使用的属性)
@property (nonatomic, assign) BOOL canResponseMutiGesture;
/// 传递controller进来展示loadding状态只能是weak不会引用
@property (nonatomic, weak) UIViewController *tempVC;
/// 空白页、网络错误页  页面的内容可用此属性去更改
@property (nonatomic, strong) TTEmptyView *emptyView;
/// 空白页、网络错误页  页面的内容可用此属性去更改
@property (nonatomic, assign) CGFloat emptyViewHeight;
/// 是否有头部刷新  默认YES
@property (nonatomic, assign) BOOL isHasHeaderRefresh;
/// 获取总的item
@property (nonatomic , assign) NSInteger totalSize;
/// 请求的网址
@property (nonatomic , copy) NSString *requestURL;
/// 请求类型 0:POST 请求 1:GET 响应
@property (nonatomic, assign) kRequestType requestType;
/// 请求的参数
@property (nonatomic , strong) NSMutableDictionary *parameter;
/// 刷新 无下拉动作
- (void)tt_requestData;

/**
 *  开始下载任务  网络数据用此开始  本地数据则不用使用本方法
 *
 *  @param URLString  请求的网址
 *  @param parameter  携带的参数 （一定要把分页参数放在这里）
 *  @param tempVC         控制器
 */
- (void)setUpWithURLString:(NSString *)URLString parameter:(NSDictionary *)parameter tempVC:(UIViewController *)tempVC;


@end



#pragma mark -------- 以下是空白界面的View --------
@interface TTEmptyView : UIView

/// 占位图名称
@property (nonatomic ,copy) NSString *imageName;
/// 提示文字
@property (nonatomic ,copy) NSString *hintText;
/// 提示文字字体
@property (nonatomic ,strong) UIFont *hintTextFont;
/// 提示文字颜色
@property (nonatomic ,strong) UIColor *hintTextColor;
/// 提示文字富文本
@property (nonatomic ,strong) NSAttributedString *hintAttributedText;
@end

NS_ASSUME_NONNULL_END
