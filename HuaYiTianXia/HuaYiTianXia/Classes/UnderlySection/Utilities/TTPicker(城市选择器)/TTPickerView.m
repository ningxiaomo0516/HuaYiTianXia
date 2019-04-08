//
//  TTPickerView.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/8.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TTPickerView.h"
#import "TTPickerListView.h"
#import "TTPickerHeaderView.h"
#import "TTPickerModel.h"
static NSInteger const headerHeight = 35;//headerView的高度
static NSInteger const ScrollViewY = 70;//ScrollViewY Y坐标起始位
static NSInteger const PickerViewHeight = 350;//

@interface TTPickerView ()<TTPickerListViewDelegate,TTPickerHeaderViewDelegate,TTPickerHeaderViewDelegate,UIScrollViewDelegate>
@property (nonatomic , strong) UIScrollView         *scrollView;
@property (nonatomic , strong) UILabel              *titleLabel;
@property (nonatomic , strong) TTPickerHeaderView   *header;
@property (nonatomic , strong) NSMutableArray       *headerDataArray;//装有title的数组
@property (nonatomic , strong) NSMutableArray       *listViewArray;//装有listView的数组
@property (nonatomic , strong) NSMutableArray       *dataArrays;//装有数据数组的数组
@end
@implementation TTPickerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0;
        self.headerDataArray = [NSMutableArray array];
        self.listViewArray = [NSMutableArray array];
        self.dataArrays = [NSMutableArray array];
        [self initForm];
    }
    return self;
}
- (void)initForm{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
    
    UIView * BGView = [[UIView alloc]initWithFrame:self.bounds];
    BGView.backgroundColor = [UIColor blackColor];
    BGView.alpha = 0.5;
    [self addSubview:BGView];
    
    UIView *ContentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 350, self.width, 350)];
    ContentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:ContentView];

    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10,self.width , 15)];
    self.titleLabel.textColor = kTextColor102;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [ContentView addSubview:self.titleLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.width - 60, 0, 60, 40);
    [button setImage:kGetImage(@"c31_btn_close") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hiddenClick) forControlEvents:UIControlEventTouchUpInside];
    [ContentView addSubview:button];
    
    self.header = [[TTPickerHeaderView alloc]initWithFrame:CGRectMake(0, 40, self.width, headerHeight)];
    self.header.backgroundColor = kWhiteColor;
    self.header.dalegate = self;
    self.header.dataArray = @[@"请选择"];
    self.header.isLastRed = YES;
    [ContentView addSubview:self.header];
    
    [ContentView  addSubview:self.scrollView];
}

//scrollview滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = (int)(scrollView.contentOffset.x/self.width);
    [self.header setindex:index];
}

//headerView头部点击
- (void)tt_pickerHeaderView:(TTPickerHeaderView *)pickerHeaderView didSelcetIndex:(NSInteger)index{
    [self.scrollView setContentOffset:CGPointMake(self.width*index,0) animated:YES];
}

//listView列表点击
- (void)tt_pickerListView:(TTPickerListView *)pickerListView didSelcetedValue:(TTPickerModel *)value {
    self.dataArrays  = [self.dataArrays subarrayWithRange:NSMakeRange(0, pickerListView.tag + 1)].mutableCopy;
    self.headerDataArray  = [self.headerDataArray subarrayWithRange:NSMakeRange(0, pickerListView.tag)].mutableCopy;
    [self.headerDataArray addObject:value.name];
    [self.headerDataArray addObject:@"请选择"];
    NSMutableArray<TTPickerModel *> * array;
    if ([self.delegate respondsToSelector:@selector(tt_pickerView:didSelcetedTier:selcetedValue:)]) {
        array = [self.delegate tt_pickerView:self didSelcetedTier:pickerListView.tag selcetedValue:value];
        if (array.count>0) {
            self.dataArray = array;
        }
    }
    if (array.count ==0 ) {
        [self.headerDataArray removeLastObject];
        [self hiddenClick];
    }
    if (array.count ==0 && [self.delegate respondsToSelector:@selector(tt_pickerView:completeArray:completeStr:)]) {
        [self.delegate tt_pickerView:self completeArray:self.dataArrays completeStr:[self.headerDataArray componentsJoinedByString:@""]];
    }
    self.header.dataArray = self.headerDataArray;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,ScrollViewY, self.width, PickerViewHeight  - ScrollViewY)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (void)setDataArray:(NSArray<TTPickerModel *> *)dataArray{
    [self manageDataArray:dataArray selectText:@""];
}

- (void)setTitleText:(NSString *)titleText{
    self.titleLabel.text = titleText;
}

- (void)setData:(NSArray<TTPickerModel *> *)dataArray selectText:(NSString *)Text{
    [self.headerDataArray addObject:Text];
    [self.headerDataArray removeObject:@"请选择"];
    self.header.dataArray = self.headerDataArray;
    [self manageDataArray:dataArray selectText:Text];
}

- (void)manageDataArray:(NSArray *)dataArray  selectText:(NSString *)Text{
    [self.dataArrays addObject:dataArray];
    
    TTPickerListView *listView = [[TTPickerListView alloc]initWithFrame:CGRectMake((self.width *(self.dataArrays.count - 1)),0,self.width, PickerViewHeight  - ScrollViewY)];
    listView.delegate = self;
    listView.tag = self.dataArrays.count - 1;
    listView.selectText = Text;
    listView.dataArray = dataArray;
    [self.scrollView addSubview:listView];
    self.scrollView.contentSize = CGSizeMake(self.width *self.dataArrays.count, 0);
    [self.scrollView setContentOffset:CGPointMake((self.width *(self.dataArrays.count - 1)),0) animated:YES];
    [self.listViewArray addObject:listView];
}

- (void)hiddenClick{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
