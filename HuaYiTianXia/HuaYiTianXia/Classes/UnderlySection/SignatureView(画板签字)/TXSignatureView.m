//
//  TXSignatureView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/5.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXSignatureView.h"
#import "TXPaintView.h"
#import "TTCustomPhotoAlbum.h"
#import "SCUploadImageModel.h"

@interface TXSignatureView ()

@property(nonatomic,strong) UIView *headerView;
@property(nonatomic,strong) UIView *footerView;
@property(nonatomic,strong) UIView *boxView;

@property(nonatomic,strong) TXPaintView *paintView;
/// 是否签名，默认为NO
@property(nonatomic,assign) BOOL isSignature;

@end

@implementation TXSignatureView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kClearColor;
        self.tag = 6521;
        self.isSignature = NO;
        [self initView];
        [UIView animateWithDuration:0.25f animations:^{
            self.transform = CGAffineTransformMakeRotation(M_PI/2);
        } completion:^(BOOL finished) {
            
        }];
//        self.priceLabel.text = @"￥3000";
        self.termsLabel.text = @"本人意阅读服务协议,并同意履行此协议";
        self.datetimeLabel.text = [Utils lz_getCurrentTime];
        
        MV(weakSelf)
        [self.clearButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf clearAction:weakSelf.clearButton];
        }];
        [self.closeButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf closeAction:weakSelf.closeButton];
        }];
        [self.saveButton lz_handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [weakSelf saveAction:weakSelf.saveButton];
        }];
    }
    return self;
}

/**
 *  保存图片到本地
 *
 *  @param image 图片对象
 *  @param error 成功方法绑定的target
 *  @param contextInfo 成功后调用方法
 */
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = @"保存失败";
    if (!error) {
        self.isSignature = YES;
        message = @"成功保存到相册";
    } else {
        self.isSignature = NO;
        message = [error description];
    }
    TTLog(@"message is %@",message);
}

#pragma mark________________生成图片
- (void)saveAction:(UIButton *)sender {
    UIImage *image = [self imageWithUIView:self.paintView];
    UIImage *image_s = [self compressImage:image];
    if (!image_s) {
        [self upload:image_s button:sender];
    }else{
        Toast(@"同意之前请先签字");
    }
    //参数1:图片对象
    //参数2:成功方法绑定的target
    //参数3:成功后调用方法
    //参数4:需要传递信息(成功后调用方法的参数) 一般写nil
//    UIImageWriteToSavedPhotosAlbum(image_s, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
    /// 新建项目的相册文件夹
//    [[TTCustomPhotoAlbum shareInstance] saveToNewThumb:image_s];
}

- (void) upload:(UIImage *) image button:(UIButton *)sender{
    kShowMBProgressHUD(self);
    [SCHttpTools postImageWithURLString:uploadFile parameter:nil image:image success:^(id result) {
        SCUploadImageModel *model = [SCUploadImageModel mj_objectWithKeyValues:result];
        if ([result isKindOfClass:[NSDictionary class]]) {
            if (model.errorcode == 20000) {
                TTLog(@"图片上传%@",[Utils lz_dataWithJSONObject:result]);
                if (self.completionHandler) {
                    if (model.data.count>0) {
                        self.completionHandler(model.data[0].imageURL);
                        [self closeAction:sender];
                    }else{
                        Toast(@"图片上传成功,但没返回数据");
                    }
                }
            }else {
                Toast(model.message);
            }
        }else {
            Toast(@"图片上传失败");
        }
        kHideMBProgressHUD(self);;
    } failure:^(NSError *error) {
        kHideMBProgressHUD(self);
        TTLog(@"图片上传 --- %@",error);
    }];
}

- (void)clearAction:(UIButton *)sender {
    [self.paintView clear];
}

- (void)closeAction:(UIButton *)sender{
    [[kKeyWindow viewWithTag:6521] removeFromSuperview];
}

