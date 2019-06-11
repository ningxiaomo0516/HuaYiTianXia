//
//  SCLoadFailedView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "SCLoadFailedView.h"
@interface SCLoadFailedView ()
@property (nonatomic, strong) UIImageView   *imagesView;
@property (nonatomic, strong) UILabel       *tipsLabel;
@property (nonatomic, strong) UIButton      *reminderBtn;
@end
@implementation SCLoadFailedView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName labelText:(NSString *)labelText{
    self = [super initWithFrame:frame];
    if (self) {
        if (frame.size.height!=260) {
            frame.size.height=260;
        }
        self.frame = frame;
        [self setupUI];
        if (imageName.length>0) {
            self.imagesView.image = kGetImage(imageName);
        }else{
            self.imagesView.image = kGetImage(@"c12_live_loadFailed");
        }
        if (labelText.length>0) {
            self.tipsLabel.text = labelText;
        }else{
            self.tipsLabel.text = @"网络出错了,请点击按钮重新加载";
        }
    }
    return self;
}

- (void) setupUI{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imagesView];
    [self addSubview:self.tipsLabel];
    [self addSubview:self.reminderBtn];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imagesView.mas_bottom).offset(15);
    }];
    [self.reminderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self);
        make.width.equalTo(@(self.width/16*9));
        make.height.equalTo(@(45));
    }];
}

- (void) reminderBtnClicked:(UIButton*) sender{
    self.reminderBlock();
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor170 font:kFontSizeMedium14];
    }
    return _tipsLabel;
}

- (UIButton *)reminderBtn{
    if (!_reminderBtn) {
        _reminderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reminderBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [Utils lz_setButtonWithBGImage:_reminderBtn isRadius:YES];
        [_reminderBtn addTarget:self action:@selector(reminderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reminderBtn;
}
@end
