//
//  KMImageTitleButton.h
//  InstantCare
//
//  Created by bruce-zhu on 15/11/30.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMImageTitleButton : UIButton

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *label;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

@end
