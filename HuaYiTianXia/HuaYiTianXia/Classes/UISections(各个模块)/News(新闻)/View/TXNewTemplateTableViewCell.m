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

/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier{
    static NSString *reuseIdentifier = @"TXNewTemplateTableViewCell";
    return reuseIdentifier;
}

/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = [TXNewTemplateTableViewCell reuseIdentifier];
    TXNewTemplateTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return tools;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self initView];
        self.imagesView.image = kGetImage(@"default_images");
        self.titleLabel.text = @"民航局：明年1月1日，无人机飞...";
        self.subtitleLabel.text = @"...";
        self.dateTimeLabel.text = @"2017-06-04   10:25:24";
    }
    return self;
}

- (void)setRecordsModel:(NewsRecordsModel *)recordsModel{
    _recordsModel = recordsModel;
    self.titleLabel.text = recordsModel.title;
    self.subtitleLabel.text = recordsModel.content;
    self.dateTimeLabel.text = [SCSmallTools timeStampConvertDateTime:recordsModel.time];

    /// 根据 / 分割字符串
    NSArray *imagesArray = [self.recordsModel.images componentsSeparatedByString:@","] ;
    if (imagesArray.count>2) {
        self.imagesView.hidden = YES;
        self.imagesView_L.hidden = NO;
        self.imagesView_C.hidden = NO;
        self.imagesView_R.hidden = NO;
        [self.imagesView_L sd_setImageWithURL:kGetImageURL(imagesArray[0])
                             placeholderImage:kGetImage(VERTICALMAPBITMAP)];
        
        [self.imagesView_C sd_setImageWithURL:kGetImageURL(imagesArray[1])
                             placeholderImage:kGetImage(VERTICALMAPBITMAP)];
        
        [self.imagesView_R sd_setImageWithURL:kGetImageURL(imagesArray[2])
                             placeholderImage:kGetImage(VERTICALMAPBITMAP)];
        
        
        [self.imagesView_L mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.left.equalTo(@(IPHONE6_W(15)));
            make.height.mas_equalTo(IPHONE6_W(75));
        }];
        
        [self.imagesView_C mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.width.equalTo(self.imagesView_L);
            make.left.equalTo(self.imagesView_L.mas_right).offset(8);
        }];
        
        [self.imagesView_R mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.width.equalTo(self.imagesView_C);
            make.left.equalTo(self.imagesView_C.mas_right).offset(8);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        
        [self.dateTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imagesView_L.mas_bottom).offset(10);
            make.left.equalTo(self.titleLabel);
            make.bottom.equalTo(self.mas_bottom).offset(-12);
        }];
    }else{
        self.imagesView.hidden = NO;
        self.imagesView_L.hidden = YES;
        self.imagesView_C.hidden = YES;
        self.imagesView_R.hidden = YES;
        [self.imagesView sd_setImageWithURL:kGetImageURL(recordsModel.img)
                           placeholderImage:kGetImage(VERTICALMAPBITMAP)];
        if (recordsModel.content.length==0) {
            [self.imagesView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
                make.left.right.equalTo(self.titleLabel);
                make.height.mas_equalTo(IPHONE6_W(140));
            }];
        }else{
            [self.imagesView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.subtitleLabel.mas_bottom).offset(10);
                make.left.right.equalTo(self.titleLabel);
                make.height.mas_equalTo(IPHONE6_W(140));
            }];
            [self.dateTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imagesView.mas_bottom).offset(10);
                make.left.equalTo(self.titleLabel);
                make.bottom.equalTo(self.mas_bottom).offset(-12);
            }];
        }
    }
}

- (void) initView{
    [self addSubview:self.imagesView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.dateTimeLabel];
    [self addSubview:self.imagesView_L];
    [self addSubview:self.imagesView_C];
    [self addSubview:self.imagesView_R];
    [self setConstraint];
}

- (void) setConstraint{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(@(12));
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.titleLabel);
        make.height.mas_equalTo(IPHONE6_W(140));
    }];
    [self.dateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagesView.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
    }];
    [self.imagesView_L mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(10);
        make.left.equalTo(@(IPHONE6_W(15)));
        make.height.mas_equalTo(IPHONE6_W(75));
    }];
    
    [self.imagesView_C mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.width.equalTo(self.imagesView_L);
        make.left.equalTo(self.imagesView_L.mas_right).offset(8);
    }];
    
    [self.imagesView_R mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.width.equalTo(self.imagesView_C);
        make.left.equalTo(self.imagesView_C.mas_right).offset(8);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
}


- (UIImageView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIImageView alloc] init];
//        _imagesView.contentMode = UIViewContentModeScaleAspectFill;
        _imagesView.clipsToBounds = YES;
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
        _subtitleLabel.numberOfLines = 1;
    }
    return _subtitleLabel;
}

- (UILabel *)dateTimeLabel{
    if (!_dateTimeLabel) {
        _dateTimeLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor204 font:kFontSizeMedium12];
    }
    return _dateTimeLabel;
}

- (UIImageView *)imagesView_L{
    if (!_imagesView_L) {
        _imagesView_L = [[UIImageView alloc] init];
    }
    return _imagesView_L;
}

- (UIImageView *)imagesView_C{
    if (!_imagesView_C) {
        _imagesView_C = [[UIImageView alloc] init];
    }
    return _imagesView_C;
}

- (UIImageView *)imagesView_R{
    if (!_imagesView_R) {
        _imagesView_R = [[UIImageView alloc] init];
    }
    return _imagesView_R;
}
@end
