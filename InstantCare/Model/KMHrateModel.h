//
//  KMHrateModel.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/15.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMHrateModel : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *end;
/**
 *  服务器端接收到手表数据包的时间
 */
@property (nonatomic, copy) NSString *recordTime;
/**
 *  end转换后的日期
 */
@property (nonatomic, strong) NSDate *convertDate;

@property (nonatomic, assign) NSInteger avg;

@end
