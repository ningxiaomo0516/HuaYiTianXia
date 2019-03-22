//
//  TXMembersBannerView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TXMembersBannerViewCallBlock)(NSInteger idx);

@interface TXMembersBannerView : UIView

- (void)setBannerImagesDidOnClickCallBlock:(TXMembersBannerViewCallBlock)block;
@end

NS_ASSUME_NONNULL_END
