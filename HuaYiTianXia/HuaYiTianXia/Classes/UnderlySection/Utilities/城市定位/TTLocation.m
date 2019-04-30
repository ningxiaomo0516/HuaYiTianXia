//
//  TTLocation.m
//  HuaYiTianXia
//
//  Created by 宁小陌 on 2019/4/30.
//  Copyright © 2019年 宁小陌. All rights reserved.
//

#import "TTLocation.h"
#import <CoreLocation/CoreLocation.h>
@interface TTLocation()  <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLGeocoder* geocoder;

@end

@implementation TTLocation

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initLocation];
    }
    return self;
}

- (void)initLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self requestAuthorization];
    self.geocoder = [[CLGeocoder alloc]  init];
    
    //添加定时器
    NSTimer*  locationTimer = [NSTimer timerWithTimeInterval:300 target:self selector:@selector(startLocation) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:locationTimer forMode:NSRunLoopCommonModes];
}

- (void)requestAuthorization{
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)startLocation{
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    // 2.停止定位
    [manager stopUpdatingLocation];
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark* placemark = placemarks.firstObject;
        NSString*  province = placemark.administrativeArea;
        NSString*  cityName = placemark.locality;
        TTLog(@"province :%@   cityName:%@",province,cityName);
        cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
        if (cityName.length) {
            [kUserDefaults setObject:cityName forKey:@"city"];
            [kUserDefaults synchronize];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    if (error.code == kCLErrorDenied) {
        TTLog(@"-定位失败error--%@---",error);
    }
}
@end
