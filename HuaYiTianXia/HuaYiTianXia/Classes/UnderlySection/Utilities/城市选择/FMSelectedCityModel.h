//
//  FMSelectedCityModel.h
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/8/1.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CityDataModel,CityGroupsModel,CityModel;
@interface FMSelectedCityModel : NSObject
/// 状态 success/failed
@property (nonatomic, copy) NSString *status;
/// 错误码
@property (nonatomic, assign) NSInteger errcode;
///     "sid": "got8at6g7t6v2o0mlbsq1lvp71"
@property (nonatomic, copy) NSString *sid;
/// 文字提示
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) CityDataModel *data;
@end

@interface CityDataModel : NSObject
@property (nonatomic, strong) CityModel *current;
@property (nonatomic, strong) NSMutableArray<CityModel *> *hots;
@property (nonatomic, strong) NSMutableArray<CityGroupsModel *> *groups;
@end

@interface CityGroupsModel : NSObject

@property (nonatomic, copy) NSString *g;
@property (nonatomic, strong) NSMutableArray<CityModel *> *list;


@end

@interface CityModel : NSObject
/// 站点ID
@property (nonatomic, copy) NSString *site_id;
/// 城市ID
@property (nonatomic, copy) NSString *city_id;
/// 省ID
@property (nonatomic, copy) NSString *province_id;
/// 城市名称
@property (nonatomic, copy) NSString *site_name;
/// 简称(站点域名)
@property (nonatomic, copy) NSString *site_domain;
/// 当前站点拥有的导航条。
/// 1=婚纱摄影,3 => '婚宴酒店', 21 => '婚礼策划',
/// 22 => '婚纱礼服',23 => '新娘跟妆',24 => '婚礼跟拍',25 => '婚礼司仪', 93 => '论坛',
@property (nonatomic, copy) NSString *site_nav;
@property (nonatomic, assign) NSInteger site_ishot;
/// 城市首字母
@property (nonatomic, copy) NSString *g;



/// id
@property (nonatomic, copy) NSString *kid;
/// 机场码
@property (nonatomic, copy) NSString *airportCode;
/// 城市码
@property (nonatomic, copy) NSString *cityCode;
/// 是否热门
@property (nonatomic, copy) NSString *isHot;
/// D:国内 I:国外
@property (nonatomic, copy) NSString *airportPosition;
/// 机场英文名
@property (nonatomic, copy) NSString *airportEName;
/// 机场中文名
@property (nonatomic, copy) NSString *airportCName;
/// 城市中文名
@property (nonatomic, copy) NSString *cityCName;
/// 城市英文名
@property (nonatomic, copy) NSString *cityEName;
/// 城市首字母
@property (nonatomic, copy) NSString *picPath;
/// 区域码
@property (nonatomic, copy) NSString *areaCode;
/// 省码
@property (nonatomic, copy) NSString *countryCode;
/// 机场描述
@property (nonatomic, copy) NSString *airportDes;

@end


@interface YKCityModel : NSObject
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
/// 文字提示
@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSMutableArray<CityModel *> *list;
@end
