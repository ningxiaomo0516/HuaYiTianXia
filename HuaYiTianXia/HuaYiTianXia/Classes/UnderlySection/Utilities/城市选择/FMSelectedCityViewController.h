//
//  FMSelectedCityViewController.h
//  FlowersMarry
//
//  Created by 宁小陌 on 2018/8/1.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import "TTBaseViewController.h"
#import "FMSelectedCityModel.h"

typedef void(^ReturnCityName)(CityModel *cityModel);

@interface FMSelectedCityViewController : TTBaseViewController
@property (nonatomic, strong) ReturnCityName returnBlock;
- (void)returnText:(ReturnCityName)block;
@end
