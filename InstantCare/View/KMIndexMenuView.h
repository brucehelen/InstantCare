//
//  KMIndexMenuView.h
//  InstantCare
//
//  Created by bruce-zhu on 15/12/1.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMIndexMenuViewDeleage <NSObject>

@optional
- (void)KMIndexMenuViewDidClicked:(NSUInteger)index;

@end


@interface KMIndexMenuView : UIView

@property (nonatomic, weak) id<KMIndexMenuViewDeleage> delegate;

@end
