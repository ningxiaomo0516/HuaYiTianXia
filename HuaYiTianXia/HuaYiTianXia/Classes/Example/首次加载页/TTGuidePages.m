//
//  TTGuidePages.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTGuidePages.h"

@interface TTGuidePages () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation TTGuidePages

// init
- (instancetype)init{
    return [self initWithImageArray:nil completion:nil];
}

// init with imageDatas and completion
- (instancetype)initWithImageArray:(NSArray *)imageArray completion:(void (^)(void))buttonAction{
    self = [super init];
    if (self){
        [self initView];
        [self setImageArray:imageArray];
        _buttonAction = buttonAction;
        [self initContentView];
    }
    return self;
}

//基础视图初始化
- (void)initView{
    // init view
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    // init scrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.frame = CGRectMake(0, 0, self.width, self.height);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    // init pageControl
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.frame = CGRectMake(0, self.height - kiPhoneX_B(30), self.width, 10);
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_pageControl];
    
    // init button
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
}

//指定数据后，初始化显示内容
- (void)initContentView{
    if (self.imageArray.count) {
        _pageControl.numberOfPages = self.imageArray.count;
        _scrollView.contentSize = CGSizeMake(self.width * self.imageArray.count, self.height);
        for (int i = 0; i < self.imageArray.count; i++) {
            TXGeneralModel *model = self.imageArray[i];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:kGetImage(model.imageText)];
            imgView.frame = CGRectMake(self.width * i, 0, self.width, self.height);
            [self.scrollView addSubview:imgView];
            
            if (i == self.imageArray.count - 1){
                _actionButton.frame = CGRectMake((self.width - 175) / 2, self.height - kiPhoneX_B(110), 175, 45);
                _actionButton.layer.cornerRadius = 5;
                _actionButton.layer.masksToBounds = YES;
                [_actionButton setTitle:@"进  入" forState:UIControlStateNormal];
                _actionButton.tintColor = [UIColor whiteColor];
                [_actionButton lz_setCornerRadius:5.0];
                [_actionButton setBorderColor:kWhiteColor];
                [_actionButton setBorderWidth:1.0];
                [_actionButton addTarget:self  action:@selector(enterButtonClick) forControlEvents:UIControlEventTouchUpInside];
                [imgView addSubview:_actionButton];
                //设置可以响应交互，UIImageView的默认值为NO
                imgView.userInteractionEnabled = YES;
            }
        }
    }
}

#pragma mark
#pragma mark Action
- (void)enterButtonClick {
    if (_buttonAction) {
        _buttonAction();
        // 初始化 ---和--- 获取登录成功或者注销之后的标识
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
//        NSString *LOGIN=[defaults objectForKey:@"isLoggedIn"];
//        if (![LOGIN isEqualToString:@"isLoggedIn"]) {
//            ZBLoginViewController *view = [ZBLoginViewController new];
//            YYNavigationController *contr = [[YYNavigationController alloc] initWithRootViewController:view];
//            AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//            [appDelegate.window.rootViewController  presentViewController:contr animated:YES completion:^{
//            }];
//        }
    }
}
#pragma mark
#pragma mark UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _pageControl.currentPage = (_scrollView.contentOffset.x + kScreenWidth / 2) / kScreenWidth;
}


- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
        NSArray *imagesArr = @[@"yindaoye1", @"yindaoye2",@"yindaoye3"];
        for (int j = 0; j < imagesArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.imageText = [imagesArr lz_safeObjectAtIndex:j];
            [_imageArray addObject:generalModel];
        }
    }
    return _imageArray;
}

@end
