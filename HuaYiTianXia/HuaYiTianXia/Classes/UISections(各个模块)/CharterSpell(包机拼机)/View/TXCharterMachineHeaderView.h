//
//  TXCharterMachineHeaderView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/31.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXCharterMachineHeaderView : UIView
/// 顶部View
@property (nonatomic, strong) UIView    *headerView;
/// 顶部Nav View
@property (nonatomic, strong) UIView    *headerNavView;
/// 返回按钮
@property (nonatomic, strong) UIButton  *backButton;
@property (nonatomic, strong) UILabel   *titlelabel;

@end

NS_ASSUME_NONNULL_END
