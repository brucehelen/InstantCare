//
//  KMUserModel.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/4.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

// 登录用户模型
@interface KMUserModel : NSObject

@property (nonatomic, copy) NSString *loginToken;
@property (nonatomic, copy) NSString *passwd;
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) int permission;
@property (nonatomic, copy) NSString *key;

@end
