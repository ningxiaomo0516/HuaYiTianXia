//
//  YXTicketOrderTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/10.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YXTicketOrderTableViewCell.h"

@implementation YXTicketOrderTableViewCell

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
    static NSString *footerIdentifier = @"YXTicketOrderTableViewCell";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [YXTicketOrderTableViewCell reuseIdentifier];
    YXTicketOrderTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
    return tools;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kViewColorNormal;
        [self initView];
        
        self.imagesView.image = kGetImage(@"行程_虚线_飞机");
        self.imagesView_t.image = kGetImage(@"右箭头");
        [self.boxView lz_setCornerRadius:5.0];
    }
    return self;
}

- (void) initView{
    [self addSubview:self.dep_arv_city_label];
    [self addSubview:self.dep_date_label];
    [self addSubview:self.dep_week_label];
    [self addSubview:self.imagesView_t];
    self.childView_c.backgroundColor = [HexString(@"#C7A765") colorWithAlphaComponent:0.3];
    
    [self addSubview:self.boxView];
    
    [self.boxView addSubview:self.childView_t];
    [self.boxView addSubview:self.childView_c];
    [self.boxView addSubview:self.childView_b];
    
    [self.childView_t addSubview:self.flightNo_label];
    [self.childView_t addSubview:self.depCity_arvCity_label];
    
    [self.childView_c addSubview:self.dep_airport_label];
    [self.childView_c addSubview:self.arv_airport_label];
    [self.childView_c addSubview:self.dep_time_label];
    [self.childView_c addSubview:self.arv_time_label];
    [self.childView_c addSubview:self.imagesView];
    
    [self.childView_b addSubview:self.imagesView_b];
    [self.childView_b addSubview:self.trip_status_label];
    [self.childView_b addSubview:self.nextButton];
    
    CGFloat left = 30;
    [self.dep_arv_city_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(left));
    }];
    [self.imagesView_t mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_arv_city_label.mas_right).offset(5);
        make.centerY.equalTo(self.dep_arv_city_label);
    }];
    [self.dep_date_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.top.equalTo(self.dep_arv_city_label.mas_bottom).offset(5);
    }];
    
    [self.dep_week_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dep_date_label.mas_right).offset(5);
        make.centerY.equalTo(self.dep_date_label);
    }];
    
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.left.equalTo(@(left));
        make.height.equalTo(@(140));
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [self.childView_t mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.boxView);
        make.height.equalTo(@(left));
    }];

    [self.childView_b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.boxView);
        make.height.equalTo(@(left));
    }];

    [self.childView_c mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.boxView);
        make.top.equalTo(self.childView_t.mas_bottom);
        make.bottom.equalTo(self.childView_b.mas_top);
    }];

    [self.flightNo_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boxView).offset(15);
        make.centerY.equalTo(self.childView_t);
    }];
    [self.depCity_arvCity_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flightNo_label.mas_right).offset(15);
        make.centerY.equalTo(self.childView_t);
    }];

    [self.imagesView_b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flightNo_label);
        make.centerY.equalTo(self.childView_b);
    }];

    [self.trip_status_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView_b.mas_right).offset(10);
        make.centerY.equalTo(self.childView_b);
    }];

    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.childView_b.mas_right).offset(-15);
        make.top.bottom.equalTo(self.childView_b);
        make.width.equalTo(@(80));
    }];

    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.boxView);
        make.bottom.equalTo(self.childView_c.mas_bottom).offset(-20);
    }];

    [self.dep_time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.boxView).offset(18);
        make.centerY.equalTo(self.imagesView);
    }];

    [self.arv_time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.boxView.mas_right).offset(-18);
        make.centerY.equalTo(self.imagesView);
    }];

    [self.dep_airport_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.dep_time_label);
        make.bottom.equalTo(self.dep_time_label.mas_top);
    }];
    [self.arv_airport_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.arv_time_label);
        make.centerY.equalTo(self.dep_airport_label);
    }];
}

- (UILabel *)dep_arv_city_label{
    if (!_dep_arv_city_label) {
        _dep_arv_city_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium18];
    }
    return _dep_arv_city_label;
}

- (UILabel *)dep_date_label{
    if (!_dep_date_label) {
        _dep_date_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium14];
    }
    return _dep_date_label;
}

- (UILabel *)dep_week_label{
    if (!_dep_week_label) {
        _dep_week_label = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeRegular12];
    }
    return _dep_week_label;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _boxView;
}

- (UILabel *)flightNo_label{
    if (!_flightNo_label) {
        _flightNo_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium12];
    }
    return _flightNo_label;
}

- (UILabel *)depCity_arvCity_label{
    if (!_depCity_arvCity_label) {
        _depCity_arvCity_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium12];
    }
    return _depCity_arvCity_label;
}

- (UILabel *)dep_airport_label{
    if (!_dep_airport_label) {
        _dep_airport_label = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium12];
    }
    return _dep_airport_label;
}

- (UILabel *)arv_airport_label{
    if (!_arv_airport_label) {
        _arv_airport_label = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium12];
    }
    return _arv_airport_label;
}

- (UILabel *)dep_time_label{
    if (!_dep_time_label) {
        _dep_time_label = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium27];
    }
    return _dep_time_label;
}

- (UILabel *)arv_time_label{
    if (!_arv_time_label) {
        _arv_time_label = [UILabel lz_labelWithTitle:@"" color:kWhiteColor font:kFontSizeMedium27];
    }
    return _arv_time_label;
}

- (UILabel *)trip_status_label{
    if (!_trip_status_label) {
        _trip_status_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeRegular12];
    }
    return _trip_status_label;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UIView *)childView_t{
    if (!_childView_t) {
        _childView_t = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _childView_t;
}

- (UIView *)childView_b{
    if (!_childView_b) {
        _childView_b = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _childView_b;
}

- (UIView *)childView_c{
    if (!_childView_c) {
        _childView_c = [UIView lz_viewWithColor:HexString(@"#C7A765")];
    }
    return _childView_c;
}

- (UIImageView *)imagesView_t{
    if (!_imagesView_t) {
        _imagesView_t = [[UIImageView alloc] init];
    }
    return _imagesView_t;
}

- (UIImageView *)imagesView_b{
    if (!_imagesView_b) {
        _imagesView_b = [[UIImageView alloc] init];
    }
    return _imagesView_b;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"订单详情" forState:UIControlStateNormal];
        [_nextButton setTitleColor:HexString(@"#4165DB") forState:UIControlStateNormal];
        _nextButton.titleLabel.font = kFontSizeRegular12;
        _nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _nextButton;
}
@end
