//
//  SCDropDownMenu.h
//  CSDropDownMenu
//
//  Created by 宁小陌 on 2018/5/16.
//  Copyright © 2018年 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for SCDropDownMenu.
FOUNDATION_EXPORT double SCDropDownMenuVersionNumber;

//! Project version string for SCDropDownMenu.
FOUNDATION_EXPORT const unsigned char SCDropDownMenuVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SCDropDownMenu/PublicHeader.h>
#import "SCIndexPatch.h"
#import "SCDropDownMenuView.h"
#import "SCDropDownMenuCollectionViewCell.h"



/**
 
NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@"婚纱摄影", @"婚礼策划", @"婚纱礼服", @"婚宴酒店", nil];
NSMutableArray *array2 = [NSMutableArray arrayWithObjects:@"全城", @"武侯区", @"高新区", @"金牛区", @"锦江区", @"青羊区", @"新都区", @"温江区",@"郫都区" nil];
NSMutableArray *array3 = [NSMutableArray arrayWithObjects:@"综合排序", @"保障最好", @"作品最多", @"人气最高", nil];
NSArray *array11 = @[@[@"婚纱影楼",@"摄影工作室", @"儿童摄影"],@[@"婚礼策划"],@[@"婚纱礼服"],@[@"婚宴酒店"]];
NSArray *array11 = @[@[@"婚纱影楼",@"摄影工作室",@"儿童摄影"], @[@"婚礼策划",@"婚纱礼服",@"新娘跟妆",@"婚礼跟拍",@"婚礼司仪"],
                      @[@"五星级酒店",@"四星级酒店",@"三星级酒店",@"二星级酒店",@"特色餐厅",@"主题会所"]];
 NSMutableArray *data1 = [NSMutableArray arrayWithObjects:array1, array2, array3, nil];
 NSMutableArray *data2 = [NSMutableArray arrayWithObjects:array11, array22, @[], nil];
 SCDropDownMenuView *menu = [[SCDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40) firstArray:data1 secondArray:data2];
 menu.delegate = self;
 menu.separatorColor = kColorWithRGB(221, 221, 221);
 menu.bottomLineView.hidden = YES;
 menu.cellSelectBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
 menu.ratioLeftToScreen = 0.35;
 [self.view addSubview:menu];
 /// 风格
menu.menuStyleArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:SCDropDownMenuStyleTableView],
                       [NSNumber numberWithInteger:SCDropDownMenuStyleTableView],
                       [NSNumber numberWithInteger:SCDropDownMenuStyleTableView], nil];
 
 
 
 */
