//
//  KMNetAPI.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/4.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KMUserRegisterModel;
@class KMDeviceSettingModel;

/*
 * code: 请求是否成功，0成功，其他失败
 *  res: 从网络获取到的数据
 */
typedef void (^KMRequestResultBlock)(int code, NSString *res);

@interface KMNetAPI : NSObject

+ (instancetype)manager;

- (void)postWithURL:(NSString *)url body:(NSString *)body block:(KMRequestResultBlock)block;

// 用户登录接口
- (void )loginWithUserName:(NSString *)name
                  password:(NSString *)password
                       gid:(NSString *)gid
                     block:(KMRequestResultBlock)block;

// 用户注册
- (void)userRegisterWithModel:(KMUserRegisterModel *)model
                        block:(KMRequestResultBlock)block;

- (void)getDevicesWithid:(NSString *)userId
                     key:(NSString *)key
                   block:(KMRequestResultBlock)block;

- (void)updateDeviceSettingsWithModel:(KMDeviceSettingModel *)model
                                block:(KMRequestResultBlock)block;

/**
 *  取得设备当前设定
 *
 *  @param imei  设备IMEI
 *  @param block 结果返回block
 */
- (void)getDevicesSettingsWithIMEI:(NSString *)imei
                             block:(KMRequestResultBlock)block;
/**
 *  绑定设备
 *
 *  @param imei  设备IMEI
 *  @param block 结果返回block
 */
- (void)bundleNewDeviceWithIMEI:(NSString *)imei
                          block:(KMRequestResultBlock)block;
/**
 *  解绑设备
 *
 *  @param imei  设备IMEI
 *  @param block 结构返回block
 */
- (void)unbundleDeviceWithIMEI:(NSString *)imei
                         block:(KMRequestResultBlock)block;

/**
 *  请求设备定位记录
 *
 *  @param imei  设备IMEI
 *  @param block 结果返回block
 */
- (void)requestLocationSetWithIMEI:(NSString *)imei
                             block:(KMRequestResultBlock)block;

/**
 *  获取健康量测资讯
 *
 *  @param key   steps, bgm, bpm, heartRate, set
 *  @param block 结果返回block
 */
- (void)getHealthInfoWithKey:(NSString *)key
                       block:(KMRequestResultBlock)block;

@end
