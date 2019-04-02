//
//  SCUploadImageModel.h
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/8/1.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UploadImageModel;
@interface SCUploadImageModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
/// 上传的图片数据
@property (nonatomic, strong) NSMutableArray<UploadImageModel *> *data;

@end

@interface UploadImageModel : NSObject

/// config
@property (nonatomic, copy) NSString *index;
/// title
@property (nonatomic, copy) NSString *title;
/// URL
@property (nonatomic, copy) NSString *imageURL;

@end

