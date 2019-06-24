//
//  URLDefine.m
//  MerchantVersion
//
//  Created by 寜小陌 on 2018/1/19.
//  Copyright © 2018年 寜小陌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLDefine.h"


/// 支付是8081，其他是8082
//NSString *const DynamicUrl = @"http://beta.api2.wed114.cn/?s=";
NSString *const DynamicUrl = @"http://192.168.1.14:8080/hytx/";
//NSString *const DynamicUrl = @"http://192.168.1.20:80/hytx/";
//NSString *const DynamicUrl = @"http://47.107.179.43:80/hytx/";


//NSString *const DomainName = @"http://47.107.179.43:80/";
//NSString *const DomainName = @"http://192.168.1.20:80/";
NSString *const DomainName = @"http://192.168.1.14:8080/";

NSString *const imageBaseUrl = @"//pic11.wed114.cn/";
/*
新闻详情:http://47.107.179.43/yq/invation/newDetails.html?id=78
商品详情 ：http://47.107.179.43/yq/invation/goodsDetails.html?id=59&status=1
id为商品id，status为商品类型（（1：无人机商城产品（消费）；2：农用植保产品（购买）；3：VR产品（购买）；
                            4：纵横矿机产品（购买）；5：共享飞行产品（购买）；6：生态农业商城产品（消费）））
推荐邀请： http://47.107.179.43/yq/invation/invataion.html?id=1064    id为该会员账号的id
用户协议：http://47.107.179.43/userHelp/userAgree.html
操作手册： http://47.107.179.43/userHelp
一县一代理： http://47.107.179.43/agencyCompany/
合同协议 ： http://47.107.179.43/yq/invation/vrAgreement.html
民航共享： http://47.107.179.43/yq/invation/ndex.html
合作协议：http://47.107.179.43/yq/invation/cooperationAgreement.html
推送详情: http://47.107.179.43/userHelp/allDetails.html
包机详情: http://47.107.179.43/userHelp/flightDetails.html?id=1
积分不足帮助：http://47.107.179.43/userHelp/vhHelp.html
*/
/// 推送详情
NSString *const PushDetailsH5           = @"userHelp/allDetails.html?id=";
/// 新闻详情
NSString *const NewsDetailsH5           = @"yq/invation/newDetails.html?id=";
/// 商品详情
NSString *const GoodsDetailsH5          = @"yq/invation/goodsDetails.html?id=";
/// 推荐邀请
NSString *const InvataionH5             = @"yq/invation/invataion.html?id=";
/// 用户协议
NSString *const UserAgreeH5             = @"userHelp/userAgree.html";
/// 操作手册
NSString *const UserHelpH5              = @"userHelp";
/// 一县一代理(农用植保)
NSString *const AgencyCompanyH5         = @"agencyCompany";
/// 合同协议
NSString *const vrAgreementH5           = @"yq/invation/vrAgreement.html";
/// 民航共享
NSString *const AviationShareH5         = @"yq/invation/ndex.html";
/// 合作协议
NSString *const CooperationAgreementH5  = @"/userHelp/lookNyzbAgrement.html?id=";
/// 农保电子协议
NSString *const NBElectronicAgreementH5 = @"userHelp/nyzbAgrement.html?id=";
/// 培训详情(课程网页)
NSString *const CourseDetailsH5         = @"userHelp/flightProductDetails.html?id=";
/// 包机详情
NSString *const CharterDetailsH5        = @"userHelp/flightDetails.html?id=";
/// 积分不足帮助
NSString *const VHHelpH5                = @"userHelp/vhHelp.html";


/// 0:测试环境 1:生产环境
NSString *const environment = @"1";

NSString *const indexSetting = @"";
/// 更改头像
NSString *const updateAvatar = @"user/changeavator";
/// 修改昵称
NSString *const updateNickname = @"/updateNickname";
/// 手机登陆
NSString *const login = @"index/mobilelogin";
/// 第三方账号登陆
NSString *const thirdAccountLogin = @"/thirdAccountLogin";
/// 绑定手机号
NSString *const bindAccount = @"/bindAccount";
/// 获取验证码
NSString *const getVerifyCode = @"/getVerifyCode";
/// token登陆
NSString *const tokenLogin = @"/tokenLogin";
/// 图片上传接口
NSString *const uploadFile = @"upload/codeImage";
/// 版本信息
//NSString *const versionManage = @"http://pandafile.sctv.com:42086/System/VersionManage/VersionManage.json";
NSString *const versionManage = @"http://47.107.179.43:80/hytx/upload/version";
/// 引导页
//NSString *const startPage = @"http://pandafile.sctv.com:42086/System/StartPage/StartPage.json";
NSString *const startPage = @"http://47.107.179.43:80/hytx/startadver/GetStartadver";
//NSString *const startPage = @"http://192.168.1.20:80/hytx/startadver/GetStartadver";

/// 获取熊猫钱包余额
NSString *const getPandaBalance = @"/getPandaBalance";
/// 帮助
NSString *const helpJson = @"http://pandafile.sctv.com:42086/System/FAQ/FAQ.json";
/// 登录协议
NSString *const loginProtocol = @"http://app.sctv.com/tv/info/201711/t20171128_3683480.shtml";





