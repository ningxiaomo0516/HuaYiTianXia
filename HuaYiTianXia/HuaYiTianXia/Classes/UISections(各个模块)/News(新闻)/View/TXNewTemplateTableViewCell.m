//
//  TXNewTemplateTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXNewTemplateTableViewCell.h"

@implementation TXNewTemplateTableViewCell

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
        [self initView];
        self.imagesView.image = kGetImage(@"default_images");
        self.titleLabel.text = @"民航局：明年1月1日，无人机飞...";
        self.subtitleLabel.text = @"农用植保农用植保农用植保农用植保农用植保农用植保农用植保农...";
        self.dataTimeLabel.text = @"2017-06-04   10:25:24";
    }
    return self;
}

- (void)setRecordsModel:(NewsRecordsModel *)recordsModel{
    _recordsModel = recordsModel;
    self.titleLabel.text = recordsModel.title;
    self.subtitleLabel.text = recordsModel.content;
    [self.imagesView sd_setImageWithURL:[NSURL URLWithString:recordsModel.img]
                      placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    self.dataTimeLabel.text = [SCSmallTools timeStampConvertDateTime:recordsModel.time];
}

- (void) initView{
    
    [self addSubview:self.imagesView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.dataTimeLabel];
    
    [self setConstraint];
    
}

- (void) setConstraint{
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(IPHONE6_W(-15));
        make.height.mas_equalTo(IPHONE6_W(75));
        make.width.mas_equalTo(IPHONE6_W(90));
        make.centerY.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(12));
        make.right.equalTo(self.imagesView.mas_left).offset(-15);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.right.equalTo(self.imagesView.mas_left).offset(-15);
    }];
    [self.dataTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
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
        _titleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium15];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel{
    if (!_subtitleLabel) {
        _subtitleLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor153 font:kFontSizeMedium13];
        _subtitleLabel.numberOfLines = 2;
    }
    return _subtitleLabel;
}

- (UILabel *)dataTimeLabel{
    if (!_dataTimeLabel) {
        _dataTimeLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor204 font:kFontSizeMedium12];
    }
    return _dataTimeLabel;
}
@end
