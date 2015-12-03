//
//  ViewController.m
//  InstantCare
//
//  Created by bruce-zhu on 15/11/27.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "ViewController.h"
#import "KMMemberManager.h"
#import "KMImageTitleButton.h"
#import "KMMainVC.h"
#import "KMRegisterVC.h"
#import "PNChart.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *rememberImageView;

@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *pdTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initLoginView];
}

- (void)initLoginView
{
    // logo
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"login_watch"];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_centerY).offset(-100);
        make.width.height.equalTo(@150);
        make.centerX.equalTo(self.view);
    }];

    // email
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.placeholder = NSLocalizedStringFromTable(@"VC_login_email", APP_LAN_TABLE, nil);
    self.emailTextField.textAlignment = NSTextAlignmentCenter;
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.font = [UIFont systemFontOfSize:18];
    self.emailTextField.text = [KMMemberManager sharedInstance].loginEmail;
    [self.view addSubview:self.emailTextField];
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@30);
        make.top.equalTo(logoImageView.mas_bottom).offset(30);
    }];

    // password
    self.pdTextField = [[UITextField alloc] init];
    self.pdTextField.placeholder = NSLocalizedStringFromTable(@"VC_login_pd", APP_LAN_TABLE, nil);
    self.pdTextField.textAlignment = NSTextAlignmentCenter;
    self.pdTextField.text = [KMMemberManager sharedInstance].loginPd;
    self.pdTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.pdTextField.secureTextEntry = YES;
    self.pdTextField.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:self.pdTextField];
    [self.pdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.emailTextField);
        make.top.equalTo(self.emailTextField.mas_bottom).offset(20);
    }];

    // remember
    UIView *rememberView = [[UIView alloc] init];
    self.rememberImageView = [[UIImageView alloc] init];
    if ([KMMemberManager sharedInstance].rememberLoginFlag) {
        self.rememberImageView.image = [UIImage imageNamed:@"omg_login_btn_circle_onclick"];
    } else {
        self.rememberImageView.image = [UIImage imageNamed:@"omg_login_btn_circle"];
    }
    self.rememberImageView.contentMode = UIViewContentModeScaleAspectFit;
    [rememberView addSubview:self.rememberImageView];
    [self.rememberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rememberView);
        make.height.width.equalTo(@20);
        make.centerY.equalTo(rememberView);
    }];
    
    UIButton *rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rememberBtn setTitle:NSLocalizedStringFromTable(@"VC_login_remember", APP_LAN_TABLE, nil)
                 forState:UIControlStateNormal];
    [rememberBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rememberBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, -30)];
    [rememberBtn addTarget:self
                    action:@selector(rememberBtnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    rememberBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [rememberView addSubview:rememberBtn];
    [rememberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rememberImageView);
        make.top.right.bottom.equalTo(rememberView);
    }];

    [self.view addSubview:rememberView];
    [rememberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(-15);
        make.left.equalTo(self.rememberImageView);
        make.right.equalTo(rememberBtn);
        make.height.equalTo(@30);
        make.top.equalTo(self.pdTextField.mas_bottom).offset(20);
    }];

    // forget password
    UIButton *forgetPd =[UIButton buttonWithType:UIButtonTypeSystem];
    [forgetPd setTitle:NSLocalizedStringFromTable(@"VC_login_forgetPd", APP_LAN_TABLE, nil)
              forState:UIControlStateNormal];
    [forgetPd addTarget:self
                 action:@selector(forgetPassWordBtnDidClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    forgetPd.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:forgetPd];
    [forgetPd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.emailTextField);
        make.top.equalTo(rememberBtn.mas_bottom).offset(10);
    }];
    
    // login button
    KMImageTitleButton *loginBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_login_btn_confirm_icon"]
                                                                       title:NSLocalizedStringFromTable(@"VC_login_OK", APP_LAN_TABLE, nil)];
    loginBtn.label.font = [UIFont systemFontOfSize:25];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                        forState:UIControlStateNormal];
    [loginBtn addTarget:self
                 action:@selector(loginBtnDidClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.right.equalTo(self.view.mas_centerX);
        make.height.equalTo(@100);
    }];
    
    // register button
    KMImageTitleButton *registerButton = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_login_btn_register_icon"]
                                                                             title:NSLocalizedStringFromTable(@"VC_login_Reg", APP_LAN_TABLE, nil)];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_register"]
                        forState:UIControlStateNormal];
    [registerButton addTarget:self
                       action:@selector(registerBtnDidClicked:)
             forControlEvents:UIControlEventTouchUpInside];
    registerButton.label.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.view);
        make.left.equalTo(self.view.mas_centerX);
        make.height.equalTo(@100);
    }];
}

- (void)rememberBtnDidClicked:(UIButton *)sender
{
    if ([KMMemberManager sharedInstance].rememberLoginFlag) {
        [KMMemberManager sharedInstance].rememberLoginFlag = NO;
        self.rememberImageView.image = [UIImage imageNamed:@"omg_login_btn_circle"];
    } else {
        [KMMemberManager sharedInstance].rememberLoginFlag = YES;
        self.rememberImageView.image = [UIImage imageNamed:@"omg_login_btn_circle_onclick"];
    }
}

#pragma mark 忘记密码
- (void)forgetPassWordBtnDidClicked:(UIButton *)sender
{
    NSLog(@"forgetPassWordBtnDidClicked");
}

#pragma mark 确认登录
- (void)loginBtnDidClicked:(UIButton *)sender
{
    // check
    if (self.emailTextField.text.length == 0 || self.pdTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"VC_login_error_input", APP_LAN_TABLE, nil)];
        return;
    }

    // save user login information
    if ([KMMemberManager sharedInstance].rememberLoginFlag) {
        [KMMemberManager sharedInstance].loginEmail = self.emailTextField.text;
        [KMMemberManager sharedInstance].loginPd = self.pdTextField.text;
    }
    
    // TODO: start to login
    
    KMMainVC *mainVC = [[KMMainVC alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark 注册
- (void)registerBtnDidClicked:(UIButton *)sender
{
    KMRegisterVC *vc = [[KMRegisterVC alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:navVC animated:YES completion:nil];
}

@end
