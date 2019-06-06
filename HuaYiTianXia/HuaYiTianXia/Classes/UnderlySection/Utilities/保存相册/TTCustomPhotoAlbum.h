//
//  TTCustomPhotoAlbum.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/6.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTCustomPhotoAlbum : NSObject
+ (instancetype)shareInstance;
- (void)saveToNewThumb:(nonnull UIImage *)image;
- (void)showAlertMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
