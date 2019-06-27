//
//  TXChoosePaySingleView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/6/27.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ChoosePayModel;

typedef void(^ChoosePayBlock) (NSString *chooseContent,NSString *muiscID);

@interface TXChoosePaySingleView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)    UITableView     *tableView;
@property(nonatomic, strong)    NSMutableArray  *dataArray;
@property(nonatomic, strong)    NSIndexPath     *currentSelectIndex;
@property(nonatomic, copy)      ChoosePayBlock  chooseBlock;
@property(nonatomic, strong)    NSString        *chooseContent;
+ (TXChoosePaySingleView *) initTableWithFrame:(CGRect)frame;
- (void)reloadData;
@end


@interface TXChoosePayCell : UITableViewCell
@property (nonatomic, strong) UIImageView   *imagesView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIButton      *selectBtn;
@property (nonatomic, assign) BOOL          isSelected;
- (void) updateCellWithStatus:(BOOL)select;
@property (nonatomic, strong) ChoosePayModel *payModel;

@end

@interface ChoosePayModel : NSObject
//// 支付方式ID
@property (nonatomic, copy) NSString *kid;
/// 支付方式名称
@property (nonatomic, copy) NSString *titleName;
/// 支付方式图片
@property (nonatomic, copy) NSString *imageName;
@end
NS_ASSUME_NONNULL_END
