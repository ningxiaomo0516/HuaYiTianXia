//
//  SCBannerModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/21.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCBannerModel : NSObject
/// bannerID
@property (nonatomic, copy) NSString *kid;
/// 产品详情 banner 图片地址
@property (nonatomic, copy) NSString *imagesName;
/// banner 标题
@property (nonatomic, copy) NSString *titleText;
/// 是否需要显示 banner title yes 需要显示 no 不需要显示
@property (nonatomic, assign) BOOL isBannerTitle;
@end

NS_ASSUME_NONNULL_END
