//
//  TXMineTeamSectionView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/28.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMineTeamSectionView.h"

@implementation TXMineTeamSectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kTableViewInSectionColor;
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 27)];
        self.labelTitle.font = [UIFont systemFontOfSize:15];
        self.labelTitle.textColor = kColorWithRGB(51, 51, 51);
        self.labelTitle.textAlignment = NSTextAlignmentLeft;
        self.labelTitle.text = @"#";
        [self addSubview:self.labelTitle];
    }
    return self;
}

@end
