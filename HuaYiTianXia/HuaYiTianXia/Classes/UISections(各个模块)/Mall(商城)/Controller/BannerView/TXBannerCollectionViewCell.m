//
//  TXBannerCollectionViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/21.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXBannerCollectionViewCell.h"
#import "TYPageControl.h"
#import "TYCyclePagerView.h"

static NSString* reuseIdentifier = @"TTBannerViewCell";
@interface TXBannerCollectionViewCell()<TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>
@property (nonatomic, strong) TYCyclePagerView      *pagerView;
@property (nonatomic, strong) TYPageControl         *pageControl;
@property (nonatomic, copy)TTBannerViewCellCallBlock callBlock;
@end

@implementation TXBannerCollectionViewCell
/// 方块视图的缓存池标示
+ (NSString *)reuseIdentifier{
    static NSString *reuseIdentifier = @"TXBannerCollectionViewCell";
    return reuseIdentifier;
}

//获取方块视图对象
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    TXBannerCollectionViewCell *tools=[collectionView dequeueReusableCellWithReuseIdentifier:[TXBannerCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    return tools;
}

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

- (void)setBannerImagesDidOnClickCallBlock:(TTBannerViewCellCallBlock)block{
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
    //    [self.pagerView lz_setCornerRadius:3.0];
    
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.equalTo(self);
    }];
    
    /// 需要显示
    if (self.isPageControl) {
        [self addPageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.pagerView.mas_bottom).offset(-15);
            make.centerX.equalTo(self);
        }];
    }else{
        /// 显示数字
        
        //        TTLog(@" - -- 11111 ");
    }
}

#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.bannerArray.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    TTBannerViewCell *tools = [pagerView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndex:index];
    tools.bannerModel = self.bannerArray[index];
    tools.boxView.hidden = self.isPageControl;
    tools.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",index+1,(unsigned long)self.bannerArray.count];
    if (self.bannerArray.count == 1) {
        tools.countLabel.hidden = true;
    }
    return tools;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSpacing = 0.0;//间距
    layout.itemVerticalCenter = YES;
    layout.minimumAlpha = 0.3;
    layout.itemSize = CGSizeMake(self.frame.size.width,self.frame.size.height);
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
        [_pagerView registerClass:[TTBannerViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
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
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
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


@implementation TTBannerViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kClearColor;
        [self initView];
        self.titleLabel.text = @"100张电影票 请你看大片!";
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = kWhiteColor;
        [self initView];
    }
    return self;
}

- (void)setBannerModel:(NewsBannerModel *)bannerModel{
    _bannerModel = bannerModel;
    NSString *imageURL = @"";
    if (kStringIsEmpty(bannerModel.img)) {
        imageURL = bannerModel.imageText;
    }else{
        imageURL = bannerModel.img;
    }
    //    tools.imagesView.image = kGetImage(@"base_deprecated_activity");
    [self.imagesView sd_setImageWithURL:kGetImageURL(imageURL)
                       placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    if (bannerModel.isBannerTitle) {
        self.titleLabel.text = bannerModel.title;
    }else{
        self.titleLabel.text = @"";
    }
}

- (void) initView {
    [self.contentView addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.contentView addSubview:self.boxView];
    [self.boxView addSubview:self.imagesViewBottom];
    [self.boxView addSubview:self.titleLabel];
    [self.boxView addSubview:self.countLabel];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@(40));
    }];
    [self.imagesViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.boxView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.centerY.equalTo(self.boxView);
        make.right.equalTo(self.countLabel.mas_left);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.boxView.mas_right).offset(-15);
        make.centerY.equalTo(self.boxView);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        //        _imagesView.contentMode = UIViewContentModeScaleAspectFit;;
        //        _imagesView.clipsToBounds = YES;
    }
    return _imagesView;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.backgroundColor = kClearColor;
        _boxView.hidden = YES;
    }
    return _boxView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kWhiteColor;
        _titleLabel.font = kFontSizeMedium15;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIImageView *)imagesViewBottom{
    if (!_imagesViewBottom) {
        _imagesViewBottom = [[UIImageView alloc] init];
        _imagesViewBottom.image = kGetImage(@"live_banner_bottom");
    }
    return _imagesViewBottom;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = kWhiteColor;
        _countLabel.font = kFontSizeMedium12;
        _countLabel.numberOfLines = 1;
        _countLabel.textAlignment = NSTextAlignmentRight;
        [_countLabel sizeToFit];
    }
    return _countLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
@end
