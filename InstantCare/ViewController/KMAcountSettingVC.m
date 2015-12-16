//
//  KMAcountSettingVC.m
//  InstantCare
//
//  Created by 朱正晶 on 15/12/6.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMAcountSettingVC.h"
#import "KMUserAccoutModel.h"
#import "KMAccountEditVC.h"

@interface KMAcountSettingVC()

@property (nonatomic, strong) UILabel *pdLabel;
@property (nonatomic, strong) KMUserAccoutModel *accountModel;

@end

@implementation KMAcountSettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNarBar];
    [self requestUserAccountProfile];
}

- (void)requestUserAccountProfile
{
    [SVProgressHUD showWithStatus:kNetReqNowStr];
    [[KMNetAPI manager] getUserAccountWithblock:^(int code, NSString *res) {
        KMNetworkResModel *model = [KMNetworkResModel mj_objectWithKeyValues:res];
        
        if (code == 0 && model.status == kNetReqSuccess) {
            [SVProgressHUD dismiss];
            self.accountModel = [KMUserAccoutModel mj_objectWithKeyValues:model.content];
            [self configView];
        } else {
            [SVProgressHUD showErrorWithStatus:model.msg ? model.msg : kNetReqFailStr];
        }
    }];
}

- (void)configNarBar
{
    self.navigationItem.title = NSLocalizedStringFromTable(@"AccountSetting_VC_title", APP_LAN_TABLE, nil);
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
    nameLabel.text = self.accountModel.name;
    [scrollView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(64 + 20);
        make.height.equalTo(@30);
    }];
    
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.font = [UIFont systemFontOfSize:18];
    nickNameLabel.text = @"not exist";
    [scrollView addSubview:nickNameLabel];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(nameLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    
    // email
    UILabel *emailLabel = [[UILabel alloc] init];
    emailLabel.font = [UIFont systemFontOfSize:18];
    emailLabel.text = self.accountModel.email;
    [scrollView addSubview:emailLabel];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(nickNameLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];

    //*********
    self.pdLabel = [[UILabel alloc] init];
    self.pdLabel.font = [UIFont systemFontOfSize:18];
    self.pdLabel.text = @"*********";
    [scrollView addSubview:self.pdLabel];
    [self.pdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(emailLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];

    // 显示密码按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 100;
    [btn setTitle:NSLocalizedStringFromTable(@"AccountSetting_VC_btn_title", APP_LAN_TABLE, nil)
         forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(btnDidClicked:)
  forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1;
    [scrollView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.pdLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];

    // birthday
    UILabel *birthdayLabel = [[UILabel alloc] init];
    birthdayLabel.font = [UIFont systemFontOfSize:18];
    birthdayLabel.text = self.accountModel.birth;
    [scrollView addSubview:birthdayLabel];
    [birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(btn.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    
    // address
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont systemFontOfSize:18];
    addressLabel.text = self.accountModel.address;
    [scrollView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(birthdayLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    
    // phoneNumber
    UILabel *phoneNumber = [[UILabel alloc] init];
    phoneNumber.font = [UIFont systemFontOfSize:18];
    phoneNumber.text = self.accountModel.phone;
    [scrollView addSubview:phoneNumber];
    [phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(addressLabel.mas_bottom).offset(15);
        make.height.equalTo(@30);
    }];
    
    // editButton
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.tag = 101;
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"omg_btn_edit_icon"]
                forState:UIControlStateNormal];
    [editButton addTarget:self
                   action:@selector(btnDidClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    editButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    editButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [editButton setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                          forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [self.view addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@40);
    }];
    
    UIView *grayLine = [[UIView alloc] init];
    grayLine.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@1);
        make.bottom.equalTo(editButton.mas_top);
    }];
}

- (void)btnDidClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:           // 显示或者隐藏密码的按钮
        {
            NSString *btnString = NSLocalizedStringFromTable(@"AccountSetting_VC_btn_title", APP_LAN_TABLE, nil);
            if ([sender.titleLabel.text isEqualToString:btnString]) {
                [sender setTitle:NSLocalizedStringFromTable(@"AccountSetting_VC_btn_title_hide", APP_LAN_TABLE, nil)
                        forState:UIControlStateNormal];
                // TODO: 需要从服务器拿数据
                self.pdLabel.text = self.accountModel.loginToken;
            } else {
                [sender setTitle:NSLocalizedStringFromTable(@"AccountSetting_VC_btn_title", APP_LAN_TABLE, nil)
                        forState:UIControlStateNormal];
                self.pdLabel.text = @"*********";
            }
        } break;
        case 101:           // 编辑按钮
        {
            KMAccountEditVC *vc = [[KMAccountEditVC alloc] init];
            vc.accountModel = self.accountModel;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        default:
            break;
    }
}

@end
