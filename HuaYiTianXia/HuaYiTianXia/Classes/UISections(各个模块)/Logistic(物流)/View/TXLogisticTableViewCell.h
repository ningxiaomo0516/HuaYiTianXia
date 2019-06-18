//
//  TXLogisticTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/14.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXLogisticTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *date_label;
@property (nonatomic, strong) UILabel *time_label;

@property (nonatomic, strong) UIImageView *imagesView;

@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) UILabel *subtitle_label;
@property (nonatomic, strong) UIView *linerView;
@end

NS_ASSUME_NONNULL_END
