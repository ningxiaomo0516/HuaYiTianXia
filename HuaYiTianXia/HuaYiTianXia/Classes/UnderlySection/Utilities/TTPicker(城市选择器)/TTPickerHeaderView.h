//
//  TTPickerHeaderView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/8.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTPickerHeaderView;
@protocol TTPickerHeaderViewDelegate<NSObject>
- (void)tt_pickerHeaderView:(TTPickerHeaderView *)pickerHeaderView didSelcetIndex:(NSInteger )index;
@end
@interface TTPickerHeaderView : UIView
@property (nonatomic , weak) id<TTPickerHeaderViewDelegate> dalegate;
@property (nonatomic , strong) NSArray * dataArray;
@property (nonatomic , assign) BOOL  isLastRed;//最后一个时候是红色

- (void)setindex:(NSInteger )index;
@end
