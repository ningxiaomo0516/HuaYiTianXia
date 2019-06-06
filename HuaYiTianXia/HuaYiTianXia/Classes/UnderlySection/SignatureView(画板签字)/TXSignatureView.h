//
//  TXSignatureView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/5.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^SignatureViewBlock) (NSString *imageURL);
@interface TXSignatureView : UIView
//定义一个block
@property (nonatomic, copy) SignatureViewBlock completionHandler;



/// 总价
@property(nonatomic,strong) UILabel *priceLabel;
/// 协议
@property(nonatomic,strong) UILabel *termsLabel;
/// 日期时间
@property(nonatomic,strong) UILabel *datetimeLabel;
/// 清除按钮
@property(nonatomic,strong) UIButton *clearButton;
/// 撤销按钮
@property(nonatomic,strong) UIButton *revokeButton;
/// 同意按钮
@property(nonatomic,strong) UIButton *saveButton;
/// 关闭按钮
@property(nonatomic,strong) UIButton *closeButton;
@end

NS_ASSUME_NONNULL_END
