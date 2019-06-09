//
//  MusicModel.h
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/11/7.
//  Copyright © 2018 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MusicModel : NSObject
//// 音乐id
@property (nonatomic, copy) NSString *kid;
/// 音乐名称
@property (nonatomic, copy) NSString *musicName;
/// 音乐URL
@property (nonatomic, copy) NSString *musicURL;
/// 音乐后缀
@property (nonatomic, copy) NSString *musicExt;
@end

NS_ASSUME_NONNULL_END
