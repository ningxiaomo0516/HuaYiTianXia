//
//  TXVersionViewController.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/18.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXVersionModel.h"
#import "TXAdsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXVersionViewController : UIViewController
//@property(nonatomic,strong)TXVersionModel *versionModel;
//@property(nonatomic,strong)NSArray *adsArray;
@property(nonatomic,strong)NSMutableArray *adsArray;
@property(nonatomic,strong)TTVersionModel *versionModel;
- (void)updateAllData;
@end

NS_ASSUME_NONNULL_END
