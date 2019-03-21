//
//  TXMainHeaderView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMainHeaderView.h"

@interface TXMainHeaderView ()

@property (nonatomic, strong) UIImageView *imagesView;
@property (nonatomic, strong) UILabel *titlesLabel;

@end

@implementation TXMainHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void) initView{
    [self addSubview:self.imagesView];
    [self addSubview:self.titlesLabel];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(kNavBarHeight));
    }];
    [self.titlesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(44));
        make.left.right.bottom.equalTo(self);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.image = kGetImage(@"main_header_bg");
    }
    return _imagesView;
}

- (UILabel *)titlesLabel{
    if (!_titlesLabel) {
        _titlesLabel = [UILabel lz_labelWithTitle:@"华翼天下" color:kWhiteColor fontSize:17.0];
    }
    return _titlesLabel;
}
@end
