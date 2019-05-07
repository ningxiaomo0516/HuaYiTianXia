//
//  TTEmptyBaseView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/7.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 事件回调
typedef void (^TTActionTapBlock)(void);
@interface TTEmptyBaseView : UIView

/////////属性传递(可修改)
/* image 的优先级大于 imageStr，只有一个有效*/
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy) NSString *imagesText;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, copy) NSString *btnTitleText;

/////////属性传递 (只读)
@property (nonatomic,strong,readonly) UIView *contentView;
@property (nonatomic, weak, readonly) id actionBtnTarget;
@property (nonatomic,assign,readonly) SEL actionBtnAction;
@property (nonatomic, copy, readonly) TTActionTapBlock btnClickBlock;
@property (nonatomic,strong,readonly) UIView *customView;
/// emptyView内容区域点击事件
@property (nonatomic, copy) TTActionTapBlock tapContentViewBlock;


/// 初始化配置
- (void)prepare;

/// 重置Subviews
- (void)setupSubviews;


/**
 *  构造方法 - 创建emptyView
 *
 *  @param image        占位图片
 *  @param titleText    标题
 *  @param detailText   详细描述
 *  @param btnTitleText 按钮的名称
 *  @param target       响应的对象
 *  @param action       按钮点击事件
 *  @return 返回一个emptyView
 *  */
+ (instancetype)emptyActionViewWithImage:(UIImage *)image titleText:(NSString *)titleText detailText:(NSString *)detailText btnTitleText:(NSString *)btnTitleText target:(id)target action:(SEL)action;

/**
 *  构造方法 - 创建emptyView
 *
 *  @param image            占位图片
 *  @param titleText        占位描述
 *  @param detailText       详细描述
 *  @param btnTitleText     按钮的名称
 *  @param btnClickBlock    按钮点击事件回调
 *  @return 返回一个emptyView
 */
+ (instancetype)emptyActionViewWithImage:(UIImage *)image titleText:(NSString *)titleText detailText:(NSString *)detailText btnTitleText:(NSString *)btnTitleText btnClickBlock:(TTActionTapBlock)btnClickBlock;

/**
 *  构造方法 - 创建emptyView
 *
 *  @param imagesText   占位图片名称
 *  @param titleText    标题
 *  @param detailText   详细描述
 *  @param btnTitleText 按钮的名称
 *  @param target       响应的对象
 *  @param action       按钮点击事件
 *  @return 返回一个emptyView
 */
+ (instancetype)emptyActionViewWithImagesText:(NSString *)imagesText titleText:(NSString *)titleText detailText:(NSString *)detailText btnTitleText:(NSString *)btnTitleText target:(id)target action:(SEL)action;

/**
 *  构造方法 - 创建emptyView
 *
 *  @param imagesText       占位图片名称
 *  @param titleText        占位描述
 *  @param detailText       详细描述
 *  @param btnTitleText     按钮的名称
 *  @param btnClickBlock    按钮点击事件回调
 *  @return 返回一个emptyView
 */
+ (instancetype)emptyActionViewWithImagesText:(NSString *)imagesText titleText:(NSString *)titleText detailText:(NSString *)detailText btnTitleText:(NSString *)btnTitleText btnClickBlock:(TTActionTapBlock)btnClickBlock;

/**
 *  构造方法 - 创建emptyView
 *
 *  @param image            占位图片
 *  @param titleText        占位描述
 *  @param detailText       详细描述
 *  @return 返回一个没有点击事件的emptyView
 */
+ (instancetype)emptyViewWithImage:(UIImage *)image titleText:(NSString *)titleText detailText:(NSString *)detailText;

/**
 *  构造方法 - 创建emptyView
 *
 *  @param imagesText     占位图片名称
 *  @param titleText      占位描述
 *  @param detailText     详细描述
 *  @return 返回一个没有点击事件的emptyView
 */
+ (instancetype)emptyViewWithImagesText:(NSString *)imagesText titleText:(NSString *)titleText detailText:(NSString *)detailText;

/**
 *  构造方法 - 创建一个自定义的emptyView
 *
 *  @param customView 自定义view
 *  @return 返回一个自定义内容的emptyView
 */
+ (instancetype)emptyViewWithCustomView:(UIView *)customView;

@end

NS_ASSUME_NONNULL_END
