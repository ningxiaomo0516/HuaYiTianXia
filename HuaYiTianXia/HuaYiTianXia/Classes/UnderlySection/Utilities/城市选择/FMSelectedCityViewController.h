//
//  FMSelectedCityViewController.h
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/8/1.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"
typedef void(^ReturnCityName)(NSString *cityname);

@interface FMSelectedCityViewController : TTBaseViewController
@property (nonatomic, copy) ReturnCityName returnBlock;
- (void)returnText:(ReturnCityName)block;
@end
