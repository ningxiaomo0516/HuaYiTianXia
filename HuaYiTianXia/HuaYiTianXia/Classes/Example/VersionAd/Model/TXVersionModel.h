//
//  TXVersionModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TXVersionCellModel;
@interface TXVersionModel : NSObject
/// 现在版本
@property(nonatomic,copy)   NSString    *currentVersion;
/// 下载url
@property(nonatomic,copy)   NSString    *downloadUrl;
/// 类型
@property(nonatomic,assign) NSInteger   type;
/// 代码版本
@property(nonatomic,assign) NSInteger   codeVerison;
/// 是否强制更新
@property(nonatomic,assign) BOOL        updateType;
/// 更新信息
@property(nonatomic,copy)NSString       *updateInfo;
@end

@interface TXVersionCellModel : NSObject

@property(nonatomic,copy)   NSString    *updateText;
@property(nonatomic,assign) float       cellheight;
@end

NS_ASSUME_NONNULL_END
