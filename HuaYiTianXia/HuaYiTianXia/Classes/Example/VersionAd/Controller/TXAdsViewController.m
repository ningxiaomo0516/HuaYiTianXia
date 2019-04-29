//
//  TXAdsViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/17.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXAdsViewController.h"
#import "LZRootViewController.h"
#import "TXAdsModel.h"

@interface TXAdsViewController ()<UIViewControllerTransitioningDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UIButton    *skipButton;
@property (nonatomic,strong)UIImageView *bottomImageView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)NSTimer     *timer;
@property (nonatomic,assign)NSInteger   currentTime;//当前时间（几秒后跳过）
@property (nonatomic,assign)NSInteger   currentPage;//当前页数

@end

@implementation TXAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentTime = 3;
    self.currentPage = 0;
    [self setupUI];
    UIView *boxView = [UIView lz_viewWithColor:kColorWithRGB(254, 252, 252)];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:kGetImage(@"c18_启动页_无广告")];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.userInteractionEnabled = YES;
    self.bottomImageView = imageView;
    [self.view addSubview:boxView];
    [boxView addSubview:imageView];
    [boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@(IPHONE6_W(90)+kSafeAreaBottomHeight));
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(boxView);
        make.height.equalTo(@(IPHONE6_W(90)));
    }];
    [self startTimer];
}

- (void)setupUI{
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.skipButton];
    TTLog(@"self.adsArray.count -- %ld",self.adsArray.count);
    for (NSInteger i = 0; i < self.adsArray.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
        TXAdsModel * model = [self.adsArray lz_safeObjectAtIndex:i];
        TTLog(@"model.imageUrl -- %@",model.imageUrl);
        [imgView sc_setImageWithUrlString:model.imageUrl placeholderImage:[UIImage imageNamed:@"guide_img_banner"] isAvatar:false];
        imgView.tag = 1150 + i;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickSkipUrl:)]];
        [self.scrollView addSubview:imgView];
    }
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
        //        make.bottom.equalTo(self.bottomImageView.mas_top);
    }];
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(44);
        make.height.equalTo(@(20));
        make.width.equalTo(@(62));
    }];
}

- (void)btnClickSkipUrl:(UIImageView *)imageView{
    NSInteger index = imageView.tag -  1150;
    TXAdsModel * model = [self.adsArray lz_safeObjectAtIndex:index];
    NSString * url = model.jumpUrl;
}

//跳过事件
- (void)skipBtnClick{
    [self setMainViewController];
}

//设置主页界面
- (void)setMainViewController{
    [self stopTimer];
    [self dismissViewControllerAnimated:NO completion:^{
        LZRootViewController * rootVC = [[LZRootViewController alloc] init];
        kAppDelegate.window.rootViewController = rootVC;
    }];
    //    __weak typeof(self) weakSelf = self;
    //    [self presentViewController:mainViewController animated:NO completion:^{
    
    //        [weakSelf removeFromParentViewController];
    //        [weakSelf.scrollView removeFromSuperview];
    //        weakSelf.scrollView = nil;
    //        [weakSelf.bottomImageView removeFromSuperview];
    //        [weakSelf.skipButton removeFromSuperview];
    //        weakSelf.bottomImageView = nil;
    //        weakSelf.skipButton = nil;
    //    }];
}

#pragma mark -- Timer
- (void)startTimer{
    self.timer =[NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerSelector) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timerSelector{
    self.currentTime = self.currentTime - 1;
    if (self.currentTime == 0) {
        if (self.currentPage >= self.adsArray.count - 1) {
            [self setMainViewController];
            return ;
        }
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth *(self.currentPage + 1), 0) animated:YES];
        self.currentTime = 3;
        self.currentPage = self.currentPage + 1;
    }
    [self.skipButton setTitle:[NSString stringWithFormat:@"%lds 跳过",(long)self.currentTime] forState:UIControlStateNormal];
}

#pragma mark -- getter,setter
- (UIButton *)skipButton{
    if (!_skipButton) {
        _skipButton = [[UIButton alloc] init];
        [_skipButton setTitle:@"3s 跳过" forState:UIControlStateNormal];
        _skipButton.titleLabel.font = kFontSizeMedium12;
        [_skipButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _skipButton.backgroundColor = [UIColor lz_colorWithHex:0x000000];
        [_skipButton addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _skipButton.layer.cornerRadius = 10;
    }
    return _skipButton;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = true;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.contentSize = CGSizeMake(kScreenWidth * self.adsArray.count, 0);
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

#pragma make -- scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.currentPage = index;
    self.currentTime = 3;
    [self.skipButton setTitle:[NSString stringWithFormat:@"%lds 跳过",(long)self.currentTime] forState:UIControlStateNormal];
}

- (void)dealloc{
    [self stopTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
