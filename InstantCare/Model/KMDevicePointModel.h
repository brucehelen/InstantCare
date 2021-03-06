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
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lon;
@property (nonatomic, copy) NSString *date;

/**
 *  处于选择状态的按钮
 *  0: 没有任何按钮选中
 *  1: 左按钮选中
 *  2: 右按钮选中
 *  3: 中间按钮选中
 */
@property (nonatomic, assign) NSInteger selectIndex;

@end
