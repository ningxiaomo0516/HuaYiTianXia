//
//  TXVideoTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/14.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXVideoTableViewCell.h"

@implementation TXVideoTableViewCell

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
        self.contentView.backgroundColor = kTableViewInSectionColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void) initView{
    [self.imagesView lz_setCornerRadius:5.0];
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.imagesPlay];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(@(IPHONE6_W(15)));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
    }];
    [self.imagesPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.imagesView);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UIImageView *)imagesPlay{
    if (!_imagesPlay) {
        _imagesPlay = [[UIImageView alloc] init];
        _imagesPlay.image = kGetImage(@"live_btn_play");
    }
    return _imagesPlay;
}

@end
