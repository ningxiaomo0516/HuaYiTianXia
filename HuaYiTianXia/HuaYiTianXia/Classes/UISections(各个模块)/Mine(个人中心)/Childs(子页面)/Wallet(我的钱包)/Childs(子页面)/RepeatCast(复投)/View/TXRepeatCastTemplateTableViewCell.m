//
//  TXRepeatCastTemplateTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/22.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXRepeatCastTemplateTableViewCell.h"

@implementation TXRepeatCastTemplateTableViewCell

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
    }
    return self;
}

- (void)setIntegralText:(NSString *)integralText{
    _integralText = integralText;
    [self initView];
}

- (void) initView{
    [self addSubview:self.titlelabel];
    [self addSubview:self.imagesView];
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(10);
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titlelabel);
        make.left.equalTo(self.titlelabel.mas_left).offset(-20);
    }];
    
    
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] initWithString:self.integralText];
    /// 前面文字颜色
    [mutableAttr addAttribute:NSForegroundColorAttributeName
                          value:kTextColor153
                          range:NSMakeRange(0, 7)];
    self.titlelabel.attributedText = mutableAttr;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"0" color:HexString(@"#26B5FE") font:kFontSizeMedium17];
    }
    return _titlelabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc]init];
        _imagesView.image = kGetImage(@"mine_ft_jinbi");
    }
    return _imagesView;
}

@end
