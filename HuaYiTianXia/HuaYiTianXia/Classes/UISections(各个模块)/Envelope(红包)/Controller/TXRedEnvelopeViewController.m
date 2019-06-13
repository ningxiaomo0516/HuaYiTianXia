//
//  TXRedEnvelopeViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/12.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXRedEnvelopeViewController.h"
#import "TXHongBaoModel.h"

@interface TXRedEnvelopeViewController ()

@end

@implementation TXRedEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self.closeBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self sc_dismissVC];
    }];
    MV(weakSelf);
    [self.linquBtn lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (weakSelf.linquBtn.tag==200) {
            [weakSelf sc_dismissVC];
        }else{
            [weakSelf linqu_hb_request];
        }
    }];
}

- (void) linqu_hb_request{
    [SCHttpTools getWithURLString:kHttpURL(@"redpacket/getRedPacket") parameter:nil success:^(id responseObject) {
        NSDictionary *result = responseObject;
        TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
        if (model.errorcode==20000) {
            self.linquBtn.tag = 200;
            [self.linquBtn setImage:kGetImage(@"c77_btn_确定") forState:UIControlStateNormal];
            self.imagesTitle.image = kGetImage(@"c77_img_恭喜您");
            NSString *titleText = [NSString stringWithFormat:@"获得%@VH",model.obj];
            self.titlelabel.text = titleText;
            self.closeBtn.hidden = YES;
        }else{
            Toast(@"今日红包已领取,请明天再来~");
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void) initView{
    self.view.backgroundColor = [kBlackColor colorWithAlphaComponent:0.4];
    [self.view addSubview:self.imagesView];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.imagesTitle];
    [self.view addSubview:self.titlelabel];
    [self.view addSubview:self.linquBtn];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(8)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-37));
        make.centerY.equalTo(self.view).offset(-30);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right);
        make.bottom.equalTo(self.imagesView.mas_top).offset(-7);
    }];
    [self.imagesTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imagesView).offset(15);
        make.top.equalTo(self.imagesView.mas_top).offset(99);
    }];
    [self.linquBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imagesView).offset(10);
        make.bottom.equalTo(self.imagesView.mas_bottom).offset(-112);
    }];
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imagesTitle);
        make.top.equalTo(self.imagesTitle.mas_bottom).offset(3);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.image = kGetImage(@"红包背景");
    }
    return _imagesView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:kGetImage(@"live_close_envelope") forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (UIButton *)linquBtn{
    if (!_linquBtn) {
        _linquBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_linquBtn setImage:kGetImage(@"live_btn_envelope") forState:UIControlStateNormal];
    }
    return _linquBtn;
}

- (UIImageView *)imagesTitle{
    if (!_imagesTitle) {
        _imagesTitle = [[UIImageView alloc] init];
        _imagesTitle.image = kGetImage(@"每日领取");
    }
    return _imagesTitle;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"" color:kColorWithRGB(241, 48, 30) font:kFontSizeMedium24];
    }
    return _titlelabel;
}
@end
