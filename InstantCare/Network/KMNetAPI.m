//
//  KMNetAPI.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/4.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMNetAPI.h"
#import "KMUserRegisterModel.h"
#import "AFNetworking.h"

@interface KMNetAPI()

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) KMRequestResultBlock requestBlock;

@end

@implementation KMNetAPI

+ (instancetype)manager
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.data = [NSMutableData data];
    }

    return self;
}

- (void)postWithURL:(NSString *)url body:(NSString *)body block:(KMRequestResultBlock)block
{
    NSData *httpBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.timeoutInterval = 60;
    [request setURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:httpBody];
    
    self.requestBlock = block;
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// 用户登录接口
- (void )loginWithUserName:(NSString *)name
                  password:(NSString *)password
                       gid:(NSString *)gid
                     block:(KMRequestResultBlock)block
{
    NSString *url = [NSString stringWithFormat:@"http://%@/service/m/auth/login", kServerAddress];
    //NSString *body = [NSString stringWithFormat:@"{\"loginToken\":\"%@\",\"passwd\":\"%@\",\"gid\":\"%@\"}", name, password, gid];
    NSString *body = [NSString stringWithFormat:@"{\"loginToken\":\"%@\",\"passwd\":\"%@\"}", name, password];

    [self postWithURL:url body:body block:block];
}

#pragma mark - 用户注册
- (void)userRegisterWithModel:(KMUserRegisterModel *)model
                        block:(KMRequestResultBlock)block
{
    NSString *url = [NSString stringWithFormat:@"http://%@/omoud/webservice/APIService/register", kServerAddress];

    [self postWithURL:url body:[model mj_JSONString] block:block];
}

#pragma mark - 拥有装置
- (void)getDevicesWithid:(NSString *)userId
                     key:(NSString *)key
                   block:(KMRequestResultBlock)block
{
    self.requestBlock = block;
    NSString *url = [NSString stringWithFormat:@"http://%@/service/m/device/devices?id=%@&key=%@",
                     kServerAddress,
                     userId,
                     key];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60;

    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *jsonString = [[NSString alloc] initWithData:responseObject
                                                     encoding:NSUTF8StringEncoding];
        if (self.requestBlock) {
            self.requestBlock(0, jsonString);
        }
        self.requestBlock = nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.requestBlock) {
            self.requestBlock(error.code, nil);
        }
        self.requestBlock = nil;
    }];
}

#pragma mark - 连接成功
- (void)connection: (NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)aResponse
{
    self.data.length = 0;
}

#pragma mark 存储数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)incomingData
{
    [self.data appendData:incomingData];
}

#pragma mark 完成加载
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *jsonData = [[NSString alloc] initWithData:self.data
                                               encoding:NSUTF8StringEncoding];

    if (self.requestBlock) {
        self.requestBlock(0, jsonData);
    }

    self.requestBlock = nil;
}

#pragma mark 连接错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.requestBlock) {
        self.requestBlock((int)error.code, nil);
    }

    self.requestBlock = nil;
}

@end
