//
//  TXPushMessageViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/24.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXPushMessageViewController.h"
#import "TXEquityViewController.h"

@interface TXPushMessageViewController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *showVCArray;

@end

@implementation TXPushMessageViewController

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
    NSString *className = self.showVCArray[index];
    id controller = [[NSClassFromString(className) alloc] init];
    return controller;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"推送消息",@"系统消息"];
    }
    return _titleArray;
}

- (NSArray *)showVCArray{
    if (!_showVCArray) {
        _showVCArray = @[@"TXPushViewController",@"TXSystemViewController"];
    }
    return _showVCArray;
}
@end
