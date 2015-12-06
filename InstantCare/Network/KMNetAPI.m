//
//  KMNetAPI.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/4.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMNetAPI.h"

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
    NSString *body = [NSString stringWithFormat:@"{\"loginToken\":\"%@\",\"passwd\":\"%@\",\"gid\":\"%@\"}", name, password, gid];

    [self postWithURL:url body:body block:block];
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
    if (self.requestBlock) {
        self.requestBlock(0, self.data);
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
