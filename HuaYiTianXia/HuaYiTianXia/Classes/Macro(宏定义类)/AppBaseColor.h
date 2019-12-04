//
//  AppBaseColor.h
//  MerchantVersion
//
//  Created by 寜小陌 on 2018/1/19.
//  Copyright © 2018年 寜小陌. All rights reserved.
//

#ifndef AppBaseColor_h
#define AppBaseColor_h


#define kWhiteColor kColorWithRGB(255,255,255)
#define kBlackColor kColorWithRGB(0,0,0)
#define kRedColor   kColorWithRGB(255,0,0)
#define kBadgeColor kColorWithRGB(252,13,27)


/// TabBar 默认颜色和选择颜色
//#define kTabBarColorNormal kColorWithRGB(136,136,136)
#define kTabBarColorNormal kColorWithRGB(102,102,102)
#define kTabBarColorSelected kColorWithRGB(208,58,51)

//#define kNavigationColorNormal kColorWithRGB(255,65,99)
#define kNavigationColorNormal kColorWithRGB(250, 250, 250)
#define kViewColorNormal kColorWithRGB(241, 241, 241)
#define kTextColor244 kColorWithRGB(244, 244, 244)

#define kLinerViewColor kColorWithRGB(221, 221, 221)
#define kLinerViewHeight 0.5

/// TableView in Section background color
#define kTableViewInSectionColor kColorWithRGB(241, 241, 241)

/// 主题颜色
#define kColorHexString @"#e60012" /// 230,0,18
#define kThemeColorHex HexString(kColorHexString)
/// 一级页面主题颜色
#define kThemeColorRGB kThemeColorHex
/// 暂时没有用
#define kImageColor  imageColor(kThemeColorHex)
/// 公共按钮背景图(颜色)
#define kButtonColorNormal imageColor(kThemeColorHex)

/// 所有价格通用颜色
#define kPriceColor kThemeColorHex//kColorWithRGB(183, 1, 1)


/**
 苹方-简 中黑体 PingFangSC-Medium
 苹方-简 中粗体 PingFangSC-Semibold
 苹方-简 细体 PingFangSC-Light
 苹方-简 极细体 PingFangSC-Ultralight
 苹方-简 常规体 PingFangSC-Regular
 苹方-简 纤细体 PingFangSC-Thin
 */
#define kFontWithNameMedium             @"PingFangSC-Medium"
#define kFontWithNamePingFangSCBold     @"PingFangSC-Semibold"
#define kFontWithNameHelveticaBold      @"Helvetica-Bold"
#define kFontWithNamePingFangSC         @"PingFangSC"
#define kFontWithNameRegular            @"PingFangSC-Regular"
#define kFontWithNameDisplayRegular     @"SanFranciscoDisplay-Regular"
#define kFontWithNameDisplayMedium      @"SanFranciscoDisplay-Medium"

#define kFontWithNameMicrosoftYaHei     @"MicrosoftYaHei-Regular"
#define kFontSizeMicrosoftYaHei10 [UIFont fontWithName:kFontWithNameMicrosoftYaHei size:10]

#define kFontSizeDisplayRegular12 [UIFont fontWithName:kFontWithNameDisplayRegular size:12]
#define kFontSizeDisplayMedium22 [UIFont fontWithName:kFontWithNameDisplayMedium size:22]
#define kFontSizeDisplayMedium36 [UIFont fontWithName:kFontWithNameDisplayMedium size:36]
//[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]

#define kFontSizeRegular10 [UIFont fontWithName:kFontWithNameRegular size:10]
#define kFontSizeRegular11 [UIFont fontWithName:kFontWithNameRegular size:11]
#define kFontSizeRegular12 [UIFont fontWithName:kFontWithNameRegular size:12]
#define kFontSizeRegular13 [UIFont fontWithName:kFontWithNameRegular size:13]
#define kFontSizeRegular14 [UIFont fontWithName:kFontWithNameRegular size:14]
#define kFontSizeRegular15 [UIFont fontWithName:kFontWithNameRegular size:15]
#define kFontSizeRegular16 [UIFont fontWithName:kFontWithNameRegular size:16]
#define kFontSizeRegular17 [UIFont fontWithName:kFontWithNameRegular size:17]
#define kFontSizeRegular18 [UIFont fontWithName:kFontWithNameRegular size:18]
#define kFontSizeRegular19 [UIFont fontWithName:kFontWithNameRegular size:19]
#define kFontSizeRegular20 [UIFont fontWithName:kFontWithNameRegular size:20]

