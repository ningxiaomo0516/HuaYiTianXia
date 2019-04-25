//
//  TXZhuanchuZhuanruViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXZhuanchuZhuanruViewController.h"
#import "TXEquityViewController.h"

@interface TXZhuanchuZhuanruViewController ()

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation TXZhuanchuZhuanruViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleArray.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {

    return self.titleArray[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    TXEquityViewController *viewController = [[TXEquityViewController alloc] init];
    viewController.title = self.titleArray[index];
    return viewController;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"转出记录",@"转入记录"];
    }
    return _titleArray;
}
@end
