//
//  TXAddTitleAddressView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/10.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^TXAddTitleAddressViewBlock) (NSString *areaText,NSString *parentId);
@interface TXAddTitleAddressView : UIView
/// 默认View的高度
@property(nonatomic,assign) CGFloat     defaultHeight;
@property(nonatomic,assign) CGFloat     titleScrollViewH;
@property(nonatomic,copy)   NSString    *title;
@property(nonatomic,strong) UIView      *addAddressView;

- (UIView *) initAddressView;
- (void) addAnimate;

//定义一个block
@property (nonatomic, copy) TXAddTitleAddressViewBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
