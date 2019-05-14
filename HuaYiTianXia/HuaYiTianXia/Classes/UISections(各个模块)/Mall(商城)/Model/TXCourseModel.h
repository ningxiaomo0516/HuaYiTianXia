//
//  TXCourseModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface Flightmodels : NSObject
/// 机型
@property (nonatomic, copy) NSString *modelName;
/// 课程ID
@property (nonatomic, copy) NSString *kid;
@end

@interface FlightCourseModel : NSObject
/// 课程ID
@property (nonatomic, copy) NSString *kid;
/// 课程名称
@property (nonatomic, copy) NSString *courseTitle;
/// 实践培训时间
@property (nonatomic, copy) NSString *theoryTime;
/// 理论培训时间
@property (nonatomic, copy) NSString *practiceTime;
/// 培训周期
@property (nonatomic, copy) NSString *cycle;

/// 培训周期
@property (nonatomic, copy) NSString *courseSynopsis;
/// 费用
@property (nonatomic, copy) NSString *money;
/// 单位
@property (nonatomic, copy) NSString *unit;
/// 课程----飞机集合
@property (nonatomic, strong) NSMutableArray<Flightmodels *> *flightmodels;

@end

@interface CourseListModel : NSObject
/// 当前页
@property (nonatomic, copy) NSString *kid;
/// 培训标题
@property (nonatomic, copy) NSString *title;
/// 是否热门 0:不是热门 1:热门
@property (nonatomic, assign) NSInteger hot;
/// records 课程集合
@property (nonatomic, strong) NSMutableArray<FlightCourseModel *> *flightcourse;
@end

@interface CourseDataModel : NSObject
/// 当前页
@property (nonatomic, assign) NSInteger current;
/// 总页数
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger searchCount;
/// 每页条数
@property (nonatomic, assign) NSInteger size;
/// 总条数
@property (nonatomic, assign) NSInteger total;
/// records 新闻列表集合
@property (nonatomic, strong) NSMutableArray<CourseListModel *> *list;
@end

@interface TXCourseModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) CourseDataModel *data;
@end

NS_ASSUME_NONNULL_END
