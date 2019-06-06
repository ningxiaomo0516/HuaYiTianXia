//
//  TXBezierPath.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/5.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXBezierPath.h"
#import <objc/runtime.h>

static const void *LineColorKey = &LineColorKey;
@implementation UIBezierPath (TXBezierPath)
@dynamic lineColor;

- (instancetype)init {
    if (self = [super init]) {
        self.lineColor = [UIColor whiteColor];
        self.lineWidth = 5.0f;
    }
    return self;
}

- (void)setLineColor:(UIColor *)lineColor {
    objc_setAssociatedObject(self, LineColorKey, lineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)lineColor {
    return objc_getAssociatedObject(self, LineColorKey);
}
@end
