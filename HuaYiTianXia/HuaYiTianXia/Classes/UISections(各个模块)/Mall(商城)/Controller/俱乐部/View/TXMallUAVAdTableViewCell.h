//
//  TXMallUAVAdTableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/13.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^TXMallUAVAdTableViewCellBlock) (MallUAVListModel *listModel);
@interface TXMallUAVAdTableViewCell : UICollectionViewCell
@property (nonatomic, strong) MallUAVModel *listModel;
//定义一个block
@property (nonatomic, copy) TXMallUAVAdTableViewCellBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
