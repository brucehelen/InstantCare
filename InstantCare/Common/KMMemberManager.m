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
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)loginEmail
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"loginEmail"];
}

#pragma mark - 登录密码
- (void)setLoginPd:(NSString *)loginPd
{
    [[NSUserDefaults standardUserDefaults] setObject:loginPd forKey:@"loginPd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

#pragma mark - 根据imei来获取用户的头像，如果不存在返回默认头像
+ (UIImage *)userHeaderImageWithIMEI:(NSString *)imei
{
    NSData *data = [NSData dataWithContentsOfFile:[self headerImagePathWithIMEI:imei]];
    UIImage *image =  [UIImage imageWithData:data];
    return image;
}

// 设置用户头像
+ (void)addUserHeaderImage:(UIImage *)image IMEI:(NSString *)imei
{
    NSData *data;

    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    } else {
        data = UIImagePNGRepresentation(image);
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Document/headerImage_xxxx
    NSString *filePath = [NSString stringWithString:[self headerImagePathWithIMEI:imei]];

    [fileManager createFileAtPath:filePath
                         contents:data
                       attributes:nil];
}

+ (NSString *)headerImagePathWithIMEI:(NSString *)imei
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingString:[NSString stringWithFormat:@"headerImage_%@", imei]];
}

#pragma mark - 根据imei来获取用户名字
+ (NSString *)userNameWithIMEI:(NSString *)imei
{
    NSString *keyString = [NSString stringWithFormat:@"username_%@", imei];
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyString];
}

+ (void)addUserName:(NSString *)name IMEI:(NSString *)imei
{
    NSString *keyString = [NSString stringWithFormat:@"username_%@", imei];
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:keyString];
}


#pragma mark - 根据imei来获取用户电话号码
+ (NSString *)userPhoneNumberWithIMEI:(NSString *)imei
{
    NSString *keyString = [NSString stringWithFormat:@"phoneNumber_%@", imei];
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyString];
}

+ (void)addUserPhoneNumber:(NSString *)phoneNumber IMEI:(NSString *)imei
{
    NSString *keyString = [NSString stringWithFormat:@"phoneNumber_%@", imei];
    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:keyString];
}

#pragma mark - 根据imei来获取佩戴手表类型
+ (KMUserWatchType)userWatchTypeWithIMEI:(NSString *)imei
{
    NSString *keyString = [NSString stringWithFormat:@"watchType_%@", imei];
    return [[[NSUserDefaults standardUserDefaults] objectForKey:keyString] intValue];
}

+ (void)addUserWatchType:(KMUserWatchType)type IMEI:(NSString *)imei
{
    NSString *keyString = [NSString stringWithFormat:@"watchType_%@", imei];
    [[NSUserDefaults standardUserDefaults] setObject:@(type) forKey:keyString];
}

@end
