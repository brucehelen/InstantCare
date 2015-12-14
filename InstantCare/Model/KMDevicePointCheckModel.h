//
//  KMDevicePointCheckModel.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/14.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMDevicePointCheckInOutModel.h"

/**
 *  打卡记录check数据模块
 */
@interface KMDevicePointCheckModel : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, strong) KMDevicePointCheckInOutModel *in;
@property (nonatomic, strong) KMDevicePointCheckInOutModel *out;

/**
 *  处于选择状态的按钮
 *  0: 没有任何按钮选中
 *  1: 左按钮选中
 *  2: 右按钮选中
 *  3: 中间按钮选中
 */
@property (nonatomic, assign) NSInteger selectIndex;

@end
