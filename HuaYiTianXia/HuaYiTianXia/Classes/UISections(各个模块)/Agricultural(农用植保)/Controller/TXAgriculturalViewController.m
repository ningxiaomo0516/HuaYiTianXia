//
//  TXAgriculturalViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXAgriculturalViewController.h"
#import "TTTagView.h"

@interface TXAgriculturalViewController ()<TTTagViewDelegate>
@property (nonatomic ,strong)TTTagView * tagView;

@end

@implementation TXAgriculturalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tagView];
     self.tagView.dataArray = @[@"锤子",@"见过",@"膜拜单车",@"微信支付",@"Q",@"王者荣耀",@"蓝淋网",@"阿珂",@"半生",@"猎场",@"QQ空间",@"王者荣耀助手",@"斯卡哈复健科",@"安抚",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味"];
    TTLog(@"----- %f",CGRectGetHeight(self.tagView.frame));
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(TTTagView *)tagView{
    if (!_tagView) {
        _tagView = [[TTTagView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 0)];
        _tagView.delegate = self;
    }
    return _tagView;
}

#pragma mark - CCTagViewDelegate
- (void)handleSelectTag:(NSString *)keyWord{
    TTLog(@"keyWord ---- %@",keyWord);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
