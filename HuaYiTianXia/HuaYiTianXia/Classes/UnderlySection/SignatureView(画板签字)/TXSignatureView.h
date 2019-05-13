//
//  TXSignatureView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXSignatureView : UIView
/**
 *  画布
 */
{
    CGPoint _start;
    CGPoint _move;
    CGMutablePathRef _path;
    NSMutableArray *_pathArray;
    CGFloat _lineWidth;
    UIColor *_color;
}

@property (nonatomic,assign)CGFloat lineWidth;/**< 线宽 */

@property (nonatomic,strong)UIColor *color;/**< 线的颜色 */

@property (nonatomic,strong)NSMutableArray *pathArray;
@property(nonatomic,strong) UIView      *signatureView;
- (void) addAnimate;
- (UIView *) initSignatureView;
/**
 获取绘制的图片
 
 @return 绘制的图片
 */
-(UIImage*)getDrawingImg;

/**
 撤销
 */
-(void)undo;

/**
 清空
 */
-(void)clear;
@end

NS_ASSUME_NONNULL_END
