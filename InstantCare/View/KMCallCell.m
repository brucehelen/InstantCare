//
//  KMCallCell.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/1.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMCallCell.h"

@interface KMCallCell()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *watchImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;

@end

@implementation KMCallCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCell];
    }

    return self;
}

- (void)configCell
{
    // 头像
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.width.height.equalTo(self.contentView.mas_height);
        make.centerY.equalTo(self.contentView);
    }];

    // 手表
    self.watchImageView = [[UIImageView alloc] init];
    self.watchImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.watchImageView];
    [self.watchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(25);
        make.width.height.equalTo(@30);
        make.centerY.equalTo(self.contentView);
    }];

    // 姓名
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.watchImageView.mas_right).offset(25);
        make.bottom.equalTo(self.contentView.mas_centerY).with.offset(-2);
    }];

    // 电话号码
    self.phoneLabel = [[UILabel alloc] init];
    self.phoneLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.contentView.mas_centerY).with.offset(2);
    }];
}

@end
