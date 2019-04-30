//
//  TXSystemTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/25.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TXSystemTableViewCell.h"

@implementation TXSystemTableViewCell

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
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

- (void)setMessageModel:(PushMessageModel *)messageModel{
    _messageModel = messageModel;
    self.titleLabel.text = messageModel.title;
    self.subtitleLabel.text = messageModel.content;
    self.dateLabel.text = messageModel.datetime;
    /// 消息类型 2：转出记录 3：转入记录 4：后台公告 5：通知
    if (messageModel.messageType==2) {
        self.amountLabel.text = [NSString stringWithFormat:@"- %@",messageModel.money];
        self.imagesView.image = kGetImage(@"转账图标2");
        self.amountLabel.textColor = HexString(@"#1296DB");
    }else if(messageModel.messageType==3){
        self.imagesView.image = kGetImage(@"转账图标");
        self.amountLabel.text = [NSString stringWithFormat:@"+ %@",messageModel.money];
    }else if(messageModel.messageType==4){
        self.imagesView.image = kGetImage(@"c51_消息");
        self.amountLabel.text = @"";
    }else if(messageModel.messageType==5){
        
    }
}

- (void) initView{
    [self addSubview:self.titleLabel];
    [self addSubview:self.imagesView];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.amountLabel];
    [self addSubview:self.dateLabel];
    
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(15)));
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(IPHONE6_W(65)));
        make.top.equalTo(@(IPHONE6_W(15)));
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(IPHONE6_W(15));
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(IPHONE6_W(10));
        make.bottom.equalTo(self.mas_bottom).offset(IPHONE6_W(-15));
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
    }];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
    }
    return _titleLabel;
}

- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
    }
    return _imagesView;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
        _subtitleLabel.numberOfLines = 1;
    }
    return _subtitleLabel;
}

- (UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [UILabel lz_labelWithTitle:@"" color:HexString(@"#FC822B") font:kFontSizeScBold20];
    }
    return _amountLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor102 font:kFontSizeMedium12];
    }
    return _dateLabel;
}

@end
