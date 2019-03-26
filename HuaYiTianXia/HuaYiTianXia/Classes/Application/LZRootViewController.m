//
//  LZRootViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/12.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZRootViewController.h"
//#import "UITabBar+SCBadge.h"
#import "TXLoginViewController.h"

@interface LZRootViewController ()<UITabBarControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong, nonnull)NSArray *tabArray;
@end

@implementation LZRootViewController

//APP生命周期中 只会执行一次
+ (void)initialize {
    // 默认字体颜色及选择字体颜色
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kTabBarColorNormal;
    
    
    NSMutableDictionary *selectedTextAttrs=[NSMutableDictionary dictionaryWithDictionary:textAttrs];
    selectedTextAttrs[NSForegroundColorAttributeName] = kTabBarColorSelected;
    
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    /// 设置TabBar背景颜色
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 添加所有子控制器
    [self addAllChildVc];
//    [self addObverser];
    self.delegate = self;
}

/**
 *  添加所有的子控制器
 */
- (void)addAllChildVc {
//    for (NSDictionary<NSString *, NSString *> *dicTab in self.arrayTab)
    for (int i=0; i<self.tabArray.count; i++) {
        NSDictionary *dicTab = self.tabArray[i];
        [self addChildVc:dicTab[@"controllerName"]
                   title:dicTab[@"title"]
                   image:dicTab[@"imageName"]
           selectedImage:dicTab[@"imageSelectName"]
                     tag:i];
    }
}

- (void) setTabBarItemTextColor:(UIViewController *)childVc{
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kTabBarColorNormal;
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    
    selectTextAttrs[NSForegroundColorAttributeName] = kTabBarColorSelected;
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
}

#pragma mark - private methods 私有方法
/**
 *  1.添加一个子控制器
 *
 *  @param childName            子控制器名称
 *  @param title                标题
 *  @param normalImageNamed     图片
 *  @param selectedImageName    选中的图片
 *  @param tag                  当前tabbar下标
 */
- (void)addChildVc:(NSString *)childName title:(NSString *)title image:(NSString *)normalImageNamed selectedImage:(NSString *)selectedImageName tag:(NSInteger)tag{
    // 1.设置子控制器的默认设置
    UIViewController *childVc = [NSClassFromString(childName) new];
    childVc.title = title; // 同时设置tabbar和navigationBar的文字(可以根据需要单独设置)
    childVc.tabBarItem.title = title;
    [childVc.view setBackgroundColor:kWhiteColor];
    
    // 2.设置子控制器的图片(默认图片)
    childVc.tabBarItem.image = [[UIImage imageNamed:normalImageNamed] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置选中的图标(声明显示图片的原始式样 不要渲染)
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 3.设置文字的样式
    [self setTabBarItemTextColor:childVc];
    
    // 4.先给外面传进来的小控制器 包装 一个导航控制器
    LZNavigationController *navigation = [[LZNavigationController alloc] initWithRootViewController:childVc];
    navigation.isFullScreenPopGestureEnabled = YES;
    navigation.tabBarItem.tag = tag;
    // 5.添加为子控制器
    [self addChildViewController:navigation];
}

#pragma mark- UITabBarControllerDelegate
/**
 *  点击Item时调用
 *
 *  @param tabBarController 当前tabbar控制器
 *  @param viewController   将要点击的目标控制器
 */
- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    TTLog(@"tabBarController.selectedIndex --- %lu",(unsigned long)tabBarController.selectedIndex);
}

//should选中viewController  return YES 可以本选中， NO不可以被选中
/**
 *  点击Item时调用：控制哪些 ViewController 的标签栏能被点击
 *
 *  @param tabBarController 当前tabbar控制器
 *  @param viewController   将要点击的目标控制器
 *
 *  @return YES:允许点击 NO:不允许点击
 */
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    _tabbarIndex = viewController.tabBarItem.tag;
    if (_tabbarIndex==3||_tabbarIndex==4) {
        TXLoginViewController *view = [[TXLoginViewController alloc] init];
        LZNavigationController *navigation = [[LZNavigationController alloc] initWithRootViewController:view];
        [viewController presentViewController:navigation animated:YES completion:^{
            TTLog(@"个人信息修改");
        }];
        return NO;
    }
    return YES;
}

- (NSArray *)tabArray{
    if (!_tabArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"LZRootView" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
        _tabArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    }
    return _tabArray;
}

- (void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow{
    
}

//#pragma mark - 添加通知，创建圆点和删除圆点
//- (void)addObverser {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBadge) name:@"showBadge" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissBadge) name:@"dismissBadge" object:nil];
//}
//
//- (void)showBadge {
//    for (UITabBarItem *item in self.tabBar.items) {
//        if ([item.title isEqualToString:@"我的"]) {
//            NSInteger tag = [self.tabBar.items indexOfObject:item];
//            [self.tabBar showBadgeOnItemIndex:tag];
//        }
//    }
//}
//- (void)dismissBadge {
//    for (UITabBarItem *item in self.tabBar.items) {
//        if ([item.title isEqualToString:@"我的"]) {
//            NSInteger tag = [self.tabBar.items indexOfObject:item];
//            [self.tabBar hideBadgeOnItemIndex:tag];
//        }
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
