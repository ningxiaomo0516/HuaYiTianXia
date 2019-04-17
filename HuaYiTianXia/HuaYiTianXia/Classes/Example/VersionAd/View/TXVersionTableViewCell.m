//
//  TXVersionTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXVersionTableViewCell.h"

@implementation TXVersionTableViewCell

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
        [self setupUI];
    }
    return self;
    
}
- (void)setupUI {
    
    UIView * pointView = [UIView lz_viewWithColor:[UIColor lz_colorWithHex:0x999999]];
    pointView.clipsToBounds = YES;
    pointView.layer.cornerRadius = 2;
    [self.contentView addSubview:pointView];
    [self.contentView addSubview:self.textLabel];
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8.5);
        make.left.mas_offset(18);
        make.width.height.mas_equalTo(4);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_offset(26);
        make.right.mas_offset(-18);
    }];
    
}
- (UILabel *)textLabel{
    if (_textlabel == nil) {
        _textlabel = [UILabel lz_labelWithTitle:@"" color:[UIColor lz_colorWithHex:0x808080] font:kFontSizeMedium12];
        _textlabel.numberOfLines = 0;
    }
    return _textlabel;
}

@end
