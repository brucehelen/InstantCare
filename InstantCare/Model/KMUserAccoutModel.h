//
//  KMUserAccoutModel.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/16.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用户信息
 */
@interface KMUserAccoutModel : NSObject

@property (nonatomic, copy) NSString *accountId;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *birth;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *loginToken;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger permission;

@property (nonatomic, copy) NSString *phone;

//@property (nonatomic, copy) NSString *register;

@end
