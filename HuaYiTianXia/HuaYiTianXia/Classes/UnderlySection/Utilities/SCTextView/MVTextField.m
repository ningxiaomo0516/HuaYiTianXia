//
//  MVTextField.m
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/2/26.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import "MVTextField.h"

@implementation MVTextField


- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}


@end
