//
//  TXInvoiceTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/9.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXInvoiceTableViewCell.h"
#define HorizonGap 15
#define TilteBtnGap 10
@implementation TXInvoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    self.editBtn.backgroundColor = kWhiteColor;
    // Configure the view for the selected state
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
//    self.editBtn.backgroundColor = kWhiteColor;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, [UIColor lz_colorWithHex:0xf7f7f7].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5));
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initView{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.editBtn];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(self.mas_height);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self);
        make.width.equalTo(self.mas_height);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editBtn.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = kColorWithRGB(34, 34, 34);
        _titleLabel.font = kFontSizeMedium13;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_selectBtn setImage:kGetImage(@"unSelect_btn") forState:UIControlStateNormal];
        //        [_selectBtn setImage:kGetImage(@"selected_btn") forState:UIControlStateSelected];
        [_selectBtn setImage:kGetImage(@"music_btn_selected") forState:UIControlStateSelected];
        _selectBtn.userInteractionEnabled = NO;
    }
    return _selectBtn;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editBtn.backgroundColor = kWhiteColor;
        [_editBtn setImage:kGetImage(@"music_btn_edit") forState:UIControlStateNormal];
    }
    return _editBtn;
}


- (void)updateCellWithState:(BOOL)select{
    self.selectBtn.selected = select;
    _isSelected = select;
    if (_isSelected) {
        self.titleLabel.textColor = kColorWithRGB(255, 65, 99);
    }else{
        self.titleLabel.textColor = kColorWithRGB(34, 34, 34);
    }
}

@end
