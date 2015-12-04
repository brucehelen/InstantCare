//
//  KMMember.h
//  InstantCare
//
//  Created by bruce-zhu on 15/11/30.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMUserModel.h"

#define member  [KMMemberManager sharedInstance]

@interface KMMemberManager : NSObject

@property (nonatomic, copy) NSString *loginEmail;
@property (nonatomic, copy) NSString *loginPd;
@property (nonatomic, assign) BOOL rememberLoginFlag;

@property (nonatomic, strong) KMUserModel *userModel;       // 用户成功登录信息

+ (KMMemberManager *)sharedInstance;

@end
