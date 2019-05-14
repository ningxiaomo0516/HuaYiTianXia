//
//  TXCourseChildModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXCourseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface CourseChildModel : NSObject
@property (nonatomic, copy) NSString *kid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *deposit;
/// banner 集合
@property (nonatomic, strong) NSMutableArray<NewsBannerModel *> *banners;
@property (nonatomic, strong) NSMutableArray<FlightCourseModel *> *flightcourse;
@end

@interface TXCourseChildModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) CourseChildModel *data;
@end

NS_ASSUME_NONNULL_END
