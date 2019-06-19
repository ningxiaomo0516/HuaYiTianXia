//
//  TXLogisticProductCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/14.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXLogisticModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXLogisticProductCell : UITableViewCell

@property (nonatomic, strong) UIImageView   *imagesView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *subtitleLabel;
@property (nonatomic, strong) UILabel       *order_label_no;
@property (nonatomic, strong) UILabel       *courier_label;
@property (nonatomic, strong) UILabel       *address_label;


@property (nonatomic, strong) UILabel       *order_label_no_title;
@property (nonatomic, strong) UILabel       *courier_label_title;
@property (nonatomic, strong) UILabel       *address_label_title;


@property (nonatomic, strong) LogisticData  *logisticData;
@end

NS_ASSUME_NONNULL_END
