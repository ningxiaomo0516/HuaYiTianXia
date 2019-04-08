//
//  TTPickerModel.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/8.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPickerModel : NSObject
@property (nonatomic ,copy) NSString *pid;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,strong) NSArray *child;
@end
