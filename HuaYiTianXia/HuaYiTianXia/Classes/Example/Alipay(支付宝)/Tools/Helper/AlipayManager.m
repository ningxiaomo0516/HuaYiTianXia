//
//  AlipayManager.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/11.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "AlipayManager.h"

@implementation AlipayManager

#pragma mark - 进行支付
+ (void)doAlipayPay:(TXGeneralModel *) model{
    /// 重要说明
    /// 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    /// 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    
    // NOTE: 调用支付结果开始支付-支付结果在AppDelegate.m方法中走，这里不会打印
    // NOTE: 网页支付走的是这里的回调
    [[AlipaySDK defaultService] payOrder:model.obj fromScheme:kAppScheme callback:^(NSDictionary *resultDic) {
        __block NSString *strMsg = @"";
        __block NSString *msgStr = @"";
        TTLog(@"网页支付走的是这里的回调 - reslut = %@",resultDic);
        // 解析 auth code
        NSString *resultStatus = resultDic[@"resultStatus"];
        if ([resultStatus isEqualToString:@"9000"]) {
            strMsg = @"订单支付成功!";
            // 发送支付成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"YKAlipaySuccessfull" object:nil];
        }else if ([resultStatus isEqualToString:@"4000"]) {
            
            strMsg = @"订单支付失败!";
            msgStr = @"订单支付失败!error_code = 4000";
        }else if ([resultStatus isEqualToString:@"5000"]) {
            
            strMsg = @"重复请求!";
            msgStr = @"重复请求!error_code = 5000";
        }else if ([resultStatus isEqualToString:@"6001"]) {
            
            strMsg = @"用户中途取消!";
            msgStr = @"用户中途取消!error_code = 6001";
        }else if ([resultStatus isEqualToString:@"6002"]) {
            
            strMsg = @"网络连接出错!";
            msgStr = @"网络连接出错!error_code = 6002";
        }else if ([resultStatus isEqualToString:@"6004"]) {
            
            strMsg = @"支付结果未知";
            msgStr = @"支付结果未知(有可能已经支付成功)，请查询商户订单列表中的订单支付状态error_code = 6004";
        }
        
        Toast(strMsg);
        TTLog(@"此处回调为网页支付 - msgStr - %@",msgStr);
    }];
}


+ (void)doWechatPay:(TXGeneralModel *) model{
    NSDictionary *dict = [Utils dictionaryWithJsonString:model.obj];
    OrderData *o = [OrderData mj_objectWithKeyValues:dict];
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = o.appid;
    /** 商家向财付通申请的商家id */
    req.partnerId           = o.partnerid;
    /** 预支付订单 */
    req.prepayId            = o.prepayid;
    /** 随机串，防重发 */
    req.nonceStr            = o.noncestr;
    /** 时间戳，防重发 */
    req.timeStamp           = [o.timestamp intValue];
    /** 商家根据财付通文档填写的数据和签名(//这个比较特殊，是固定的，只能是即req.package = Sign=WXPay)*/
    req.package             = @"Sign=WXPay";
    /** 商家根据微信开放平台文档对数据做的签名 */
    req.sign                = o.sign;
    [WXApi sendReq:req];
    //日志输出
    TTLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",o.appid,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
}
@end
