//
//  TXMallBannerCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXMallBannerCollectionViewCell.h"

#import "TYPageControl.h"
#import "TYCyclePagerView.h"
#import "TXMineBannerCollectionViewCell.h"

static NSString* reuseIdentifiers = @"TXMineBannerCollectionViewCell";

@interface TXMallBannerCollectionViewCell()<TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>

@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, copy) TXMallBannerCollectionViewCellCallBlock callBlock;

@end

@implementation TXMallBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)setBannerImagesDidOnClickCallBlock:(TXMallBannerCollectionViewCellCallBlock)block{
    self.callBlock = block;
}

- (void)setBannerArray:(NSMutableArray *)bannerArray{
    _bannerArray = bannerArray;
    [self initView];
}


- (void) initView{
    [self addPagerView];
    if (self.bannerArray.count>1) {
        self.pagerView.autoScrollInterval = 3;//自动轮播时间
    }
    self.pageControl.numberOfPages = self.bannerArray.count;
    [self.pagerView reloadData];
}

- (void)addPagerView {
    
    [self addSubview:self.pagerView];
    [self addPageControl];
//    [self.pagerView lz_setCornerRadius:3.0];
    
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.equalTo(self);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pagerView.mas_bottom).offset(-15);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.bannerArray.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TXMineBannerCollectionViewCell *tools = [pagerView dequeueReusableCellWithReuseIdentifier:reuseIdentifiers forIndex:index];
    tools.bannerModel = self.bannerArray[index];
    return tools;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSpacing = 0.0;//间距
    layout.itemVerticalCenter = YES;
    layout.minimumAlpha = 0.3;
    return layout;
}


- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    _pageControl.currentPage = toIndex;
    //[_pageControl setCurrentPage:newIndex animate:YES];
    //    TTLog(@"%ld ->  %ld",fromIndex,toIndex);
}

- (TYCyclePagerView *)pagerView{
    if (!_pagerView) {
        _pagerView = [[TYCyclePagerView alloc]  init];
        [_pagerView registerClass:[TXMineBannerCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifiers];
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
        _pagerView.isInfiniteLoop = YES;//是否回到第一页
        _pagerView.autoScrollInterval = 3;//自动轮播时间
    }
    return _pagerView;
}

- (void)addPageControl {
    TYPageControl *pageControl = [[TYPageControl alloc]init];
    //pageControl.numberOfPages = _datas.count;
    pageControl.currentPageIndicatorSize = CGSizeMake(6, 6);
    pageControl.pageIndicatorSize = CGSizeMake(6, 6);
    pageControl.currentPageIndicatorTintColor = kWhiteColor;
    pageControl.pageIndicatorTintColor = [kWhiteColor colorWithAlphaComponent:0.5];
    //    pageControl.pageIndicatorImage = kGetImage(@"live_gunlun_nor");
    //    pageControl.currentPageIndicatorImage = kGetImage(@"live_gunlun_press");
    //    pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    //    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [pageControl addTarget:self action:@selector(pageControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];
    [_pagerView addSubview:pageControl];
    _pageControl = pageControl;
}
@end
