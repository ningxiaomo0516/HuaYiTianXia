//
//  TXMessageChildAdsViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/30.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMessageChildAdsViewController.h"

@interface TXMessageChildAdsViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *titlelabel;
@property (strong, nonatomic) UILabel *subtitlelabel;
@property (strong, nonatomic) UILabel *datelabel;
@property (nonatomic, strong) PushMessageModel *messageModel;
@end

@implementation TXMessageChildAdsViewController
- (id)initPushMessageModel:(PushMessageModel *)messageModel{
    if ( self = [super init] ){
        self.messageModel = messageModel;
        self.scrollView.hidden = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.titlelabel.text = @"公告详情接口";
    self.datelabel.text = @"2019-04-28 11:24:37";
}

/// 请求数据接口
- (void) loadMessageData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@(self.messageModel.outID) forKey:@"outID"];
    [SCHttpTools postWithURLString:kHttpURL(@"notice/getNoticeDetails") parameter:parameter success:^(id responseObject) {
        NSDictionary *result = responseObject;
        if ([result isKindOfClass:[NSDictionary class]]) {
            TXPushMessageModel *model = [TXPushMessageModel mj_objectWithKeyValues:result];
            if (model.errorcode == 20000 && model.data != nil) {
                TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
                self.titlelabel.text = model.data.title;
                self.datelabel.text = model.data.datetime;
                self.subtitlelabel.attributedText = [UILabel changeIndentationSpaceForLabel:model.data.content spaceWidth:30.0];
            }else{
                Toast(model.message);
            }
        }
        [self.scrollView setHidden:NO];
        [self.view dismissLoadingView];
    } failure:^(NSError *error) {
        TTLog(@"消息推送详情 -- %@", error);
        [self.view dismissLoadingView];
    }];
}

- (void) initView{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titlelabel];
    [self.scrollView addSubview:self.datelabel];
    [self.scrollView addSubview:self.subtitlelabel];
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.top.equalTo(@(IPHONE6_W(20)));
        make.right.equalTo(self.view.mas_right).offset(IPHONE6_W(-15));
    }];
    [self.datelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titlelabel);
        make.top.equalTo(self.titlelabel.mas_bottom).offset(5);
    }];
    [self.subtitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titlelabel);
        make.top.equalTo(self.datelabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(-(kSafeAreaBottomHeight+20+kNavBarHeight));
    }];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = kTextColor244;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+1);
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titlelabel;
}

- (UILabel *)subtitlelabel{
    if (!_subtitlelabel) {
        _subtitlelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
    }
    return _subtitlelabel;
}

- (UILabel *)datelabel{
    if (!_datelabel) {
        _datelabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium15];
    }
    return _datelabel;
}

@end
