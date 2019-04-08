//
//  TTPickerListView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/8.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTPickerListView;
@class TTPickerModel;
@protocol TTPickerListViewDelegate<NSObject>
- (void)tt_pickerListView:(TTPickerListView *)pickerListView didSelcetedValue:(TTPickerModel *)value;
@end
@interface TTPickerListView : UIView

/// 数据源
@property (nonatomic , strong) NSArray * dataArray;

/// 已选择的字符串
@property (nonatomic , copy) NSString * selectText;
@property (nonatomic , weak) id<TTPickerListViewDelegate>  delegate;
@end
