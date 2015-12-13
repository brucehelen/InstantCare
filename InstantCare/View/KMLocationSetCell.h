//
//  KMLocationSetCell.h
//  InstantCare
//
//  Created by 朱正晶 on 15/12/13.
//  Copyright © 2015年 omg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMDevicePointModel.h"

@protocol KMLocationSetCellDelegate <NSObject>

@optional
- (void)KMLocationSetCellBtnDidClicked:(id)model btn:(UIButton *)button;

@end

@interface KMLocationSetCell : UITableViewCell

@property (nonatomic, weak) id <KMLocationSetCellDelegate> delegate;
@property (nonatomic, strong) id model;

/**
 *  处于选择状态的按钮
 *  0: 没有任何按钮选中
 *  1: 左按钮选中
 *  2: 右按钮选中
 *  3: 中间按钮选中
 */
@property (nonatomic, assign) NSInteger selectBtnIndex;

@end
