//
//  KMBpmModel.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/14.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMBpmModel : NSObject

/**
 *  设备imei
 */
@property (nonatomic, copy) NSString *deviceId;
/**
 *  日期，字符串，需转换
 */
@property (nonatomic, copy) NSString *date;
/**
 *  将字符串日期转换成NSDate类型
 */
@property (nonatomic, strong) NSDate *convertDate;
/**
 *  低压
 */
@property (nonatomic, assign) NSInteger sbp;
/**
 *  高压
 */
@property (nonatomic, assign) NSInteger dbp;
/**
 *  脉搏
 */
@property (nonatomic, assign) NSInteger pluse;

@end
