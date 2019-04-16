//
//  TTGuidePagesViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/16.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTGuidePagesViewController.h"
#import "TXLoginViewController.h"
#define IMG_NUMBER 3

@interface TTGuidePagesViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)UIScrollView *scrollView;
@end

@implementation TTGuidePagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNewFeatureImgs];
}
//隐藏状态栏
/** 隐藏状态栏*/
- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)createNewFeatureImgs{
    //数据源
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.scrollView];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * IMG_NUMBER, 0);
    CGFloat w = self.scrollView.frame.size.width;
    CGFloat h = self.scrollView.frame.size.height;
    for (int i = 0; i < IMG_NUMBER; i++) {
        NSString *imgName = [NSString stringWithFormat:@"c12_yindaoye1%d",i+1];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(w * i, 0, w, h)];
        imgView.image = [UIImage imageNamed:imgName];
        imgView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imgView];
        if (i == IMG_NUMBER - 1) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth*0.9, kScreenHeight*0.5)];
            btn.backgroundColor = [UIColor redColor];
            [imgView addSubview:btn];
            CGSize size = btn.frame.size;
            btn.frame = CGRectMake(0, 0, size.width, size.height);
            btn.center = (CGPoint){CGRectGetWidth(imgView.frame) * 0.5, CGRectGetHeight(imgView.frame) * 0.85};
            [btn addTarget:self action:@selector(showRoot) forControlEvents:UIControlEventAllEvents];
        }
    }
}

/** 显示主页面*/
- (void)showRoot{
    TXLoginViewController * LoginVC = [[TXLoginViewController alloc]init];
    [self presentViewController:LoginVC animated:YES completion:nil];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x/kScreenWidth;
    self.pageControl.currentPage = currentPage;
}

@end
