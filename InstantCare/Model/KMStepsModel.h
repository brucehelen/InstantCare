//
//  KMStepsModel.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/14.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMStepsModel : NSObject

@property (nonatomic, copy) NSString *deviceId;

/**
 *  步数
 */
@property (nonatomic, assign) NSInteger steps;
/**
 *  距离
 */
@property (nonatomic, assign) NSInteger dis;
/**
 *  卡路里
 */
@property (nonatomic, assign) NSInteger cal;

@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *end;
/**
 *  转换end日期字符
 */
@property (nonatomic, strong) NSDate *convertDate;

@end
