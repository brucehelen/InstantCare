//
//  KMDevicePointCheckInOutModel.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/14.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  打开in和out数据模型
 */
@interface KMDevicePointCheckInOutModel : NSObject

@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lon;
@property (nonatomic, copy) NSString *date;

@end
