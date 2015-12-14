//
//  KMHealthSetModel.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/14.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMBpmModel.h"
#import "KMBgmModel.h"
#import "KMStepsModel.h"

@interface KMHealthSetModel : NSObject

/**
 *  血压: KMBpmModel
 */
@property (nonatomic, strong) NSArray *bpm;
/**
 *  血糖: KMBgmModel
 */
@property (nonatomic, strong) NSArray *bgm;
/**
 *  记步: KMStepsModel
 */
@property (nonatomic, strong) NSArray *steps;

@end
