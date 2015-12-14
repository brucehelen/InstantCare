//
//  KMLocationSetCell.h
//  InstantCare
//
//  Created by 朱正晶 on 15/12/13.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMDevicePointModel.h"
#import "KMDevicePointCheckModel.h"

@protocol KMLocationSetCellDelegate <NSObject>

@optional
- (void)KMLocationSetCellBtnDidClicked:(id)model btn:(UIButton *)button;

@end

@interface KMLocationSetCell : UITableViewCell

@property (nonatomic, weak) id <KMLocationSetCellDelegate> delegate;
@property (nonatomic, strong) id model;

@end
