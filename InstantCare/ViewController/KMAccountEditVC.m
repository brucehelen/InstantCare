//
//  KMAccountEditVC.m
//  InstantCare
//
//  Created by 朱正晶 on 15/12/6.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMAccountEditVC.h"


#define kEdgeOffset         20
#define kTextFieldHeight    35
#define kButtonHeight       40

@interface KMAccountEditVC()

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *nickTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwdTextFiedl;
@property (nonatomic, strong) UITextField *againPasswdTextField;
@property (nonatomic, strong) UITextField *addressTextFiedl;
@property (nonatomic, strong) UITextField *phoneTextField;

@end

@implementation KMAccountEditVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNarBar];
    [self configView];
}

- (void)configNarBar
{
    self.navigationItem.title = NSLocalizedStringFromTable(@"AccountEdit_VC_title", APP_LAN_TABLE, nil);
}

- (void)configView
{
    WS(ws);
    
    // iphone4可能显示不全
    UIScrollView *scrollView = [UIScrollView new];
    
    scrollView = [UIScrollView new];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(2*kEdgeOffset,
                                                                 kEdgeOffset,
                                                                 kButtonHeight + kEdgeOffset,
                                                                 kEdgeOffset));
    }];

    UIView *container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    self.nameTextField = [UITextField new];
    self.nameTextField.font = [UIFont systemFontOfSize:18];
    self.nameTextField.text = self.accountModel.name;
    self.nameTextField.textAlignment = NSTextAlignmentCenter;
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [container addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(container);
        make.height.equalTo(@(kTextFieldHeight));
    }];
    
    self.nickTextField = [UITextField new];
    self.nickTextField.font = [UIFont systemFontOfSize:18];
    self.nickTextField.text = self.accountModel.name;
    self.nickTextField.textAlignment = NSTextAlignmentCenter;
    self.nickTextField.borderStyle = UITextBorderStyleRoundedRect;
    [container addSubview:self.nickTextField];
    [self.nickTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(ws.nameTextField);
        make.top.equalTo(ws.nameTextField.mas_bottom).offset(kEdgeOffset);
    }];

    self.emailTextField = [UITextField new];
    self.emailTextField.font = [UIFont systemFontOfSize:18];
    self.emailTextField.text = self.accountModel.email;
    self.emailTextField.textAlignment = NSTextAlignmentCenter;
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    [container addSubview:self.emailTextField];
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(ws.nameTextField);
        make.top.equalTo(ws.nickTextField.mas_bottom).offset(kEdgeOffset);
    }];

    // 密码
    self.passwdTextFiedl = [UITextField new];
    self.passwdTextFiedl.font = [UIFont systemFontOfSize:18];
    self.passwdTextFiedl.text = self.accountModel.loginToken;
    self.passwdTextFiedl.textAlignment = NSTextAlignmentCenter;
    self.passwdTextFiedl.borderStyle = UITextBorderStyleRoundedRect;
    [container addSubview:self.passwdTextFiedl];
    [self.passwdTextFiedl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(ws.nameTextField);
        make.top.equalTo(ws.emailTextField.mas_bottom).offset(kEdgeOffset);
    }];

    // 再次输入密码
    self.againPasswdTextField = [UITextField new];
    self.againPasswdTextField.font = [UIFont systemFontOfSize:18];
    self.againPasswdTextField.placeholder = kLoadStringWithKey(@"Reg_VC_tip_again_pd");
    self.againPasswdTextField.textAlignment = NSTextAlignmentCenter;
    self.againPasswdTextField.borderStyle = UITextBorderStyleRoundedRect;
    [container addSubview:self.againPasswdTextField];
    [self.againPasswdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(ws.nameTextField);
        make.top.equalTo(ws.passwdTextFiedl.mas_bottom).offset(kEdgeOffset);
    }];

    // 点击输入生日
    UIButton *birthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    birthBtn.clipsToBounds = YES;
    birthBtn.layer.cornerRadius = 5;
    [birthBtn setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateNormal];
    [birthBtn setTitle:kLoadStringWithKey(@"Reg_VC_tip_birthday") forState:UIControlStateNormal];
    [birthBtn addTarget:self
                 action:@selector(btnDidClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:birthBtn];
    [birthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(ws.nameTextField);
        make.top.equalTo(ws.againPasswdTextField.mas_bottom).offset(kEdgeOffset);
    }];

    // 地址
    self.addressTextFiedl = [UITextField new];
    self.addressTextFiedl.font = [UIFont systemFontOfSize:18];
    self.addressTextFiedl.text = self.accountModel.address;
    self.addressTextFiedl.textAlignment = NSTextAlignmentCenter;
    self.addressTextFiedl.borderStyle = UITextBorderStyleRoundedRect;
    [container addSubview:self.addressTextFiedl];
    [self.addressTextFiedl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(ws.nameTextField);
        make.top.equalTo(birthBtn.mas_bottom).offset(kEdgeOffset);
    }];
    
    // 电话
    self.phoneTextField = [UITextField new];
    self.phoneTextField.font = [UIFont systemFontOfSize:18];
    self.phoneTextField.text = self.accountModel.phone;
    self.phoneTextField.textAlignment = NSTextAlignmentCenter;
    self.phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    [container addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(ws.nameTextField);
        make.top.equalTo(ws.addressTextFiedl.mas_bottom).offset(kEdgeOffset);
    }];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.phoneTextField.mas_bottom);
    }];
    
    // 最下面两个按钮
    UIView *grayView = [UIView new];
    grayView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(ws.view);
        make.height.equalTo(@(kButtonHeight + 1));
    }];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.tag = 100;
    [okBtn setTitle:kLoadStringWithKey(@"VC_login_OK") forState:UIControlStateNormal];
    okBtn.titleEdgeInsets = UIEdgeInsetsMake(5, -30, 5, 0);
    [okBtn setImage:[UIImage imageNamed:@"omg_login_btn_confirm_icon"]
           forState:UIControlStateNormal];
    okBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [okBtn setBackgroundImage:[UIImage imageNamed:@"omg_call_btn_call"]
                     forState:UIControlStateNormal];
    [okBtn addTarget:self
              action:@selector(btnDidClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(ws.view);
        make.height.equalTo(@(kButtonHeight));
        make.width.equalTo(ws.view).multipliedBy(0.5).offset(-0.5);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.tag = 101;
    [cancelBtn setTitle:kLoadStringWithKey(@"Common_cancel") forState:UIControlStateNormal];
    cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(5, -30, 5, 0);
    [cancelBtn setImage:[UIImage imageNamed:@"omg_btn_cancel_icon"]
               forState:UIControlStateNormal];
    cancelBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"omg_health_btn_glucose_onclick"]
                         forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(btnDidClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(ws.view);
        make.height.equalTo(@(kButtonHeight));
        make.width.equalTo(ws.view).multipliedBy(0.5).offset(-0.5);
    }];
}

- (void)btnDidClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:     // 生日
            
            break;
        case 100:
            break;
        case 101:
            break;
        default:
            break;
    }
}

@end
