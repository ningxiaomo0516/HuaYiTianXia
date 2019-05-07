//
//  TTEmptyBaseView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/7.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTEmptyBaseView.h"
@interface TTEmptyBaseView ()

@end
@implementation TTEmptyBaseView

#pragma mark - ------------------ Life Cycle ------------------
- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)prepare{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIView *view = self.superview;
    /// 不是UIView，不做操作
    if (view && [view isKindOfClass:[UIView class]]){
        self.width = view.width;
        self.height = view.height;
    }
    [self setupSubviews];
}

- (void)setupSubviews{
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    /// 不是UIView，不做操作
    if (newSuperview && ![newSuperview isKindOfClass:[UIView class]]) return;
    if (newSuperview) {
        self.width = newSuperview.width;
        self.height = newSuperview.height;
    }
}

#pragma mark - ------------------ 实例化 ------------------
+ (instancetype)emptyActionViewWithImage:(UIImage *)image titleText:(NSString *)titleText detailText:(NSString *)detailText btnTitleText:(NSString *)btnTitleText target:(id)target action:(SEL)action{
    TTEmptyBaseView *emptyView = [[self alloc] init];
    [emptyView creatEmptyViewWithImage:image imagesText:nil titleText:titleText detailText:detailText btnTitleText:btnTitleText target:target action:action btnClickBlock:nil];
    
    return emptyView;
}

+ (instancetype)emptyActionViewWithImage:(UIImage *)image titleText:(NSString *)titleText detailText:(NSString *)detailText btnTitleText:(NSString *)btnTitleText btnClickBlock:(TTActionTapBlock)btnClickBlock{
    TTEmptyBaseView *emptyView = [[self alloc] init];
    [emptyView creatEmptyViewWithImage:image imagesText:nil titleText:titleText detailText:detailText btnTitleText:btnTitleText target:nil action:nil btnClickBlock:btnClickBlock];
    
    return emptyView;
}

+ (instancetype)emptyActionViewWithImagesText:(NSString *)imagesText titleText:(NSString *)titleText detailText:(NSString *)detailText btnTitleText:(NSString *)btnTitleText target:(id)target action:(SEL)action{
    TTEmptyBaseView *emptyView = [[self alloc] init];
    [emptyView creatEmptyViewWithImage:nil imagesText:imagesText titleText:titleText detailText:detailText btnTitleText:btnTitleText target:target action:action btnClickBlock:nil];
    return emptyView;
}

+ (instancetype)emptyActionViewWithImagesText:(NSString *)imagesText titleText:(NSString *)titleText detailText:(NSString *)detailText btnTitleText:(NSString *)btnTitleText btnClickBlock:(TTActionTapBlock)btnClickBlock{
    TTEmptyBaseView *emptyView = [[self alloc] init];
    [emptyView creatEmptyViewWithImage:nil imagesText:imagesText titleText:titleText detailText:detailText btnTitleText:btnTitleText target:nil action:nil btnClickBlock:btnClickBlock];
    return emptyView;
}

+ (instancetype)emptyViewWithImage:(UIImage *)image titleText:(NSString *)titleText detailText:(NSString *)detailText{
    TTEmptyBaseView *emptyView = [[self alloc] init];
    [emptyView creatEmptyViewWithImage:image imagesText:nil titleText:titleText detailText:detailText btnTitleText:nil target:nil action:nil btnClickBlock:nil];
    return emptyView;
}

+ (instancetype)emptyViewWithImagesText:(NSString *)imagesText titleText:(NSString *)titleText detailText:(NSString *)detailText{
    TTEmptyBaseView *emptyView = [[self alloc] init];
    [emptyView creatEmptyViewWithImage:nil imagesText:imagesText titleText:titleText detailText:detailText btnTitleText:nil target:nil action:nil btnClickBlock:nil];
    return emptyView;
}

+ (instancetype)emptyViewWithCustomView:(UIView *)customView{
    TTEmptyBaseView *emptyView = [[self alloc] init];
    [emptyView creatEmptyViewWithCustomView:customView];
    return emptyView;
}

- (void)creatEmptyViewWithImage:(UIImage *)image imagesText:(NSString *)imagesText titleText:(NSString *)titleText detailText:(NSString *)detailText btnTitleText:(NSString *)btnTitleText target:(id)target action:(SEL)action btnClickBlock:(TTActionTapBlock)btnClickBlock{
    
    _image = image;
    _imagesText = imagesText;
    _titleText = titleText;
    _detailText = detailText;
    _btnTitleText = btnTitleText;
    _actionBtnTarget = target;
    _actionBtnAction = action;
    _btnClickBlock = btnClickBlock;
    
    //内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)];
        [_contentView addGestureRecognizer:tap];
    }
}

- (void)creatEmptyViewWithCustomView:(UIView *)customView{
    /// 内容物背景视图
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
    }
    
    if (!_customView) {
        [_contentView addSubview:customView];
    }
    _customView = customView;
}

#pragma mark - ------------------ Event Method ------------------
- (void)tapContentView:(UITapGestureRecognizer *)tap{
    if (_tapContentViewBlock) {
        _tapContentViewBlock();
    }
}

#pragma mark - ------------------ Setter ------------------
- (void)setImage:(UIImage *)image{
    _image = image;
    [self setNeedsLayout];
}

- (void)setImagesText:(NSString *)imagesText{
    _imagesText = imagesText;
    [self setNeedsLayout];
}

- (void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    [self setNeedsLayout];
}

- (void)setDetailText:(NSString *)detailText{
    _detailText = detailText;
    [self setNeedsLayout];
}

- (void)setBtnTitleText:(NSString *)btnTitleText{
    _btnTitleText = btnTitleText;
    [self setNeedsLayout];
}

@end
