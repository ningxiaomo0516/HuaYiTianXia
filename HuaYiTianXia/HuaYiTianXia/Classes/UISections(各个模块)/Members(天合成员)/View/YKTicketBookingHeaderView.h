//
//  YKTicketBookingHeaderView.h
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/10/7.
//  Copyright © 2019 宁小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YKTicketBookingHeaderView : UIView
/*起飞时间*/
@property (strong, nonatomic) UILabel *dep_timeLabel;
/*到达时间*/
@property (strong, nonatomic) UILabel *arv_timeLabel;

/*起飞机场*/
@property (strong, nonatomic) UILabel *dep_airportLabel;
/*到达机场*/
@property (strong, nonatomic) UILabel *arv_airportLabel;
@property (strong, nonatomic) UIView *circleView_t;
@property (strong, nonatomic) UIView *circleView_b;
@property (strong, nonatomic) UIView *linerView;

@property (strong, nonatomic) UIView *boxView;

/*航班号*/
@property (strong, nonatomic) UILabel *flightNoLabel;
/*有无餐食*/
@property (strong, nonatomic) UILabel *mealLabel;
/*机型*/
@property (strong, nonatomic) UILabel *planeTypeLabel;
/*里程*/
@property (strong, nonatomic) UILabel *distanceLabel;


@property (strong, nonatomic) UIView *linerView1;
@property (strong, nonatomic) UIView *linerView2;
@property (strong, nonatomic) UIView *linerView3;

@end

NS_ASSUME_NONNULL_END
