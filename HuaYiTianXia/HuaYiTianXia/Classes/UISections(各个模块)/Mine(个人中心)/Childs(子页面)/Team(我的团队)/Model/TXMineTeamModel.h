//
//  TXMineTeamModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/5/23.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MineTeamDataModel,MineTeamModel;
@interface TXMineTeamModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
/// 产品详情Model数据
@property (nonatomic, strong) MineTeamDataModel *data;
@end

@interface MineTeamDataModel : NSObject
/// 团队表ID
@property (nonatomic, copy) NSString *kid;
/// 团队所以会员农保充值金额（需判断null，值为null时不显示）
@property (nonatomic, copy) NSString *money;
/// 团队名称
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, strong) NSMutableArray<MineTeamModel *> *list;
@end

@interface MineTeamModel : NSObject
/// 会员联系电话
@property (nonatomic, copy) NSString *mobile;
/// 会员名称
@property (nonatomic, copy) NSString *name;
/// 会员头像地址
@property (nonatomic, copy) NSString *headImg;
/// 会员已充值农保金额（需判断null，值为null时不显示）
@property (nonatomic, copy) NSString *asmoney;
@end


///--------- 团队列表 ---------///
@interface TeamModel : NSObject
/// 成员名称
@property (nonatomic, copy) NSString *name;
/// 团长名称
@property (nonatomic, copy) NSString *leaderName;
/// 团队ID
@property (nonatomic, copy) NSString *kid;
/// 成立时间
@property (nonatomic, copy) NSString *createTime;
@end


@interface TeamListModel : NSObject
@property (nonatomic, strong) NSMutableArray<TeamModel *> *list;
/// 总条数
@property (nonatomic, copy) NSString *total;
/// 每页条数
@property (nonatomic, copy) NSString *size;
/// 页码
@property (nonatomic, copy) NSString *current;
/// 总页数
@property (nonatomic, copy) NSString *pages;
@end

@interface TeamDataModel : NSObject
/// 状态 21000统一异常情况,22000登录超时，23000账号冻结，20000请求成功，另外的状态请直接输出msg
@property (nonatomic, copy) NSString *message;
/// 错误码
@property (nonatomic, assign) NSInteger errorcode;
/// 产品详情Model数据
@property (nonatomic, strong) TeamListModel *data;
@end
NS_ASSUME_NONNULL_END
