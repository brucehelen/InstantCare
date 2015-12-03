//
//  KMMemberManger.m
//  InstantCare
//
//  Created by bruce-zhu on 15/11/30.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMMemberManager.h"

@implementation KMMemberManager

+ (KMMemberManager *)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

#pragma mark - 登录账号
- (void)setLoginEmail:(NSString *)loginEmail
{
    [[NSUserDefaults standardUserDefaults] setObject:loginEmail forKey:@"loginEmail"];
}

- (NSString *)loginEmail
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"loginEmail"];
}

#pragma mark - 登录密码
- (void)setLoginPd:(NSString *)loginPd
{
    [[NSUserDefaults standardUserDefaults] setObject:loginPd forKey:@"loginPd"];
}

- (NSString *)loginPd
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"loginPd"];
}

#pragma mark - 是否记住登录信息
- (void)setRememberLoginFlag:(BOOL)rememberLoginFlag
{
    [[NSUserDefaults standardUserDefaults] setObject:@(rememberLoginFlag) forKey:@"rememberLoginFlag"];
}

- (BOOL)rememberLoginFlag
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"rememberLoginFlag"] boolValue];
}


@end
