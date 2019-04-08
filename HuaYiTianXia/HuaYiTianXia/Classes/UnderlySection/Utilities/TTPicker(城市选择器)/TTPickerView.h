//
//  TTPickerView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/8.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTPickerView;
@class TTPickerModel;
@protocol TTPickerViewDelegate<NSObject>

/**
 *  点击Cell的回调  返回下一个视图需要的数据数组
 *  @param pickerView description
 *  @param tier 点击的第几层
 *  @param value 点击那一列的数据
 */
- (NSMutableArray<TTPickerModel *> *)tt_pickerView:(TTPickerView *)pickerView didSelcetedTier:(NSInteger)tier  selcetedValue:(TTPickerModel *)value;

/**
 *  完成时候的回调
 *
 *  @param TTPickerView TTPickerView description
 *  @param complete 完成时候返回拼接的字符串
 */
@required
- (void)tt_pickerView:(TTPickerView *)pickerView completeArray:(NSMutableArray<TTPickerModel *> *)comArray completeStr:(NSString *)comStr;

@end


@interface TTPickerView : UIView

@property (nonatomic , weak) id<TTPickerViewDelegate>  delegate;

/// 选择窗的title
@property (nonatomic , copy) NSString * titleText;

/// 每一层的数据数组
@property (nonatomic , strong) NSArray<TTPickerModel *> *dataArray;


/**
 *  给每一层数据添加数据源 有默认选择的字符串   无默认选择的话推荐使用 setDataArray
 *
 *  @param dataArray 数据源
 *  @param Text 默认选择的字符串
 */
- (void)setData:(NSArray<TTPickerModel *> *)dataArray  selectText:(NSString *)Text;
@end
