//
//  TTSortButton.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/15.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTSortButton : UIButton
/** 按钮文本 */
@property (nonatomic, copy) NSString *buttonTitle;
/** 是否是升序 */
@property (nonatomic, assign, readonly, getter=isAscending) BOOL ascending;
/** YES：升序 NO:降序 */
@property (nonatomic, assign) BOOL hasAscending;
@end

NS_ASSUME_NONNULL_END
