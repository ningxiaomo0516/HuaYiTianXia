//
//  TXTeamTableView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/24.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXMineTeamModel.h"

NS_ASSUME_NONNULL_BEGIN
// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^JionTypeBlock) (TeamModel *teamModel);
@interface TXTeamTableView : UITableView
- (id)initWithFrame:(CGRect)frame controller:(UIViewController *)vc;

//定义一个block
@property (nonatomic, copy) JionTypeBlock typeBlock;
@end

NS_ASSUME_NONNULL_END
