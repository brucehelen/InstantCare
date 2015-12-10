//
//  KMDeviceSettingModel.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/10.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMDeviceSettingModel : NSObject

// 设置时用到
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *target;       // 设备IMEI

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *aliasName;
@property (nonatomic, assign) int foot_length;
@property (nonatomic, assign) double weight;
@property (nonatomic, assign) double height;
@property (nonatomic, assign) int setting;
@property (nonatomic, copy) NSString *sos1;
@property (nonatomic, copy) NSString *sos2;
@property (nonatomic, copy) NSString *sos3;

@property (nonatomic, copy) NSString *contact1;
@property (nonatomic, copy) NSString *contact2;
@property (nonatomic, copy) NSString *contact3;

@end
