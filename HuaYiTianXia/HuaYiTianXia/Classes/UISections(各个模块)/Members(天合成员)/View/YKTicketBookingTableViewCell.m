//
//  YKTicketBookingTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/6.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YKTicketBookingTableViewCell.h"

@implementation YKTicketBookingTableViewCell

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
    static NSString *footerIdentifier = @"YKTicketBookingTableViewCell";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [YKTicketBookingTableViewCell reuseIdentifier];
    YKTicketBookingTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return tools;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initView];
        self.zyLabel.text = @"自营";
    }
    return self;
}

- (void) initView{
    [self.reservationBtn lz_setCornerRadius:25.0/2.0];
    [self addSubview:self.priceLabel];
    [self addSubview:self.discountLabel];
    [self addSubview:self.reservationBtn];
    [self addSubview:self.linerView2];
    [self addSubview:self.linerView1];
    [self addSubview:self.zyLabel];
    [self addSubview:self.fwButton];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(@(10));
    }];
    
    [self.discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    [self.reservationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
        make.width.equalTo(@(50));
        make.height.equalTo(@(25));
    }];
    [self.linerView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.discountLabel.mas_right).offset(5);
        make.centerY.equalTo(self.discountLabel);
        make.width.equalTo(@(1));
        make.height.equalTo(@(10));
    }];
    [self.zyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.linerView1);
        make.left.equalTo(self.linerView1.mas_right).offset(5);
    }];
    [self.linerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.width.equalTo(self.linerView1);
        make.left.equalTo(self.zyLabel.mas_right).offset(5);
    }];
    [self.fwButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.linerView2.mas_right).offset(5);
        make.centerY.equalTo(self.linerView2);
    }];
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:kColorWithRGB(244, 78, 68) font:kFontSizeMedium18];
    }
    return _priceLabel;
}

- (UILabel *)discountLabel{
    if (!_discountLabel) {
        _discountLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeRegular13];
    }
    return _discountLabel;
}

- (UIButton *)reservationBtn{
    if (!_reservationBtn) {
        _reservationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reservationBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _reservationBtn.titleLabel.font = kFontSizeRegular15;
        [_reservationBtn setTitle:@"预订" forState:UIControlStateNormal];
        [_reservationBtn setBackgroundImage:kButtonColorNormal forState:UIControlStateNormal];
    }
    return _reservationBtn;
}

- (UIView *)linerView1{
    if (!_linerView1) {
        _linerView1 = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView1;
}

- (UIView *)linerView2{
    if (!_linerView2) {
        _linerView2 = [UIView lz_viewWithColor:kLinerViewColor];
    }
    return _linerView2;
}

- (UILabel *)zyLabel{
    if (!_zyLabel) {
        _zyLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeRegular13];
    }
    return _zyLabel;
}

- (UIButton *)fwButton{
    if (!_fwButton) {
        _fwButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fwButton setTitle:@"放心服务" forState:UIControlStateNormal];
        [_fwButton setImage:kGetImage(@"右箭头") forState:UIControlStateNormal];
        [_fwButton setTitleColor:kTextColor51 forState:UIControlStateNormal];
        _fwButton.titleLabel.font = kFontSizeRegular13;
        [Utils lz_setButtonTitleWithImageEdgeInsets:_fwButton postition:kMVImagePositionRight spacing:5];
    }
    return _fwButton;
}
@end
