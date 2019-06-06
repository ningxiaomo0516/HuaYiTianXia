//
//  TXPaintView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPaintView.h"
#import "TXBezierPath.h"
@interface TXPaintView ()

@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *paths;

@end
@implementation TXPaintView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    for (UIBezierPath *path in self.paths) {
        [path.lineColor set];
        [path stroke];
    }
}

- (NSMutableArray<UIBezierPath *> *)paths {
    if (!_paths) {
        _paths = [[NSMutableArray alloc] init];
    }
    return _paths;
}

- (void)clear {
    [self.paths removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)undo {
    [self.paths removeLastObject];
    
    [self setNeedsDisplay];
}

- (void)erease{
    self.lineColor = [UIColor whiteColor];
}
#pragma mark - Handle Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint startPoint = [touch locationInView:touch.view];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    if (self.lineWidth != 0) {
        path.lineWidth = self.lineWidth;
    }
    if (self.lineColor) {
        path.lineColor = self.lineColor;
    }
    [path moveToPoint:startPoint];
    [self.paths addObject:path];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:touch.view];
    
    UIBezierPath *path = [self.paths lastObject];
    
    [path addLineToPoint:currentPoint];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
