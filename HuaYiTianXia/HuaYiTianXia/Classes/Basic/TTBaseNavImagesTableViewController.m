//
//  TTBaseNavImagesTableViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/21.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTBaseNavImagesTableViewController.h"
#import "TTBaseSectionHeaderView.h"

@interface TTBaseNavImagesTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度

@end

@implementation TTBaseNavImagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height) {
        return height.floatValue;
    } else {
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) return 0;
    return 10;
}

#pragma mark -- Section HearderView Title
// UITableView在Plain类型下，HeaderView和FooterView不悬浮和不停留的方法viewForHeaderInSection
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TTBaseSectionHeaderView *sectionView = [[TTBaseSectionHeaderView alloc] init];
    sectionView.section = section;
    sectionView.tableView = tableView;
    return sectionView;
}

#pragma mark - Getters
- (NSMutableDictionary *)heightAtIndexPath{
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionary];
    }
    return _heightAtIndexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
