//
//  KMDevicePointModel.h
//  InstantCare
//
//  Created by 朱正晶 on 15/12/13.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 定位点数据模型
@interface KMDevicePointModel : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (nonatomic, copy) NSString *date;

/**
 *  记录选中状态使用
 */
@property (nonatomic, assign) NSInteger selectIndex;

@end
