//
//  TXGoodsH5TableViewCell.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/2.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
//这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^RefreshWebViewCellHeightBlock) (CGFloat height);
@interface TXGoodsH5TableViewCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIScrollView *scrollView;

//定义一个block
@property (nonatomic, copy) RefreshWebViewCellHeightBlock refreshWebViewHeightBlock;
@end

NS_ASSUME_NONNULL_END
