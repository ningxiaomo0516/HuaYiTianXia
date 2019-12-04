//
//  TXMessageChildAdsViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/30.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMessageChildAdsViewController.h"

@interface TXMessageChildAdsViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation TXMessageChildAdsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.title = @"系统通知";
}

- (void) initView{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titlelabel];
    [self.scrollView addSubview:self.datelabel];
    [self.scrollView addSubview:self.subtitlelabel];
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.top.equalTo(@(IPHONE6_W(20)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-15));
    }];
    [self.datelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titlelabel);
        make.top.equalTo(self.titlelabel.mas_bottom).offset(5);
    }];
    [self.subtitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titlelabel);
        make.top.equalTo(self.datelabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-(kTabBarHeight));
    }];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = kClearColor;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+1);
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titlelabel;
}

- (UILabel *)subtitlelabel{
    if (!_subtitlelabel) {
        _subtitlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
    }
    return _subtitlelabel;
}

- (UILabel *)datelabel{
    if (!_datelabel) {
        _datelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium15];
    }
    return _datelabel;
}

@end
