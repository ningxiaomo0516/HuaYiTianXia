//
//  TXPassengersTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/9.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXPassengersTableViewCell.h"

@implementation TXPassengersTableViewCell

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
    static NSString *footerIdentifier = @"TXPassengersTableViewCell";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [TXPassengersTableViewCell reuseIdentifier];
    TXPassengersTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self addSubview:self.date_label];
    [self addSubview:self.week_label];
    [self addSubview:self.time_label];
    [self addSubview:self.seat_label];
    [self addSubview:self.imagesArrow];
    
    CGFloat left = 15+10;
    [self.date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left);
        make.centerY.equalTo(self);
    }];
    [self.week_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.date_label.mas_right).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.week_label.mas_right).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.seat_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.time_label.mas_right).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.imagesArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(-left-10);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)date_label{
    if (!_date_label) {
        _date_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium18];
    }
    return _date_label;
}

- (UILabel *)week_label{
    if (!_week_label) {
        _week_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium18];
    }
    return _week_label;
}

- (UILabel *)time_label{
    if (!_time_label) {
        _time_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium18];
    }
    return _time_label;
}

- (UILabel *)seat_label{
    if (!_seat_label) {
        _seat_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium18];
    }
    return _seat_label;
}

- (UIImageView *)imagesArrow{
    if (!_imagesArrow) {
        _imagesArrow = [[UIImageView alloc] init];
        _imagesArrow.image = kGetImage(@"右箭头");
    }
    return _imagesArrow;
}

@end


@implementation TXPassengersTableViewCell2

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
    static NSString *footerIdentifier = @"TXPassengersTableViewCell2";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [TXPassengersTableViewCell2 reuseIdentifier];
    TXPassengersTableViewCell2* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self addSubview:self.imagesView];
    [self addSubview:self.title_label];
    [self addSubview:self.subtitle_label];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.top.equalTo(@(15));
    }];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(50));
        make.right.equalTo(self.mas_right).offset(-25);
        make.centerY.equalTo(self.imagesView);
    }];
    
    [self.subtitle_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.title_label);
        make.top.equalTo(self.title_label.mas_bottom).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-25);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.image = kGetImage(@"黄色小飞机");
    }
    return _imagesView;
}

- (UILabel *)title_label{
    if (!_title_label) {
        _title_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeRegular12];
    }
    return _title_label;
}
- (UILabel *)subtitle_label{
    if (!_subtitle_label) {
        _subtitle_label = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular12];
    }
    return _subtitle_label;
}
@end

@implementation TXPassengersTableViewCell3

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
    static NSString *footerIdentifier = @"TXPassengersTableViewCell3";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [TXPassengersTableViewCell3 reuseIdentifier];
    TXPassengersTableViewCell3* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self addSubview:self.imagesView];
    [self addSubview:self.title_label];
    [self addSubview:self.subtitle_label];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_label.mas_right).offset(5);
        make.centerY.equalTo(self.title_label);
    }];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.centerY.equalTo(self);
    }];
    
    [self.subtitle_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right).offset(5);
        make.centerY.equalTo(self.imagesView);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
        _imagesView.image = kGetImage(@"至尊会员");
    }
    return _imagesView;
}

- (UILabel *)title_label{
    if (!_title_label) {
        _title_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _title_label;
}
- (UILabel *)subtitle_label{
    if (!_subtitle_label) {
        _subtitle_label = [UILabel lz_labelWithTitle:@"" color:kColorWithRGB(199, 167, 101) font:kFontSizeRegular12];
    }
    return _subtitle_label;
}
@end


@implementation TXPassengersTableViewCell4

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
    static NSString *footerIdentifier = @"TXPassengersTableViewCell4";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [TXPassengersTableViewCell4 reuseIdentifier];
    TXPassengersTableViewCell4* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self addSubview:self.username_label];
    [self addSubview:self.idcard_label];
    [self addSubview:self.ticket_type_label];
    
    [self.username_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.top.equalTo(@(13));
    }];
    [self.idcard_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.username_label);
        make.bottom.equalTo(self.mas_bottom).offset(-13);
    }];
    
    [self.ticket_type_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)username_label{
    if (!_username_label) {
        _username_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _username_label;
}
- (UILabel *)idcard_label{
    if (!_idcard_label) {
        _idcard_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _idcard_label;
}

- (UILabel *)ticket_type_label{
    if (!_ticket_type_label) {
        _ticket_type_label = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular15];
    }
    return _ticket_type_label;
}
@end



@implementation TXPassengersTableViewCell5

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
    static NSString *footerIdentifier = @"TXPassengersTableViewCell5";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [TXPassengersTableViewCell5 reuseIdentifier];
    TXPassengersTableViewCell5* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self addSubview:self.title_label];
    [self addSubview:self.textField];
    
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.centerY.equalTo(self);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(100));
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-25);
    }];
    
}

- (UILabel *)title_label{
    if (!_title_label) {
        _title_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeRegular15];
    }
    return _title_label;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = kTextColor51;
        _textField.font = kFontSizeRegular15;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.placeholder = @"请输入取票电话号码";
    }
    return _textField;
}
@end



@implementation TXPassengersTableViewCell6

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
    static NSString *footerIdentifier = @"TXPassengersTableViewCell6";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [TXPassengersTableViewCell6 reuseIdentifier];
    TXPassengersTableViewCell6* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self addSubview:self.title_label];
    [self addSubview:self.subtitle_label];
    
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.centerY.equalTo(self);
    }];
    [self.subtitle_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_label.mas_right).offset(5);
        make.centerY.equalTo(self);
    }];
    
}

- (UILabel *)title_label{
    if (!_title_label) {
        _title_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _title_label;
}
- (UILabel *)subtitle_label{
    if (!_subtitle_label) {
        _subtitle_label = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular13];
    }
    return _subtitle_label;
}
@end



@implementation TXPassengersTableViewCell7

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
    static NSString *footerIdentifier = @"TXPassengersTableViewCell7";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [TXPassengersTableViewCell7 reuseIdentifier];
    TXPassengersTableViewCell7* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self addSubview:self.title_label];
    [self addSubview:self.subtitle_label];
    
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.top.equalTo(@(10));
    }];
    [self.subtitle_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_label);
        make.top.equalTo(self.title_label.mas_bottom).offset(5);
    }];
    
}

- (UILabel *)title_label{
    if (!_title_label) {
        _title_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeRegular15];
    }
    return _title_label;
}
- (UILabel *)subtitle_label{
    if (!_subtitle_label) {
        _subtitle_label = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeRegular13];
    }
    return _subtitle_label;
}
@end
