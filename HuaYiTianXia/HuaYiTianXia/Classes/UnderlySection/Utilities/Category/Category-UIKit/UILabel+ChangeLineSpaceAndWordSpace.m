//
//  UILabel+ChangeLineSpaceAndWordSpace.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@implementation UILabel (ChangeLineSpaceAndWordSpace)
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

+ (NSAttributedString *) changeIndentationSpaceForLabel:(NSString *)labelText spaceWidth:(CGFloat) spaceWidth{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    // 对齐方式
    paragraphStyle.alignment = NSTextAlignmentJustified;
    paragraphStyle.lineSpacing = 5.0;
    // 首行缩进
    paragraphStyle.firstLineHeadIndent = spaceWidth;
    // 头部缩进
    //        style.headIndent = 10.0f;
    // 尾部缩进
    //        style.tailIndent = -10.0f;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:labelText attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
    return attrText;
}

@end
