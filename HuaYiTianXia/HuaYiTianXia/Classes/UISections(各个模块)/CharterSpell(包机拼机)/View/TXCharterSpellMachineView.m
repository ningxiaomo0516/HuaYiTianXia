//
//  TXCharterSpellMachineView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/29.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXCharterSpellMachineView.h"

@implementation TXCharterSpellMachineView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void) initView{
    self.citylabel.text = [kUserDefaults objectForKey:@"city"];
    [self addSubview:self.headerView];
    [self addSubview:self.buttonView];
    [self addSubview:self.headerNavView];
    
    [self.headerNavView addSubview:self.backButton];
    [self.headerNavView addSubview:self.citylabel];
    [self.headerNavView addSubview:self.imagesCity];
    [self.headerNavView addSubview:self.searchView];
    
    [self.searchView addSubview:self.searchImages];
    [self.searchView addSubview:self.searchText];
    
    [self.buttonView addSubview:self.airbusBtn];
    [self.buttonView addSubview:self.charterMachinebtn];
    [self.buttonView addSubview:self.spellMachineBtn];
    
    [self.searchView lz_setCornerRadius:15.0];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(kNavBarHeight));
    }];
    
    [self.headerNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.headerView);
        make.height.equalTo(@(kNavBarHeight-kSafeAreaBottomHeight));
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(30));
        make.left.equalTo(self.backButton.mas_right);
        make.right.equalTo(self.citylabel.mas_left).offset(-20);
        make.centerY.equalTo(self.headerNavView);
    }];
    
    [self.searchImages mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchView.mas_left).offset(10);
        make.centerY.equalTo(self.searchView);
    }];
    
    [self.searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchImages.mas_right).offset(5);
        make.centerY.equalTo(self.searchView);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerNavView);
        make.width.equalTo(self.headerNavView.mas_height);
        make.top.bottom.equalTo(self.headerNavView);
    }];
    
    [self.citylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imagesCity.mas_left).offset(-5);
        make.top.bottom.equalTo(self.headerNavView);
    }];
    
    [self.imagesCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerNavView.mas_right).offset(-15);
        make.centerY.equalTo(self.headerNavView);
    }];
    
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@(IPHONE6_W(150)));
    }];
    
    
    [self.charterMachinebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.buttonView);
    }];
    [self.airbusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buttonView);
        make.centerX.equalTo(self.buttonView).offset(-(self.width/3));
    }];
    [self.spellMachineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.buttonView);
        make.centerX.equalTo(self.buttonView).offset(self.width/3);
    }];
}

- (UIButton *)airbusBtn{
    if (!_airbusBtn) {
        _airbusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_airbusBtn setImage:kGetImage(@"lv28_btn_空中巴士") forState:UIControlStateNormal];
    }
    return _airbusBtn;
}

- (UIButton *)charterMachinebtn{
    if (!_charterMachinebtn) {
        _charterMachinebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_charterMachinebtn setImage:kGetImage(@"lv28_btn_包机") forState:UIControlStateNormal];
    }
    return _charterMachinebtn;
}

- (UIButton *)spellMachineBtn{
    if (!_spellMachineBtn) {
        _spellMachineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_spellMachineBtn setImage:kGetImage(@"lv28_btn_拼机") forState:UIControlStateNormal];
    }
    return _spellMachineBtn;
}

- (UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _buttonView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _headerView;
}

- (UIView *)headerNavView{
    if (!_headerNavView) {
        _headerNavView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _headerNavView;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:kGetImage(@"all_btn_back_grey") forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UILabel *)citylabel{
    if (!_citylabel) {
        _citylabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium14];
        _citylabel.highlighted = YES;
    }
    return _citylabel;
}

- (UIImageView *)imagesCity{
    if (!_imagesCity) {
        _imagesCity = [[UIImageView alloc] init];
        _imagesCity.image = kGetImage(@"lv28_btn_down");
    }
    return _imagesCity;
}

- (UIView *)searchView{
    if (!_searchView) {
        _searchView = [UIView lz_viewWithColor:kTextColor238];
    }
    return _searchView;
}

- (UIImageView *)searchImages{
    if (!_searchImages) {
        _searchImages = [[UIImageView alloc] init];
        _searchImages.image = kGetImage(@"lv28_btn_搜索图标");
    }
    return _searchImages;
}

- (UILabel *)searchText{
    if (!_searchText) {
        _searchText = [UILabel lz_labelWithTitle:@"" color:kTextColor204 font:kFontSizeMedium13];
        _searchText.text = @"筛选查看更多信息";
    }
    return _searchText;
}
@end