/// 生成图片
- (UIImage*) imageWithUIView:(UIView*) view{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/// 指定大小图片
- (UIImage *)compressImage:(UIImage *)imgSrc{
    CGSize size = {300, 100};
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [imgSrc drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}

- (void) initView{
    self.revokeButton.hidden = YES;
    [self addSubview:self.headerView];
    [self addSubview:self.footerView];
    [self addSubview:self.boxView];
    [self.headerView addSubview:self.priceLabel];
    [self.headerView addSubview:self.clearButton];
    [self.headerView addSubview:self.revokeButton];
    [self.headerView addSubview:self.closeButton];
    
    [self.boxView addSubview:self.paintView];
    
    [self.footerView addSubview:self.termsLabel];
    [self.footerView addSubview:self.datetimeLabel];
    [self.footerView addSubview:self.saveButton];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(90));
    }];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(self.headerView);
    }];
    [self.boxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.footerView.mas_top);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.headerView);
    }];
    
    CGFloat left = 15+kSafeAreaBottomHeight;
    [self.revokeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView.mas_right).offset(-(left));
        make.centerY.equalTo(self.headerView);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.revokeButton.mas_left).offset(-(left/2));
        make.right.equalTo(self.headerView.mas_right).offset(-(left));
        make.centerY.equalTo(self.headerView);
        make.width.height.equalTo(@(50));
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(left));
        make.width.height.equalTo(@(50));
        make.centerY.equalTo(self.headerView);
    }];
    
    [self.termsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footerView.mas_left).offset(left);
        make.top.equalTo(@(5));
    }];
    [self.datetimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.footerView.mas_right).offset(-(left));
        make.centerY.equalTo(self.termsLabel);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(50));
        make.width.equalTo(@(kCrossScreenHeight/3));
        make.centerX.equalTo(self.footerView);
        make.centerY.equalTo(self.footerView).offset(10);
    }];
    
    [self.paintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.boxView);
    }];
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView lz_viewWithColor:kColorWithRGB(239, 239, 243)];
    }
    return _headerView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [UIView lz_viewWithColor:kColorWithRGB(239, 239, 243)];
    }
    return _footerView;
}

- (UIView *)boxView{
    if (!_boxView) {
        _boxView = [UIView lz_viewWithColor:kWhiteColor];
    }
    return _boxView;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_closeButton setImage:kGetImage(@"all_btn_close_grey") forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIButton *)clearButton{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_clearButton setTitle:@"清除" forState:UIControlStateNormal];
        _clearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _clearButton.tintColor = kTextColor51;
        _clearButton.titleLabel.font = kFontSizeMedium15;
    }
    return _clearButton;
}

- (UIButton *)revokeButton{
    if (!_revokeButton) {
        _revokeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_revokeButton setTitle:@"撤销" forState:UIControlStateNormal];
        _revokeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _revokeButton.tintColor = kTextColor51;
        _revokeButton.titleLabel.font = kFontSizeMedium15;
    }
    return _revokeButton;
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [Utils lz_setButtonWithBGImage:_saveButton cornerRadius:5.0];
        [_saveButton setTitle:@"同意签字" forState:UIControlStateNormal];
    }
    return _saveButton;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium20];
        _priceLabel.font = [UIFont boldSystemFontOfSize:25.0];
    }
    return _priceLabel;
}

- (UILabel *)termsLabel{
    if (!_termsLabel) {
        _termsLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium13];
    }
    return _termsLabel;
}
- (UILabel *)datetimeLabel{
    if (!_datetimeLabel) {
        _datetimeLabel = [UILabel lz_labelWithTitle:@"" color:kTextColor51 font:kFontSizeMedium13];
    }
    return _datetimeLabel;
}


- (TXPaintView *)paintView{
    if (!_paintView) {
        _paintView = [[TXPaintView alloc] init];
        _paintView.lineWidth = 2.0f;
        _paintView.lineColor = kTextColor51;
    }
    return _paintView;
}
@end
