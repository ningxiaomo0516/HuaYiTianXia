//
//  TXMallGoodsSpecTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMallGoodsSpecTableViewCell.h"

@interface TXMallGoodsSpecTableViewCell()<TTTagViewDelegate>

/// 记录最后的height
@property (nonatomic, assign) CGFloat endHeight;
/// headerView的高度
@property (nonatomic, assign) CGFloat headerHeight;
/// collectionView的宽度
@property (nonatomic, assign) CGFloat width;
/// collectionView的左边距离
@property (nonatomic, assign) CGFloat left;

@end

@implementation TXMallGoodsSpecTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.left = IPHONE6_W(100);
        self.width = kScreenWidth - IPHONE6_W(100);
        self.endHeight = 0;
        [self initView];
    }
    return self;
}

- (void) initView{

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    // Do any additional setup after loading the view.
    [self.contentView addSubview:self.tagView];
//    self.tagView.dataArray = @[@"锤子",@"见过",@"膜拜单车",@"微信支付",@"Q",@"王者荣耀",@"蓝淋网",@"阿珂",@"半生",@"猎场",@"QQ空间",@"王者荣耀助手",@"斯卡哈复健科",@"安抚",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味",@"沙发上",@"日打的费",@"问问",@"无人区",@"阿斯废弃物人情味"];
//    TTLog(@"----- %f",CGRectGetHeight(self.tagView.frame));
//    [self updateCollectionViewHeight:CGRectGetHeight(self.tagView.frame)+self.headerHeight];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.top.equalTo(self.tagView.mas_top).offset(15);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subtitleLabel).offset(IPHONE6_W(-15));
        make.top.equalTo(self.contentView).offset(IPHONE6_W(6));
    }];

}

/// 更新CollectionViewHeight
- (void)updateCollectionViewHeight:(CGFloat)height {
    if (self.endHeight != height) {
        self.endHeight = height;
        self.tagView.frame = CGRectMake(self.left, self.headerHeight, self.tagView.width, height);
//        if (self.delegate && [self.delegate respondsToSelector:@selector(updateTableViewCellHeight:andheight:andIndexPath:)]) {
//            [self.delegate updateTableViewCellHeight:self andheight:height andIndexPath:self.indexPath];
//        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateTableViewCellHeight:andheight:)]) {
            [self.delegate updateTableViewCellHeight:self andheight:height];
        }
    }
}


#pragma mark - CCTagViewDelegate
- (void)handleSelectTag:(NSString *)keyWord{
    TTLog(@"keyWord ---- %@",keyWord);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didToolsSelectItemAtIndexPath:withContent:)]) {
        [self.delegate didToolsSelectItemAtIndexPath:self.indexPath withContent:keyWord];
    }
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"产品规格：" color:kTextColor102  font:kFontSizeMedium13];
    }
    return _titleLabel;
}

- (TTTagView *)tagView{
    if (!_tagView) {
        _tagView = [[TTTagView alloc] initWithFrame:CGRectMake(self.left, 0, self.width, 0)];
        _tagView.backgroundColor = kWhiteColor;
        _tagView.delegate = self;
    }
    return _tagView;
}

- (SCCustomMarginLabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [[SCCustomMarginLabel alloc] init];
        _subtitleLabel.hidden = YES;
        _subtitleLabel.text = @"1";
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.backgroundColor = kColorWithRGB(248, 248, 248);
        _subtitleLabel.textColor = kTextColor102;
        _subtitleLabel.font = kFontSizeMedium15;
        _subtitleLabel.edgeInsets    = UIEdgeInsetsMake(6.f, 20.f, 6.f, 20.f); // 设置左内边距
        [_subtitleLabel lz_setCornerRadius:3.0];
        [_subtitleLabel sizeToFit]; // 重新计算尺寸
    }
    return _subtitleLabel;
}

@end
