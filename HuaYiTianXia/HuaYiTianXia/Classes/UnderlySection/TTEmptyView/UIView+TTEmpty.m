//
//  UIView+TTEmpty.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/7.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "UIView+TTEmpty.h"
#import <objc/runtime.h>
#import "TTEmptyView.h"

#pragma mark - ------------------ UIView ------------------
@implementation UIView (TTEmpty)
+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

#pragma mark - Setter/Getter

static char kEmptyViewKey;
- (void)setTt_emptyView:(TTEmptyView *)tt_emptyView{
    if (tt_emptyView != self.tt_emptyView) {
        
        objc_setAssociatedObject(self, &kEmptyViewKey, tt_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[TTEmptyView class]]) {
                [view removeFromSuperview];
            }
        }
        [self addSubview:self.tt_emptyView];
    }
}

- (TTEmptyView *)tt_emptyView{
    return  objc_getAssociatedObject(self, &kEmptyViewKey);
}

#pragma mark - Private Method (UITableView、UICollectionView有效)
- (NSInteger)totalDataCount {
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}
- (void)getDataAndSet{
    //没有设置emptyView的，直接返回
    if (!self.tt_emptyView) {
        return;
    }
    
    if ([self totalDataCount] == 0) {
        [self show];
    }else{
        [self hide];
    }
}

- (void)show{
    //当不自动显隐时，内部自动调用show方法时也不要去显示，要显示的话只有手动去调用 tt_showEmptyView
    if (!self.tt_emptyView.autoShowEmptyView) {
        self.tt_emptyView.hidden = YES;
        return;
    }
    
    [self tt_showEmptyView];
}

- (void)hide{
    if (!self.tt_emptyView.autoShowEmptyView) {
        self.tt_emptyView.hidden = YES;
        return;
    }
    [self tt_hideEmptyView];
}

#pragma mark - Public Method
- (void)tt_showEmptyView{
    
    [self.tt_emptyView.superview layoutSubviews];
    self.tt_emptyView.hidden = NO;
    
    //让 emptyBGView 始终保持在最上层
    [self bringSubviewToFront:self.tt_emptyView];
}
- (void)tt_hideEmptyView{
    self.tt_emptyView.hidden = YES;
}

- (void)tt_startLoading{
    self.tt_emptyView.hidden = YES;
}
- (void)tt_endLoading{
    self.tt_emptyView.hidden = [self totalDataCount];
}

@end

#pragma mark - ------------------ UITableView ------------------

@implementation UITableView (Empty)
+ (void)load{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(tt_reloadData)];
    
    ///section
    [self exchangeInstanceMethod1:@selector(insertSections:withRowAnimation:) method2:@selector(tt_insertSections:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(deleteSections:withRowAnimation:) method2:@selector(tt_deleteSections:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(reloadSections:withRowAnimation:) method2:@selector(tt_reloadSections:withRowAnimation:)];
    
    ///row
    [self exchangeInstanceMethod1:@selector(insertRowsAtIndexPaths:withRowAnimation:) method2:@selector(tt_insertRowsAtIndexPaths:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(deleteRowsAtIndexPaths:withRowAnimation:) method2:@selector(tt_deleteRowsAtIndexPaths:withRowAnimation:)];
    [self exchangeInstanceMethod1:@selector(reloadRowsAtIndexPaths:withRowAnimation:) method2:@selector(tt_reloadRowsAtIndexPaths:withRowAnimation:)];
}
- (void)tt_reloadData{
    [self tt_reloadData];
    [self getDataAndSet];
}

/// section
- (void)tt_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self tt_insertSections:sections withRowAnimation:animation];
    [self getDataAndSet];
}

- (void)tt_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self tt_deleteSections:sections withRowAnimation:animation];
    [self getDataAndSet];
}

- (void)tt_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
    [self tt_reloadSections:sections withRowAnimation:animation];
    [self getDataAndSet];
}

///row
- (void)tt_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self tt_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self getDataAndSet];
}

- (void)tt_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self tt_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self getDataAndSet];
}

- (void)tt_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    [self tt_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [self getDataAndSet];
}


@end

#pragma mark - ------------------ UICollectionView ------------------
@implementation UICollectionView (Empty)
+ (void)load{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(tt_reloadData)];
    
    ///section
    [self exchangeInstanceMethod1:@selector(insertSections:) method2:@selector(tt_insertSections:)];
    [self exchangeInstanceMethod1:@selector(deleteSections:) method2:@selector(tt_deleteSections:)];
    [self exchangeInstanceMethod1:@selector(reloadSections:) method2:@selector(tt_reloadSections:)];
    
    ///item
    [self exchangeInstanceMethod1:@selector(insertItemsAtIndexPaths:) method2:@selector(tt_insertItemsAtIndexPaths:)];
    [self exchangeInstanceMethod1:@selector(deleteItemsAtIndexPaths:) method2:@selector(tt_deleteItemsAtIndexPaths:)];
    [self exchangeInstanceMethod1:@selector(reloadItemsAtIndexPaths:) method2:@selector(tt_reloadItemsAtIndexPaths:)];
    
}

- (void)tt_reloadData{
    [self tt_reloadData];
    [self getDataAndSet];
}

/// section
- (void)tt_insertSections:(NSIndexSet *)sections{
    [self tt_insertSections:sections];
    [self getDataAndSet];
}
- (void)tt_deleteSections:(NSIndexSet *)sections{
    [self tt_deleteSections:sections];
    [self getDataAndSet];
}
- (void)tt_reloadSections:(NSIndexSet *)sections{
    [self tt_reloadSections:sections];
    [self getDataAndSet];
}

///item
- (void)tt_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self tt_insertItemsAtIndexPaths:indexPaths];
    [self getDataAndSet];
}
- (void)tt_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self tt_deleteItemsAtIndexPaths:indexPaths];
    [self getDataAndSet];
}
- (void)tt_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    [self tt_reloadItemsAtIndexPaths:indexPaths];
    [self getDataAndSet];
}
@end
