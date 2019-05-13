//
//  TXSignatureView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXSignatureView.h"

@implementation TXSignatureView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _move = CGPointMake(0, 0);
        _start = CGPointMake(0, 0);
        _lineWidth = 2;
        _color = [UIColor redColor];
        _pathArray = [NSMutableArray array];
//        self.frame = CGRectMake(0, kScreenHeight/3, kScreenWidth, kScreenHeight - kScreenHeight/3);
    }
    return self;
}


- (UIView *)initSignatureView{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBtnAndcancelBtnClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //设置添加地址的View
    self.signatureView = [[UIView alloc] init];
    self.signatureView.frame = CGRectMake(0, kScreenHeight/3, kScreenWidth, kScreenHeight - kScreenHeight/3);
    self.signatureView.backgroundColor = kWhiteColor;
    [self addSubview:self.signatureView];
//    [self.signatureView addSubview:self];
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawPicture:context]; //画图
}

- (void)drawPicture:(CGContextRef)context {
    for (NSArray * attribute in _pathArray) {
        //将路径添加到上下文中
        CGPathRef pathRef = (__bridge CGPathRef)(attribute[0]);
        CGContextAddPath(context, pathRef);
        //设置上下文属性
        [attribute[1] setStroke];
        CGContextSetLineWidth(context, [attribute[2] floatValue]);
        //绘制线条
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    //创建路径
    _path = CGPathCreateMutable();
    NSArray *attributeArry = @[(__bridge id)(_path),_color,[NSNumber numberWithFloat:_lineWidth]];
    //路径及属性数组数组
    [_pathArray addObject:attributeArry];
    //起始点
    _start = [touch locationInView:self];
    CGPathMoveToPoint(_path, NULL,_start.x, _start.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //释放路径
    CGPathRelease(_path);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _move = [touch locationInView:self];
    //将点添加到路径上
    CGPathAddLineToPoint(_path, NULL, _move.x, _move.y);
    [self setNeedsDisplay];
}

/**
 获取签名图片
 
 @return image
 */
-(UIImage *)getDrawingImg{
    
    if (_pathArray.count) {
        UIGraphicsBeginImageContext(self.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIRectClip(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        [self.layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        return image;
    }
    return nil;
}

/**
 撤销
 */
-(void)undo
{
    [_pathArray removeLastObject];
    [self setNeedsDisplay];
}

/**
 清空
 */
-(void)clear
{
    [_pathArray removeAllObjects];
    [self setNeedsDisplay];
}


- (void)addAnimate{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.signatureView.frame = CGRectMake(0, kScreenHeight/3, kScreenWidth, kScreenHeight-kScreenHeight/3);
    }];
}

- (void)tapBtnAndcancelBtnClick{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.signatureView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

@end
