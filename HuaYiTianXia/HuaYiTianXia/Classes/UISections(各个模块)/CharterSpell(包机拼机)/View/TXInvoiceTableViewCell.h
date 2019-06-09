//
//  TXInvoiceTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/9.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXInvoiceTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, assign) BOOL isSelected;
- (void) updateCellWithState:(BOOL)select;
@end

NS_ASSUME_NONNULL_END
