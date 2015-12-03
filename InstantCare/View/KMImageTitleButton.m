//
//  KMImageTitleButton.m
//  InstantCare
//
//  Created by bruce-zhu on 15/11/30.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMImageTitleButton.h"

@implementation KMImageTitleButton

#define kIconViewWidth      40

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title
{
    self = [super init];
    if (self) {
        UIView *view = [[UIView alloc] init];

        self.iconView = [[UIImageView alloc] init];
        self.iconView.image = image;
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.centerY.equalTo(view);
            make.width.height.equalTo(@(kIconViewWidth));
        }];
        
        self.label = [[UILabel alloc] init];
        self.label.text = title;
        [view addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).with.offset(5);
            make.top.bottom.equalTo(view);
        }];
        
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.label);
            make.centerX.top.bottom.equalTo(self);
        }];
        
        self.iconView.userInteractionEnabled = NO;
        self.label.userInteractionEnabled = NO;
        view.userInteractionEnabled = NO;
    }

    return self;
}


@end
