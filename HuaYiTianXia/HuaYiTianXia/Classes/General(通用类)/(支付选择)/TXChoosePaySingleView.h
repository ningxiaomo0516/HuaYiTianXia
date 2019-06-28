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

typedef void(^ChoosePayBlock) (ChoosePayModel *model);

@interface TXChoosePaySingleView : UIView<UITableViewDataSource,UITableViewDelegate>
/// 列表
@property(nonatomic, strong)    UITableView     *tableView;
/// 数据数组
@property(nonatomic, strong)    NSMutableArray  *dataArray;
/// 当前选中的indexPath
@property(nonatomic, strong)    NSIndexPath     *currentSelectIndex;
/// 选中的数据回调
@property(nonatomic, copy)      ChoosePayBlock  chooseBlock;
/// 选中的内容ID下标
@property(nonatomic, assign)    NSInteger       index;
/// 初始化
+ (TXChoosePaySingleView *) initTableWithFrame:(CGRect)frame;
- (void)reloadData;
@end


@interface TXChoosePayCell : UITableViewCell
/// 图片
@property (nonatomic, strong) UIImageView   *imagesView;
/// 标题
@property (nonatomic, strong) UILabel       *titleLabel;
/// 选中按钮
@property (nonatomic, strong) UIButton      *selectBtn;
/// 记录选中状态
@property (nonatomic, assign) BOOL          isSelected;
/// 更新选中效果
- (void) updateCellWithStatus:(BOOL)select;
@property (nonatomic, strong) ChoosePayModel *payModel;

/// Cell视图的缓存池标示
+ (NSString *)reuseIdentifier;
/// 获取Cell视图对象
+ (instancetype)cellWithTableViewCell:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
@end

@interface ChoosePayModel : NSObject
/// 支付方式ID
@property (nonatomic, copy) NSString *kid;
/// 支付方式名称
@property (nonatomic, copy) NSString *titleName;
/// 支付方式图片
@property (nonatomic, copy) NSString *imageName;
@end

@interface TXChoosePayHeaderView : UITableViewHeaderFooterView
@property NSUInteger section;
@property (nonatomic, weak) UITableView *tableView;
/// 显示的标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 分割线
@property (nonatomic, strong) UIView *linerView;
@end
NS_ASSUME_NONNULL_END
