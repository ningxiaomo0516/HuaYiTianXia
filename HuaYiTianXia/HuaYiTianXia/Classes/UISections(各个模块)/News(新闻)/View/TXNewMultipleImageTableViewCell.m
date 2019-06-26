//
//  TXNewMultipleImageTableViewCell.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/26.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXNewMultipleImageTableViewCell.h"

@implementation TXNewMultipleImageTableViewCell

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
    static NSString *reuseIdentifier = @"TXNewMultipleImageTableViewCell";
    return reuseIdentifier;
}

/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = [TXNewMultipleImageTableViewCell reuseIdentifier];
    TXNewMultipleImageTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    return tools;
}
@end
