//
//  KMChangeDateVC.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/15.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMChangeDateDelegate <NSObject>

@optional
- (void)changeDateComplete:(NSDate *)startDate
                   endDate:(NSDate *)endDate;

@end

/**
 *  更改测量区间日期
 */
@interface KMChangeDateVC : UIViewController

@property (nonatomic, weak) id<KMChangeDateDelegate> delegate;

@end
