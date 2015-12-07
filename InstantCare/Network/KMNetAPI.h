//
//  KMNetAPI.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/4.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KMUserRegisterModel;

/*
 * code: 请求是否成功，0成功，其他失败
 *  res: 从网络获取到的数据
 */
typedef void (^KMRequestResultBlock)(int code, NSString *res);

@interface KMNetAPI : NSObject

+ (instancetype)manager;

- (void)postWithURL:(NSString *)url body:(NSString *)body block:(KMRequestResultBlock)block;

// 用户登录接口
- (void )loginWithUserName:(NSString *)name
                  password:(NSString *)password
                       gid:(NSString *)gid
                     block:(KMRequestResultBlock)block;

// 用户注册
- (void)userRegisterWithModel:(KMUserRegisterModel *)model
                        block:(KMRequestResultBlock)block;

@end
