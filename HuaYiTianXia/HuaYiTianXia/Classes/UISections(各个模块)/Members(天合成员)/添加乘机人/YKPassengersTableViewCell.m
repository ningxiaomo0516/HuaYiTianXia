//
//  YKPassengersTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/11.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKPassengersTableViewCell.h"

@implementation YKPassengersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier{
    static NSString *footerIdentifier = @"YKPassengersTableViewCell";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [YKPassengersTableViewCell reuseIdentifier];
    YKPassengersTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return tools;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    [self addSubview:self.sc_textField];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.centerY.equalTo(self);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(@(110));
        make.right.equalTo(self.mas_right).offset(-25);
    }];
    [self.sc_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(@(110));
        make.right.equalTo(self.mas_right).offset(-25);
    }];
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [UITextField lz_textFieldWithPlaceHolder:@""];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = kFontSizeRegular15;
        _textField.hidden = YES;
    }
    return _textField;
}

- (SCTextField *)sc_textField{
    if (!_sc_textField) {
        _sc_textField = [[SCTextField alloc] init];
        _sc_textField.returnKeyType = UIReturnKeyDone;
        _sc_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _sc_textField.borderStyle = UITextBorderStyleNone;
        _sc_textField.font = kFontSizeRegular15;
        _sc_textField.hidden = YES;
    }
    return _sc_textField;
}

@end


@implementation YKPassengersTableViewCellArrow

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier{
    static NSString *footerIdentifier = @"YKPassengersTableViewCellArrow";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [YKPassengersTableViewCellArrow reuseIdentifier];
    YKPassengersTableViewCellArrow* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return tools;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.imagesArrow];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.centerY.equalTo(self);
    }];
    [self.imagesArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-25);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(@(110));
        make.right.equalTo(self.mas_right).offset(-25);
    }];
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeRegular15];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeRegular15];
    }
    return _subtitleLabel;
}

- (UIImageView *)imagesArrow{
    if (!_imagesArrow) {
        _imagesArrow = [[UIImageView alloc] init];
        _imagesArrow.image = kGetImage(@"mine_btn_enter");
    }
    return _imagesArrow;
}

@end