#define kFontWithNameSc12 [UIFont fontWithName:kFontWithNamePingFangSC size:12]

#define kFontSizeScBold10 [UIFont fontWithName:kFontWithNamePingFangSCBold size:10]
#define kFontSizeScBold12 [UIFont fontWithName:kFontWithNamePingFangSCBold size:12]
#define kFontSizeScBold13 [UIFont fontWithName:kFontWithNamePingFangSCBold size:13]
#define kFontSizeScBold14 [UIFont fontWithName:kFontWithNamePingFangSCBold size:14]
#define kFontSizeScBold15 [UIFont fontWithName:kFontWithNamePingFangSCBold size:15]
#define kFontSizeScBold16 [UIFont fontWithName:kFontWithNamePingFangSCBold size:16]
#define kFontSizeScBold17 [UIFont fontWithName:kFontWithNamePingFangSCBold size:17]
#define kFontSizeScBold20 [UIFont fontWithName:kFontWithNamePingFangSCBold size:20]
#define kFontSizeScBold22 [UIFont fontWithName:kFontWithNamePingFangSCBold size:22]
#define kFontSizeScBold24 [UIFont fontWithName:kFontWithNamePingFangSCBold size:24]
#define kFontSizeScBold33 [UIFont fontWithName:kFontWithNamePingFangSCBold size:33]


#define kFontSizeMedium9 [UIFont fontWithName:kFontWithNameMedium size:9]
#define kFontSizeMedium10 [UIFont fontWithName:kFontWithNameMedium size:10]
#define kFontSizeMedium11 [UIFont fontWithName:kFontWithNameMedium size:11]
#define kFontSizeMedium12 [UIFont fontWithName:kFontWithNameMedium size:12]
#define kFontSizeMedium13 [UIFont fontWithName:kFontWithNameMedium size:13]
#define kFontSizeMedium14 [UIFont fontWithName:kFontWithNameMedium size:14]
#define kFontSizeMedium15 [UIFont fontWithName:kFontWithNameMedium size:15]
#define kFontSizeMedium16 [UIFont fontWithName:kFontWithNameMedium size:16]
#define kFontSizeMedium17 [UIFont fontWithName:kFontWithNameMedium size:17]
#define kFontSizeMedium18 [UIFont fontWithName:kFontWithNameMedium size:18]
#define kFontSizeMedium19 [UIFont fontWithName:kFontWithNameMedium size:19]
#define kFontSizeMedium20 [UIFont fontWithName:kFontWithNameMedium size:20]
#define kFontSizeMedium21 [UIFont fontWithName:kFontWithNameMedium size:21]
#define kFontSizeMedium24 [UIFont fontWithName:kFontWithNameMedium size:24]
#define kFontSizeMedium25 [UIFont fontWithName:kFontWithNameMedium size:25]
#define kFontSizeMedium27 [UIFont fontWithName:kFontWithNameMedium size:27]
#define kFontSizeMedium28 [UIFont fontWithName:kFontWithNameMedium size:28]
#define kFontSizeMedium30 [UIFont fontWithName:kFontWithNameMedium size:30]
#define kFontSizeMedium34 [UIFont fontWithName:kFontWithNameMedium size:34]


//#define kFontSizeMedium15 [UIFont fontWithName:kFontWithNameMedium size:15*kScaleFit]

////// 颜色 ///////
#define kTextColor12 kColorWithRGB(12, 12, 12)
#define kTextColor18 kColorWithRGB(18, 18, 18)
#define kTextColor34 kColorWithRGB(34, 34, 34)
#define kTextColor51 kColorWithRGB(51, 51, 51)
#define kTextColor102 kColorWithRGB(102, 102, 102)
#define kTextColor112 kColorWithRGB(112, 112, 112)
#define kTextColor128 kColorWithRGB(128, 128, 128)
#define kTextColor135 kColorWithRGB(135, 135, 135)
#define kTextColor136 kColorWithRGB(136, 136, 136)
#define kTextColor153 kColorWithRGB(153, 153, 153)
#define kTextColor170 kColorWithRGB(170, 170, 170)
#define kTextColor204 kColorWithRGB(204, 204, 204)
#define kTextColor214 kColorWithRGB(214, 214, 214)
#define kTextColor227 kColorWithRGB(227, 227, 227)
#define kTextColor238 kColorWithRGB(238, 238, 238)
#define kTextColor221 kColorWithRGB(221, 221, 221)


#define kTextColor180 kColorWithRGB(180, 180, 180)

#endif /* AppBaseColor_h */
