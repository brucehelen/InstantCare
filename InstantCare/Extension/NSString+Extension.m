//
//  NSString+Extension.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/17.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/**
 *  如果字符串为空返回@""
 *
 *  @param string 原字符串
 *
 *  @return 新字符串，不会为(null)
 */
+ (NSString *)nullStringReturn:(NSString *)string
{
    if (string) return string;
    
    return @"";
}

@end
