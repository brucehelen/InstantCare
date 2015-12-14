//
//  KMLocationSetCell.m
//  InstantCare
//
//  Created by 朱正晶 on 15/12/13.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMLocationSetCell.h"

@interface KMLocationSetCell()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *centerBtn;

@end

@implementation KMLocationSetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCell];
    }
    
    return self;
}

- (void)configCell
{
    WS(ws);

    // left button
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.tag = 1;
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"omg_location_data_frontlayer_onlick"]
                            forState:UIControlStateSelected];
    self.leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(10, -15, 10, 0);
    self.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.leftBtn setImage:[UIImage imageNamed:@"omg_location_icon_start"]
                  forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:[UIColor blackColor]
                       forState:UIControlStateNormal];
    [self.leftBtn addTarget:self
                     action:@selector(btnDidClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(ws.contentView);
        make.width.equalTo(ws.contentView).multipliedBy(0.5);
    }];

    // right button
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.tag = 2;
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"omg_location_data_frontlayer_onlick"]
                             forState:UIControlStateSelected];
    self.rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    self.rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(10, -15, 10, 0);
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rightBtn setImage:[UIImage imageNamed:@"omg_location_icon_end"]
                   forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor blackColor]
                        forState:UIControlStateNormal];
    [self.rightBtn addTarget:self
                      action:@selector(btnDidClicked:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.contentView);
        make.width.equalTo(ws.contentView).multipliedBy(0.5);
    }];

    // center button
    self.centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.centerBtn.tag = 3;
    self.centerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.centerBtn setBackgroundImage:[UIImage imageNamed:@"omg_location_data_frontlayer_onlick"]
                              forState:UIControlStateSelected];
    [self.centerBtn setTitleColor:[UIColor blackColor]
                         forState:UIControlStateNormal];
    [self.centerBtn addTarget:self
                       action:@selector(btnDidClicked:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.centerBtn];
    [self.centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws);
    }];

    // 默认都隐藏
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    self.centerBtn.hidden = YES;
}

- (void)btnDidClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(KMLocationSetCellBtnDidClicked:btn:)]) {
        [self.delegate KMLocationSetCellBtnDidClicked:self.model
                                                  btn:sender];
    }
}

- (void)setModel:(id)model
{
    _model = model;
    NSInteger index = 0;

    if ([model isKindOfClass:[KMDevicePointModel class]]) {         // sos, regular
        KMDevicePointModel *pointModel = model;
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        self.centerBtn.hidden = NO;
        [self.centerBtn setTitle:pointModel.date
                        forState:UIControlStateNormal];
        index = pointModel.selectIndex;
    } else if ([model isKindOfClass:[KMDevicePointCheckModel class]]) { // check
        KMDevicePointCheckModel *omodel = (KMDevicePointCheckModel *)model;
        index = omodel.selectIndex;
        self.centerBtn.hidden = YES;
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
        [self.leftBtn setTitle:omodel.in.date
                      forState:UIControlStateNormal];
        [self.rightBtn setTitle:omodel.out.date
                       forState:UIControlStateNormal];
    }

    // 设置按钮的选中状态
    switch (index) {
        case 0:
            self.leftBtn.selected = NO;
            self.rightBtn.selected = NO;
            self.centerBtn.selected = NO;
            break;
        case 1:
            self.leftBtn.selected = YES;
            self.rightBtn.selected = NO;
            self.centerBtn.selected = NO;
            break;
        case 2:
            self.leftBtn.selected = NO;
            self.rightBtn.selected = YES;
            self.centerBtn.selected = NO;
            break;
        case 3:
            self.leftBtn.selected = NO;
            self.rightBtn.selected = NO;
            self.centerBtn.selected = YES;
            break;
        default:
            break;
    }
}

@end
