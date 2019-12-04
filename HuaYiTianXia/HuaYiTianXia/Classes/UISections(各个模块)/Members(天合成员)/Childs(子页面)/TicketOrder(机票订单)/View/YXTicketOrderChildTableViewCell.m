//
//  YXTicketOrderChildTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/10.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "YXTicketOrderChildTableViewCell.h"

@implementation YXTicketOrderChildTableViewCell

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
    static NSString *footerIdentifier = @"YXTicketOrderChildTableViewCell";
    return footerIdentifier;
}
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    //从缓存池中寻找底部视图对象，如果没有，该方法自动调用alloc/initWithFrame创建一个新的底部视图返回
    NSString *reuseIdentifier = [YXTicketOrderChildTableViewCell reuseIdentifier];
    YXTicketOrderChildTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    tools.selectionStyle = UITableViewCellSelectionStyleNone;
    return tools;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kWhiteColor;
        [self initView];
    }
    return self;
}

- (void) initView{
    [self addSubview:self.title_label];
    [self addSubview:self.username_label];
    [self addSubview:self.ticketno_label];
    [self addSubview:self.identityno_label];
    
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(25));
        make.top.equalTo(@(15));
    }];
    
    [self.username_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title_label.mas_right).offset(40);
        make.centerY.equalTo(self.title_label);
    }];
    
    [self.identityno_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.username_label);
        make.top.equalTo(self.username_label.mas_bottom).offset(5);
    }];
    
    [self.ticketno_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.username_label);
        make.top.equalTo(self.identityno_label.mas_bottom).offset(5);
    }];
}

- (UILabel *)title_label{
    if (!_title_label) {
        _title_label = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeRegular14];
    }
    return _title_label;
}

- (UILabel *)username_label{
    if (!_username_label) {
        _username_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _username_label;
}

- (UILabel *)ticketno_label{
    if (!_ticketno_label) {
        _ticketno_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeRegular13];
    }
    return _ticketno_label;
}

- (UILabel *)identityno_label{
    if (!_identityno_label) {
        _identityno_label = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeRegular13];
    }
    return _identityno_label;
}
@end
