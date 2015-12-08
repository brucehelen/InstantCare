//
//  KMBundleDevicesResModel.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/8.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KMBundleDevicesModel.h"

@interface KMBundleDevicesResModel : NSObject

@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) KMBundleDevicesModel *content;

@end
