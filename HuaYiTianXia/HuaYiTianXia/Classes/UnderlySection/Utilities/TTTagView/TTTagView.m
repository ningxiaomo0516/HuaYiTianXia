//
//  TTTagView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTTagView.h"

@implementation TTTagView
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    CGFloat marginX = 15;
    CGFloat marginY = 10;
    CGFloat height = 28;
    UIButton * markBtn;
    for (int i = 0; i < _dataArray.count; i++) {
        CGFloat width =  [self sizeWithString:_dataArray[i] maxWidth:self.width maxFont:kFontSizeMedium12].width + 25;
        UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!markBtn) {
            tagBtn.frame = CGRectMake(marginX, marginY, width, height);
        }else{
            if (markBtn.frame.origin.x + markBtn.width + marginX + width + marginX > self.width) {
                tagBtn.frame = CGRectMake(marginX, markBtn.y + markBtn.height + marginY, width, height);
            }else{
                tagBtn.frame = CGRectMake(markBtn.x + markBtn.width + marginX, markBtn.y, width, height);
            }
        }
        [tagBtn setTitle:_dataArray[i] forState:UIControlStateNormal];
        tagBtn.titleLabel.font = kFontSizeMedium13;
        [tagBtn setTitleColor:kTextColor51 forState:UIControlStateNormal];
        [tagBtn setTitleColor:kTextColor51 forState:UIControlStateSelected];
        [tagBtn setBackgroundImage:imageColor(kTextColor227) forState:UIControlStateNormal];
        [tagBtn setBackgroundImage:imageColor(kTextColor227) forState:UIControlStateSelected];
        [self makeCornerRadius:3.0 borderColor:kTextColor227 layer:tagBtn.layer borderWidth:.5];
        markBtn = tagBtn;
        
        [tagBtn addTarget:self action:@selector(onClickTo:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:markBtn];
    }
    CGRect rect = self.frame;
    rect.size.height = markBtn.frame.origin.y + markBtn.frame.size.height + marginY;
    self.frame = rect;
}

//// 单选
- (void)onClickTo:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(handleSelectTag:)]) {
        if (!sender.isSelected) {
            self.selectBtn.selected = !self.selectBtn.selected;
//            self.selectBtn.backgroundColor = [UIColor clearColor];
//            [self.selectBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
            sender.selected = !sender.selected;
//            sender.backgroundColor = kThemeColor;
//            [sender setTitleColor:kWhiteColor forState:UIControlStateNormal];
            self.selectBtn = sender;
        }
        [self.delegate handleSelectTag:sender.titleLabel.text];
    }
}

//// 多选
/*- (void)onClickTo:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(handleSelectTag:)]) {
        sender.selected = !sender.selected;
        [self.delegate handleSelectTag:sender.titleLabel.text];
    }
}*/
/// 圆角设置
- (void)makeCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor layer:(CALayer *)layer borderWidth:(CGFloat)borderWidth{
    layer.cornerRadius = radius;
    layer.masksToBounds = YES;
    layer.borderColor = borderColor.CGColor;
    layer.borderWidth = borderWidth;
}

/**
 *  返回字符串所占用的尺寸
 *
 *  @param maxFont      字体
 *  @param maxWidth     最大宽度
 */
-(CGSize)sizeWithString:(NSString *)str maxWidth:(CGFloat)maxWidth maxFont:(UIFont *)maxFont{
    NSDictionary *attrs = @{NSFontAttributeName : maxFont};
    CGSize size = [str boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size;
}

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
//- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
//    NSDictionary *attrs = @{NSFontAttributeName : font};
//    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//}
@end
