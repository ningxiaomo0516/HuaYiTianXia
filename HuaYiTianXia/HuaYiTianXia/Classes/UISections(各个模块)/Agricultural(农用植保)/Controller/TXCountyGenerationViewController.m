//
//  TXCountyGenerationViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/12.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXCountyGenerationViewController.h"
#import "TXWebViewController.h"
#import "TXEppoListViewController.h"
#import "TXMessagePopupViewController.h"
#import "TXLoginViewController.h"

@interface TXCountyGenerationViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) UIScrollView  *scrollView;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UILabel       *subtitleLabel;
@property (strong, nonatomic) UIView        *headerView;
@property (strong, nonatomic) UIView        *footerView;
@property (strong, nonatomic) UIImageView   *imagesView;
@property (strong, nonatomic) UILabel       *tipslabel;

@end

@implementation TXCountyGenerationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initButton];
    self.titleLabel.text = @"一县一代理独家经营";
    self.subtitleLabel.text = @"农用科技化、现代化";
    self.tipslabel.text = @"备注：选择区域代表市场会员所在的地区，同时代表子公司开设地区。";
    self.imagesView.image = kGetImage(@"区域划分");
    
    UIImage *rightImg = kGetImage(@"更多");
    rightImg = [rightImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:rightImg
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(didTapMoreButton:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

/// 点击右上角的加号弹出菜单选项
- (void)didTapMoreButton:(UIBarButtonItem *)barButtonItem {
    NSString *webURL = kAppendH5URL(DomainName, AgencyCompanyH5, @"");
    TXWebViewController *vc = [[TXWebViewController alloc] init];
    vc.title = @"一县一代";
    vc.webUrl = webURL;
    TTPushVC(vc);
}

- (void) jumpSetRealNameRequest{
    
}

- (void) handleControl:(UIButton *)sender{
    /// 第一步:判断是否登录
    if (kUserInfo.isLogin) {
        /// 0：未认证 1：认证中 2：已认证 3：认证失败
        /// 第二步:判断是否实名认证
        switch (kUserInfo.isValidation) {
            case 1:{
                Toast(@"实名认证审核中,请稍后再试!");
            }
                break;
            case 2:{
                /// 第三步:判断所属区域
                [self get_:sender.tag];
            }
                break;
            default:{
                // 立即认证提示
                UIAlertController *alerController = [UIAlertController addAlertReminderText:@"提示"
                                                                                    message:@"是否立即实名认证?"
                                                                                cancelTitle:@"好的"
                                                                                    doTitle:@"去设置"//去设置
                                                                             preferredStyle:UIAlertControllerStyleAlert
                                                                                cancelBlock:nil doBlock:^{
                                                                                    [self jumpSetRealNameRequest];
                                                                                }];
                [self presentViewController:alerController animated:YES completion:nil];
            }
                break;
        }
    }else{
        TXLoginViewController *view = [[TXLoginViewController alloc] init];
        LZNavigationController *navigation = [[LZNavigationController alloc] initWithRootViewController:view];
        [self presentViewController:navigation animated:YES completion:^{
            TTLog(@"登录界面");
        }];
    }
}

- (void) get_:(NSInteger)idx{
    kShowMBProgressHUD(self.view);
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(idx) forKey:@"id"];
    [SCHttpTools postWithURLString:kHttpURL(@"regionalagent/userToRegionalJudge") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        kHideMBProgressHUD(self.view);
        RegionalPromptModel *model = [RegionalPromptModel mj_objectWithKeyValues:result];
        if (model.errorcode==20000) {
            [self jumpChildViewController:idx];
        }else if(model.errorcode==11){
            TXMessagePopupViewController *vc = [[TXMessagePopupViewController alloc] init];
            CGFloat width = kScreenWidth - IPHONE6_W(45*2);
            CGFloat height = IPHONE6_W(200);
            vc.contentLable.text = model.data.regionalagentMsg;
            MV(weakSelf)
            [vc.enterButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                [weakSelf sc_dismissVC];
                [weakSelf jumpChildViewController:model.data.kid.integerValue];
            }];
            [self sc_centerPresentController:vc presentedSize:CGSizeMake(width, height) completeHandle:^(BOOL presented) {
                NSString *message = presented?@"弹出":@"消失";
                TTLog(@"消息弹出控制器 --- %@",message);
            }];
        }else{
            Toast(model.message);
        }
    } failure:^(NSError *error) {
        kHideMBProgressHUD(self.view);
    }];
}

