//
//  TTAlertManager.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/3.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^TTAlertHandler)(BOOL isCancel);

@interface TTAlert : NSObject

/** 显示优先级 */
@property (nonatomic, readonly) NSInteger priority;
/** 标题 */
@property (nonatomic, readonly, copy) NSString *title;
/** 文本 */
@property (nonatomic, readonly, copy) NSString *message;
/** 点击回调 */
@property (nonatomic, readonly, copy) TTAlertHandler handler;

/** 延迟显示时间 */
@property (nonatomic) CGFloat delay;
/** 消失回调 */
@property (nonatomic, copy) dispatch_block_t didDismiss;

/** 指定初始化 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message priority:(NSInteger)priority handler:(TTAlertHandler)handler NS_DESIGNATED_INITIALIZER;

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message priority:(NSInteger)priority handler:(TTAlertHandler)handler;

/** 显示 */
- (void)show;

@end
NS_ASSUME_NONNULL_BEGIN

@interface TTAlertManager : NSObject
/** 单例 */
+ (instancetype)shareManager;

/** 向队列中添加弹窗 */
- (void)addAlert:(TTAlert *)alert;
- (void)addAlerts:(NSSet<TTAlert *> *)alerts;

/** 按优先级依次显示弹窗 */
- (void)showAlerts;
@end

NS_ASSUME_NONNULL_END
