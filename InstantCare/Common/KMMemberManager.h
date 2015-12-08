//
//  KMMember.h
//  InstantCare
//
//  Created by bruce-zhu on 15/11/30.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMUserModel.h"

#define member  [KMMemberManager sharedInstance]

typedef NS_ENUM(NSInteger, KMUserWatchType) {
    KM_WATCH_TYPE_GOLD,     // 土豪金
    KM_WATCH_TYPE_BLACK,    // 黑色
    KM_WATCH_TYPE_ORANGE    // 橘红色
};

@interface KMMemberManager : NSObject

@property (nonatomic, copy) NSString *loginEmail;
@property (nonatomic, copy) NSString *loginPd;
@property (nonatomic, assign) BOOL rememberLoginFlag;

@property (nonatomic, strong) KMUserModel *userModel;           // 用户成功登录信息

+ (KMMemberManager *)sharedInstance;

// 根据imei来获取用户的头像，如果不存在返回nil
+ (UIImage *)userHeaderImageWithIMEI:(NSString *)imei;
// 设置用户头像
+ (void)addUserHeaderImage:(UIImage *)image IMEI:(NSString *)imei;

// 根据imei来获取用户名字
+ (NSString *)userNameWithIMEI:(NSString *)imei;
+ (void)addUserName:(NSString *)name IMEI:(NSString *)imei;

// 根据imei来获取用户电话号码
+ (NSString *)userPhoneNumberWithIMEI:(NSString *)imei;
+ (void)addUserPhoneNumber:(NSString *)phoneNumber IMEI:(NSString *)imei;

// 根据imei来获取配套手表类型
+ (KMUserWatchType)userWatchTypeWithIMEI:(NSString *)imei;
+ (void)addUserWatchType:(KMUserWatchType)type IMEI:(NSString *)imei;

@end
