//
//  TXNewsModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/27.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TXNewsTabModel,NewsModel,NewsRecordsModel,NewsBannerModel;
@interface TXNewsModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) NSMutableArray<TXNewsTabModel *> *data;
@end

@interface TXNewsTabModel : NSObject
/// Tab ID
@property (nonatomic, copy) NSString *kid;
/// Tab 标题
@property (nonatomic, copy) NSString *titleName;
@end

@interface TXNewsArrayModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
@property (nonatomic, strong) NewsModel *data;
/// banner 集合
@property (nonatomic, strong) NSMutableArray<NewsBannerModel *> *banners;
@end

@interface NewsModel : NSObject
/// 当前页
@property (nonatomic, assign) NSInteger current;
/// 总页数
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger searchCount;
/// 每页条数
@property (nonatomic, assign) NSInteger size;
/// 总条数
@property (nonatomic, assign) NSInteger total;
/// records 新闻列表集合
@property (nonatomic, strong) NSMutableArray<NewsRecordsModel *> *records;

//// 详情接口
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
/// 产品详情Model数据
@property (nonatomic, strong) NSMutableArray<NewsRecordsModel *> *data;

/// 跑马灯接口
@property (nonatomic, copy) NSString *content;

@end

@interface NewsRecordsModel : NSObject
//    purchaseType    是    int    支付类型 0：充值； 1：无人机商城产品；2：农用植保产品； 3：VR产品 4：纵横矿机产品 5：共享飞行产品; 6：天合成员充值；7：生态农业商城产品（消费）

/**
 *  purchaseType 参数说明
 *  0:充值; 1:无人机商城产品; 2:农用植保产品; 3:VR产品
 *  4:纵横矿机产品 5:共享飞行产品; 6:天合成员充值;7:生态农业商城产品（消费）
 */
@property (nonatomic, assign) NSInteger purchaseType;
//// --------------- 礼包 model --------------- ////
@property (nonatomic, copy) NSString *pname;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *timestamp;

//// --------------- new model --------------- ////
/// 新闻ID(产品id)
@property (nonatomic, copy) NSString *kid;
/// 新闻 图片地址
@property (nonatomic, copy) NSString *img;
/// 新闻 发布的时间戳
@property (nonatomic, assign) NSInteger time;
/// 新闻 标题
@property (nonatomic, copy) NSString *title;
/// 新闻 简介(内容)（详情HTML）
@property (nonatomic, copy) NSString *content;

//// --------------- mall model --------------- ////
/// 颜色数组（首页 取第一个）
@property (nonatomic, strong) NSArray *color;
/// 产品封面图
@property (nonatomic, copy) NSString *coverimg;
/// 产品价格
@property (nonatomic, copy) NSString *price;
/// 产品规格《规格数组（首页取第一个）》
@property (nonatomic, strong) NSArray *prospec;
/// 商城简介(详情内容)
@property (nonatomic, copy) NSString *synopsis;
/// 1：无人机商城产品（消费）；2：农用植保产品（购买）；3：VR产品（购买）；4：纵横矿机产品（购买）；5：共享飞行产品（购买）；6：生态农业商城产品（消费）
@property (nonatomic, assign) NSInteger status;

/// 购买产品的总价格
@property (nonatomic, copy) NSString *totalPrice;

//// --------------- 产品详情 --------------- ////
/// 库存
@property (nonatomic, assign) NSInteger spec;
/// banner 集合
@property (nonatomic, strong) NSMutableArray<NewsBannerModel *> *banners;
/// 支付中心需要的购买数量
@property (nonatomic, assign) NSInteger buyCount;

@end

@interface NewsBannerModel : NSObject
/// bannerID
@property (nonatomic, copy) NSString *kid;
/// banner 图片地址
@property (nonatomic, copy) NSString *img;
/// 产品详情 banner 图片地址
@property (nonatomic, copy) NSString *imageText;
/// banner 标题
@property (nonatomic, copy) NSString *title;
/// 是否需要显示 banner title yes 需要显示 no 不需要显示
@property (nonatomic, assign) BOOL isBannerTitle;
@end


NS_ASSUME_NONNULL_END
