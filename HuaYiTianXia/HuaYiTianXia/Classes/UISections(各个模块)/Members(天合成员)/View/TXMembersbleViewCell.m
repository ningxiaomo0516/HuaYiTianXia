//
//  TXMembersbleViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXMembersbleViewCell.h"

@implementation TXMembersbleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = kWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void) initView{
    [self addSubview:self.imagesView];
    [self addSubview:self.imagesViewShadow];
    [self.imagesViewShadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@(2));
    }];
}

- (UIImageView *)imagesViewShadow{
    if (!_imagesViewShadow) {
        _imagesViewShadow = [[UIImageView alloc] init];
        _imagesViewShadow.image = kGetImage(@"live_btn_shadow");
    }
    return _imagesViewShadow;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

@end
