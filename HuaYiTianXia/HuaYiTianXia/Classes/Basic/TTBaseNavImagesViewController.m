//
//  TTBaseNavImagesViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TTBaseNavImagesViewController.h"

@interface TTBaseNavImagesViewController ()

@end

@implementation TTBaseNavImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kViewColorNormal;
    self.lz_fullScreenPopGestureEnabled = NO;
    // 设置UINavigationBar的主题
    [self setupNavigationBarTheme];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = kViewColorNormal;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self tapGesture];
}

#pragma mark 给当前view添加识别手势
#pragma mark -- 当前tableView中带有输入框点击背景关闭键盘
- (void) addGesture:(UITableView *) tableView{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [tableView addGestureRecognizer:tapGesture];
    tapGesture.cancelsTouchesInView = NO;
}

- (void)tapGesture {
    [kKeyWindow endEditing:YES];
}
- (void) setupNavigationBarTheme {
    
    // 1.去掉背景图片和底部线条
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self.navigationController.navigationBar setBackgroundImage:[imageColor(kThemeColorHex) resizableImageWithCapInsets:UIEdgeInsetsMake(5, 1, 5, 1)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = kWhiteColor;
    //去掉导航栏下边的投影
    self.navigationController.navigationBar.shadowImage = [imageColor(kClearColor) resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    
    self.navigationController.navigationBar.barTintColor = kWhiteColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:kWhiteColor};
    self.navigationController.navigationBar.translucent = NO;// NavigationBar 是否透明
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    //设置Navigation Bar背景图片
    UIImage *title_bg = imageColor(kThemeColorHex);  //获取图片
    CGSize titleSize = self.navigationController.navigationBar.bounds.size;  //获取Navigation Bar的位置和大小
    title_bg = [Utils lz_scaleToSize:title_bg size:titleSize];//设置图片的大小与Navigation Bar相同
    [self.navigationController.navigationBar setBackgroundImage:title_bg forBarMetrics:UIBarMetricsDefault];  //设置背景

}

@end
