//
//  TXLogisticProductCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/14.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXLogisticProductCell.h"

@implementation TXLogisticProductCell

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
        self.imagesView.image = kGetImage(@"test_work");
        self.titleLabel.text = @"迷你加湿器";
        self.subtitleLabel.text = @"深层排浊 持久保湿 鲜活在线";
        self.order_label_no.text = @"02356552665";
        self.order_label_no_title.text = @"订单编号：";
        
        self.courier_label.text = @"天天快递";
        self.courier_label_title.text = @"物流公司：";
        
        self.address_label.text = @"成都市高新区大鼎广场301";
        self.address_label_title.text = @"收货地址：";
    }
    return self;
}

- (void) initView{
    [self.contentView addSubview:self.imagesView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.order_label_no];
    [self.contentView addSubview:self.courier_label];
    [self.contentView addSubview:self.address_label];

    [self.contentView addSubview:self.order_label_no_title];
    [self.contentView addSubview:self.courier_label_title];
    [self.contentView addSubview:self.address_label_title];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.width.height.equalTo(@(IPHONE6_W(60)));
        make.top.equalTo(@(IPHONE6_W(10)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView.mas_right).offset(15);
        make.top.equalTo(self.imagesView.mas_top).offset(-3);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.imagesView.mas_bottom);
    }];
    
    [self.order_label_no_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView);
        make.top.equalTo(self.imagesView.mas_bottom).offset(5);
    }];

    [self.courier_label_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView);
        make.top.equalTo(self.order_label_no_title.mas_bottom).offset(5);
    }];
    [self.address_label_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagesView);
        make.top.equalTo(self.courier_label_title.mas_bottom).offset(5);
    }];

    [self.order_label_no mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.centerY.equalTo(self.order_label_no_title);
    }];
    [self.courier_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.centerY.equalTo(self.courier_label_title);
    }];
    [self.address_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.centerY.equalTo(self.address_label_title);
    }];
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kThemeColorHex font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium13];
    }
    return _subtitleLabel;
}

- (UILabel *)order_label_no{
    if (!_order_label_no) {
        _order_label_no = [self create_with_label];
    }
    return _order_label_no;
}

- (UILabel *)courier_label{
    if (!_courier_label) {
        _courier_label = [self create_with_label];
    }
    return _courier_label;
}

- (UILabel *)address_label{
    if (!_address_label) {
        _address_label = [self create_with_label];
    }
    return _address_label;
}

- (UILabel *)order_label_no_title{
    if (!_order_label_no_title) {
        _order_label_no_title = [self create_with_label];
    }
    return _order_label_no_title;
}

- (UILabel *)courier_label_title {
    if (!_courier_label_title) {
        _courier_label_title = [self create_with_label];
    }
    return _courier_label_title;
}

- (UILabel *)address_label_title{
    if (!_address_label_title) {
        _address_label_title = [self create_with_label];
    }
    return _address_label_title;
}

- (UILabel *) create_with_label{
    UILabel *label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    return label;
}
@end
