//
//  KMDeviceSetModel.h
//  InstantCare
//
//  Created by 朱正晶 on 15/12/13.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMDevicePointModel.h"

/// SOS求救模型
@interface KMDeviceSetModel : NSObject

@property (nonatomic, strong) NSArray *sos;
@property (nonatomic, strong) NSArray *regular;
@property (nonatomic, strong) NSArray *check;

@end
