//
//  TTSortButton.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/15.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTSortButton.h"

@interface TTSortButton ()
/** 文本label */
@property (nonatomic, strong) UILabel *tt_titleLabel;
/** 箭头imageView */
@property (nonatomic, strong) UIImageView *tt_imagesViewArrow;
@end

@implementation TTSortButton

#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI搭建
- (void)setupUI {
//    self.layer.borderColor = [UIColor blackColor].CGColor;
//    self.layer.borderWidth = 1;
    
    // 文本和图片的父view
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    contentView.userInteractionEnabled = NO;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.mas_equalTo(self);
        make.left.mas_greaterThanOrEqualTo(self).mas_offset(3);
        make.right.mas_lessThanOrEqualTo(self).mas_offset(-3);
    }];
    
    // 文本
    self.tt_titleLabel = [[UILabel alloc] init];
    [contentView addSubview:self.tt_titleLabel];
    self.tt_titleLabel.textColor = kTextColor51;
    self.tt_titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.tt_titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.tt_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_offset(0);
    }];
    
    // 图片
    self.tt_imagesViewArrow = [[UIImageView alloc] init];
    [contentView addSubview:self.tt_imagesViewArrow];
    self.tt_imagesViewArrow.image = [UIImage imageNamed:@"live_btn_默认"];// 默认图片
    [self.tt_imagesViewArrow mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.mas_equalTo(contentView);
        make.left.mas_equalTo(self.tt_titleLabel.mas_right).offset(5);
        make.right.mas_equalTo(contentView);
    }];
}

#pragma mark - 赋值选中状态
- (void)setSelected:(BOOL)selected {
    //// 注意：
    //// selected 表示你要赋值的状态
    //// super.selected 表示当前处于的状态
    if (selected) { // 即将设置成选中状态
        self.tt_titleLabel.textColor = HexString(@"#3994FA");
        if (super.selected) { // 如果原本就处于选中状态
            // 那么就切换筛选状态
            _ascending = !_ascending;
            if (_ascending) {
                // 升序
                self.tt_imagesViewArrow.image = self.hasAscending?kGetImage(@"live_btn_升序"):kGetImage(@"live_btn_降序");//[UIImage imageNamed:@"live_btn_升序"];
            } else {
                // 降序
                self.tt_imagesViewArrow.image = self.hasAscending?kGetImage(@"live_btn_降序"):kGetImage(@"live_btn_升序");//[UIImage imageNamed:@"live_btn_降序"];
            }
        } else { // 如果之前不是选中状态
            // 那么设置成选中的默认排序状态：降序
            _ascending = YES;
            self.tt_imagesViewArrow.image = self.hasAscending?kGetImage(@"live_btn_升序"):kGetImage(@"live_btn_降序");
        }
    } else { // 即将设置成非选中状态
        // 设置成非选中状态的图片(默认图片)
        self.tt_imagesViewArrow.image = [UIImage imageNamed:@"live_btn_默认"];
        self.tt_titleLabel.textColor = kTextColor51;
    }
    // 最后再赋值
    [super setSelected:selected];
}

#pragma mark - 赋值文本
- (void)setButtonTitle:(NSString *)buttonTitle{
    _buttonTitle = buttonTitle;
    self.tt_titleLabel.text = buttonTitle;
}

- (void)setHasAscending:(BOOL)hasAscending{
    _hasAscending = hasAscending;
}

@end
