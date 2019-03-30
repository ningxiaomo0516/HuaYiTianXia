//
//  TXGeneralModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/19.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXGeneralModel : NSObject
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* imageText;
@property(nonatomic, copy)NSString* showClass;
@property(nonatomic, assign)NSInteger index;


/// 消息提示
@property(nonatomic, copy)NSString* message;
/// 错误Code
@property(nonatomic, assign)NSInteger errorcode;


@end

NS_ASSUME_NONNULL_END
