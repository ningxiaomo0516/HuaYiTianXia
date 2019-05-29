//
//  TXCharterSpellMachineView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXCharterSpellMachineView : UIView
/// 顶部View
@property (nonatomic, strong) UIView    *headerView;
/// 顶部View
@property (nonatomic, strong) UIView    *headerNavView;
/// 返回按钮
@property (nonatomic, strong) UIButton  *backButton;
/// 城市按钮
@property (nonatomic, strong) UILabel   *citylabel;
/// 向下箭头
@property (nonatomic, strong) UIImageView   *imagesCity;
/// 搜索View
@property (nonatomic, strong) UIView    *searchView;
/// 搜索图标
@property (nonatomic, strong) UIImageView    *searchImages;
/// 搜索文字
@property (nonatomic, strong) UILabel    *searchText;

@property (nonatomic, strong) UIView    *buttonView;
/// 空中巴士
@property (nonatomic, strong) UIButton  *airbusBtn;
/// 包机
@property (nonatomic, strong) UIButton  *charterMachinebtn;
/// 拼机
@property (nonatomic, strong) UIButton  *spellMachineBtn;

@end

NS_ASSUME_NONNULL_END
