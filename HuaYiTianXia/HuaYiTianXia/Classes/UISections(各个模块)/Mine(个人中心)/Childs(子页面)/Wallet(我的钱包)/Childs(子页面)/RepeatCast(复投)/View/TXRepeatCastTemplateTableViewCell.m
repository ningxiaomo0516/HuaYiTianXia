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
        [self initView];
    }
    return self;
}

- (void) initView{
    [self addSubview:self.titlelabel];
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
    }];
    
    NSAttributedString *commentAttr = [SCSmallTools sc_initImageWithText:self.integralText imageName:@"mine_ft_jinbi"];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"mine_ft_jinbi"];
    attachment.bounds = CGRectMake(0,0,[UIFont systemFontOfSize:30].ascender,[UIFont systemFontOfSize:30].ascender);
    self.titlelabel.attributedText = commentAttr;
}

- (UILabel *)titlelabel{
    if (!_titlelabel) {
        _titlelabel = [UILabel lz_labelWithTitle:@"0" color:HexString(@"#26B5FE") font:kFontSizeMedium16];
    }
    return _titlelabel;
}

@end
