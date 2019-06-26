//
//  TXNewMultipleImageTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/26.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXNewMultipleImageTableViewCell : UITableViewCell
/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
