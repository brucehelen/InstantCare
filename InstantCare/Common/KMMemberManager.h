//
//  KMMember.h
//  InstantCare
//
//  Created by bruce-zhu on 15/11/30.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMMemberManager : NSObject

@property (nonatomic, copy) NSString *loginEmail;
@property (nonatomic, copy) NSString *loginPd;
@property (nonatomic, assign) BOOL rememberLoginFlag;

+ (KMMemberManager *)sharedInstance;

@end
