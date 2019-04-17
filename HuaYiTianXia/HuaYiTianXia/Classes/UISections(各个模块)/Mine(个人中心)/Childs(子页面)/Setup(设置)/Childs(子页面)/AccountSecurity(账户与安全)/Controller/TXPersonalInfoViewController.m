//
//  TXPersonalInfoViewController.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/3/20.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import "TXPersonalInfoViewController.h"
#import "TXMineTableViewCell.h"
#import "TXGeneralModel.h"
#import "TXModifyUserInfoViewController.h"
#import "SCImagePicker.h"

static NSString * const reuseIdentifier = @"TXMineTableViewCell";


@interface TXPersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SCImagePicker *imagePicker;
@property (nonatomic, copy) NSString *imageText;
@end

@implementation TXPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void) initView{
    [Utils lz_setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

/// 更新x上传的图片地址
- (void) imageURLReload{
    MV(weakSelf)
    [self.imagePicker sc_pickWithTarget:self completionHandler:^(UIImage *image, NSString *imageURL) {
        TTLog(@"image -- %@",image);
        weakSelf.imageText = imageURL;
        [weakSelf saveAvatarData];
    }];
}

- (void) saveAvatarData{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:kUserInfo.username forKey:@"nickName"];
    [parameter setObject:self.imageText forKey:@"headImg"];
    //    [MBProgressHUD showMessage:@"" toView:self.view];
    [SCHttpTools postWithURLString:kHttpURL(@"customer/UpdateUserData") parameter:parameter success:^(id responseObject) {
        NSDictionary *result  = responseObject;
        //        [MBProgressHUD hideHUDForView:self.view];
        kMBShowHUD(@"上传中...");
        TTLog(@" result --- %@",[Utils lz_dataWithJSONObject:result]);
        if (result){
            TXGeneralModel *model = [TXGeneralModel mj_objectWithKeyValues:result];
            if (model.errorcode==20000) {
                kUserInfo.avatar = self.imageText;
                [kUserInfo dump];
                [self.tableView reloadData];
                [kNotificationCenter postNotificationName:@"reloadUserName" object:nil];
                Toast(@"头像修改成功");
            }else{
                Toast(model.message);
            }
        }
        kMBHideHUD;
    } failure:^(NSError *error) {
        //        [MBProgressHUD hideHUDForView:self.view];
        TTLog(@"修改头像信息 -- %@", error);
        kMBHideHUD;
    }];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXMineTableViewCell* tools = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    TXGeneralModel* model = self.dataArray[indexPath.row];
    model.index = indexPath.item;
    tools.titleLabel.text = model.title;
    if (indexPath.row==0) {
//        tools.imagesAvatar.image = kGetImage(@"user1");
        [tools.imagesAvatar sd_setImageWithURL:kGetImageURL(kUserInfo.avatar)
                              placeholderImage:kGetImage(VERTICALMAPBITMAP)];
        tools.imagesAvatar.hidden = NO;
    }else{
        tools.subtitleLabel.text = (indexPath.row==1)?kUserInfo.username:kUserInfo.uid;
        tools.subtitleLabel.hidden = NO;
    }
    return tools;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark -- 设置Header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6_W(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [self imageURLReload];
    }else if (indexPath.row==1) {
        TXModifyUserInfoViewController *view = [[TXModifyUserInfoViewController alloc] init];
        view.title = @"个人信息";
        view.block = ^(NSString *text) {
            kUserInfo.username = text;
            [kUserInfo dump];
            //一个cell刷新
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            [kNotificationCenter postNotificationName:@"reloadUserName" object:nil];
        };
        LZNavigationController *nav = [[LZNavigationController alloc] initWithRootViewController:view];
        [self.navigationController presentViewController:nav animated:YES completion:^{
            TTLog(@"个人信息修改");
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        [_tableView registerClass:[TXMineTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,0)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kTableViewInSectionColor;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
        NSArray* titleArr = @[@"头像",@"昵称",@"用户ID"];
        NSArray* classArr = @[@"",@"",@""];
        for (int j = 0; j < titleArr.count; j ++) {
            TXGeneralModel *generalModel = [[TXGeneralModel alloc] init];
            generalModel.title = [titleArr lz_safeObjectAtIndex:j];
            generalModel.showClass = [classArr lz_safeObjectAtIndex:j];
            [_dataArray addObject:generalModel];
        }
    }
    return _dataArray;
}

- (SCImagePicker *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[SCImagePicker alloc] init];
        _imagePicker.isEditor = YES;
    }
    return _imagePicker;
}

@end
