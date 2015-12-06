//
//  KMAcountSettingVC.m
//  InstantCare
//
//  Created by 朱正晶 on 15/12/6.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMAcountSettingVC.h"

@implementation KMAcountSettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNarBar];
    [self configView];
}

- (void)configNarBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-button"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(leftBarButtonDidClicked:)];
    
    self.navigationItem.title = NSLocalizedStringFromTable(@"AccountSetting_VC_title", APP_LAN_TABLE, nil);
}

- (void)leftBarButtonDidClicked:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.right.bottom.equalTo(self.view);
    }];

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.text = @"Helen";
    [scrollView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(64 + 20);
        make.height.equalTo(@30);
    }];
    
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.font = [UIFont systemFontOfSize:18];
    nickNameLabel.text = @"small helen";
    [scrollView addSubview:nickNameLabel];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(nameLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    
    // email
    UILabel *emailLabel = [[UILabel alloc] init];
    emailLabel.font = [UIFont systemFontOfSize:18];
    emailLabel.text = @"helen@qq.com";
    [scrollView addSubview:emailLabel];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(nickNameLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];

    //*********
    UILabel *pdLabel = [[UILabel alloc] init];
    pdLabel.font = [UIFont systemFontOfSize:18];
    pdLabel.text = @"*********";
    [scrollView addSubview:pdLabel];
    [pdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(emailLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];

    // 显示密码按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:NSLocalizedStringFromTable(@"AccountSetting_VC_btn_title", APP_LAN_TABLE, nil)
         forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1;
    [scrollView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(pdLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];

    // birthday
    UILabel *birthdayLabel = [[UILabel alloc] init];
    birthdayLabel.font = [UIFont systemFontOfSize:18];
    birthdayLabel.text = @"19871227";
    [scrollView addSubview:birthdayLabel];
    [birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(btn.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    
    // address
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont systemFontOfSize:18];
    addressLabel.text = @"星胜客";
    [scrollView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(birthdayLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    
    // phoneNumber
    UILabel *phoneNumber = [[UILabel alloc] init];
    phoneNumber.font = [UIFont systemFontOfSize:18];
    phoneNumber.text = @"12321222";
    [scrollView addSubview:phoneNumber];
    [phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(addressLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    
    // editButton
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"omg_btn_edit_icon"]
                forState:UIControlStateNormal];
    editButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //editButton.imageView.backgroundColor = [UIColor redColor];
    //editButton.titleLabel.backgroundColor = [UIColor blueColor];
    editButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [editButton setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                          forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [self.view addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
}


@end
