//
//  KMRegisterVC.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/1.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMUserRegisterModel.h"

/**
 *  注册页面和账户设定共用
 */
@interface KMRegisterVC : UIViewController

/**
 *  注册页面不需要，账户设定需要传模型
 */
@property (nonatomic, strong) KMUserRegisterModel *userModel;

@end
