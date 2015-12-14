//
//  KMBgmModel.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/14.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMBgmModel : NSObject

@property (nonatomic, copy) NSString *deviceId;

@property (nonatomic, copy) NSString *date;
/**
 *  全血血糖
 */
@property (nonatomic, assign) NSInteger glucose;
/**
 *  血浆血糖
 */
@property (nonatomic, assign) NSInteger plasma;

@end