- (void) jumpChildViewController:(NSInteger)idx{
    TXEppoListViewController *vc = [[TXEppoListViewController alloc] init];
    vc.status = 2;
    vc.idx = 0;
    vc.regionalID = idx;
    vc.title = @"农用植保";
    TTPushVC(vc);
}

- (void) initButton{
    
    // 1:华东 2:华南 3:华中 4:华北 5:西北 6:西南 7:东北
    UIButton *btn1 = [self createWithButton:@"华东" idx:1];
    UIButton *btn2 = [self createWithButton:@"华中" idx:3];
    UIButton *btn3 = [self createWithButton:@"西北" idx:5];
    UIButton *btn4 = [self createWithButton:@"东北" idx:7];
    UIButton *btn5 = [self createWithButton:@"华南" idx:2];
    UIButton *btn6 = [self createWithButton:@"华北" idx:4];
    UIButton *btn7 = [self createWithButton:@"西南" idx:6];
    NSArray *btnArray = @[btn1,btn2,btn3,btn4,btn5,btn6,btn7];
    for (int i=0; i<btnArray.count; i++) {
        [self.headerView addSubview:btnArray[i]];
    }
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn2.mas_left).offset(IPHONE6_W(-10));
        make.centerY.equalTo(btn2);
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).offset(IPHONE6_W(-5));
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(21);
    }];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(IPHONE6_W(5));
        make.centerY.equalTo(btn2);
    }];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn3.mas_right).offset(IPHONE6_W(10));
        make.centerY.equalTo(btn2);
    }];
    
    [btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn6);
        make.right.equalTo(btn6.mas_left).offset(IPHONE6_W(-10));
    }];
    [btn6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(btn2.mas_bottom).offset(IPHONE6_W(-15));
    }];
    [btn7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn6);
        make.left.equalTo(btn6.mas_right).offset(IPHONE6_W(10));
    }];
}

- (void) initView{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.footerView];
    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.subtitleLabel];
    [self.footerView addSubview:self.imagesView];
    [self.footerView addSubview:self.tipslabel];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(IPHONE6_W(265)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.equalTo(@(IPHONE6_W(20)));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE6_W(10));
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).offset(10);
        make.height.equalTo(@(IPHONE6_W(335)));
    }];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(IPHONE6_W(17)));
        make.left.equalTo(@(IPHONE6_W(15)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-15));
    }];
    [self.tipslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagesView.mas_bottom).offset(IPHONE6_W(12));
        make.right.left.equalTo(self.imagesView);
    }];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, 1000);
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNavBarHeight-kTabBarHeight)];
//        _scrollView.frame = self.view.bounds;
//        _scrollView.delegate = self;
//        _scrollView.backgroundColor = kViewColorNormal;
//        _scrollView.showsVerticalScrollIndicator = NO;
//        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-kNavBarHeight-kTabBarHeight+1);
//        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = kViewColorNormal;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+1);
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    }
    return _scrollView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _headerView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _footerView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kThemeColorHex font:kFontSizeMedium21];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _subtitleLabel;
}

- (UILabel *)tipslabel{
    if (!_tipslabel) {
        _tipslabel = [UILabel lz_labelWithTitle:@"" color:kThemeColorHex font:kFontSizeMedium12];
    }
    return _tipslabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UIButton *) createWithButton:(NSString *) imagesName idx:(NSInteger)idx{
    UIButton *sender = [UIButton buttonWithType:UIButtonTypeCustom];
    sender.tag = idx;
    [sender setImage:kGetImage(imagesName) forState:UIControlStateNormal];
    MV(weakSelf)
    [sender lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [weakSelf handleControl:sender];
    }];
    return sender;
}
@end
