//
//  SCCustomMarginLabel.h
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/7/13.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

//可以简易设置文字内边距的EdgeInsetsLabel

/**
 *  设置lable间距
 */
@interface SCCustomMarginLabel : UILabel
@property (nonatomic, assign) UIEdgeInsets edgeInsets; // 控制字体与控件边界的间隙
@end
