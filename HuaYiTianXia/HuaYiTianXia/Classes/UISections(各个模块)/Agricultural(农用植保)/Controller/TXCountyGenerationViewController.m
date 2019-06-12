//
//  TXCountyGenerationViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/12.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXCountyGenerationViewController.h"

@interface TXCountyGenerationViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) UIScrollView  *scrollView;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UILabel       *subtitleLabel;
@property (strong, nonatomic) UIView        *headerView;
@property (strong, nonatomic) UIView        *footerView;
@property (strong, nonatomic) UIImageView   *imagesView;
@property (strong, nonatomic) UILabel       *tipslabel;

@end

@implementation TXCountyGenerationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    self.titleLabel.text = @"一县一代理独家经营";
    self.subtitleLabel.text = @"农用科技化、现代化";
    self.tipslabel.text = @"备注：选择区域代表市场会员所在的地区，同时代表子公司开设地区。";
    self.imagesView.image = kGetImage(@"区域划分");
//    NSArray *imgArray = @[@"华东",@"华中",@"西北",@"东北"];
//    NSArray *imgArrays = @[@"华南",@"华北",@"西南"];
    UIButton *btn1 = [self createWithButton:@"华东"];
    UIButton *btn2 = [self createWithButton:@"华中"];
    UIButton *btn3 = [self createWithButton:@"西北"];
    UIButton *btn4 = [self createWithButton:@"东北"];
    UIButton *btn5 = [self createWithButton:@"华南"];
    UIButton *btn6 = [self createWithButton:@"华北"];
    UIButton *btn7 = [self createWithButton:@"西南"];
    NSArray *btnArray = @[btn1,btn2,btn3,btn4,btn5,btn6,btn7];
    for (int i=0; i<btnArray.count; i++) {
        [self.headerView addSubview:btnArray[i]];
    }
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn2.mas_left).offset(IPHONE6_W(-10));
        make.centerY.equalTo(btn2);
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).offset(IPHONE6_W(-5));
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(21);
    }];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(IPHONE6_W(5));
        make.centerY.equalTo(btn2);
    }];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn3.mas_right).offset(IPHONE6_W(10));
        make.centerY.equalTo(btn2);
    }];
    
    [btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn6);
        make.right.equalTo(btn6.mas_left).offset(IPHONE6_W(-10));
    }];
    [btn6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(btn2.mas_bottom).offset(IPHONE6_W(-15));
    }];
    [btn7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn6);
        make.left.equalTo(btn6.mas_right).offset(IPHONE6_W(10));
    }];
}

- (void) initView{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.footerView];
    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.subtitleLabel];
    [self.footerView addSubview:self.imagesView];
    [self.footerView addSubview:self.tipslabel];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(IPHONE6_W(265)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.equalTo(@(IPHONE6_W(20)));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE6_W(10));
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).offset(10);
        make.height.equalTo(@(IPHONE6_W(335)));
    }];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(IPHONE6_W(17)));
        make.left.equalTo(@(IPHONE6_W(15)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-15));
    }];
    [self.tipslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagesView.mas_bottom).offset(IPHONE6_W(12));
        make.right.left.equalTo(self.imagesView);
    }];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = kTextColor244;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+1);
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _headerView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _footerView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kThemeColorHex font:kFontSizeMedium21];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _subtitleLabel;
}

- (UILabel *)tipslabel{
    if (!_tipslabel) {
        _tipslabel = [UILabel lz_labelWithTitle:@"" color:kThemeColorHex font:kFontSizeMedium12];
    }
    return _tipslabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UIButton *) createWithButton:(NSString *) imagesName{
    UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
    [sender setImage:kGetImage(imagesName) forState:UIControlStateNormal];
    return sender;
}
@end
