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
#import "AFNetworking.h"
#import "KMNetAPI.h"
#import "KMUserModel.h"
#import "APService.h"

#define kPerImageInterval       0.08        // 启动动画播放间隔

@interface ViewController ()

// 启动动画
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *logoStaticImageView;

@property (nonatomic, strong) UIImageView *rememberImageView;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *pdTextField;

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self startLogoAnimation];
    
}

- (void)startLogoAnimation
{
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.logoImageView];
    [self.logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@80);
    }];
    self.logoStaticImageView = [[UIImageView alloc] init];
    self.logoStaticImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoStaticImageView.image = [UIImage imageNamed:NSLocalizedStringFromTable(@"VC_login_logo_image_name", APP_LAN_TABLE, nil)];
    [self.view addSubview:self.logoStaticImageView];
    [self.logoStaticImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@150);
        make.height.equalTo(@60);
    }];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < 33; i++) {
        NSString *imageName = [NSString stringWithFormat:@"omg_loading_ani_%d", i];
        UIImage *image = [UIImage imageNamed:imageName];
        [imageArray addObject:image];
    }
    self.logoImageView.animationImages = imageArray;
    self.logoImageView.animationRepeatCount = 1;
    self.logoImageView.animationDuration = imageArray.count*kPerImageInterval;
    [self.logoImageView startAnimating];
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (imageArray.count*kPerImageInterval + 0.01) * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        // 释放启动画面资源
        [self.logoImageView removeFromSuperview];
        [self.logoStaticImageView removeFromSuperview];
        self.logoImageView = nil;
        self.logoStaticImageView = nil;
        // 显示登录界面
        [self initLoginView];
        // 注册极光通知
        //[self configJPush];
    });
}

- (void)initLoginView
{
    // logo
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"login_watch"];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_centerY).offset(-65);
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

    // 按钮灰色边框
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
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
        make.right.equalTo(self.view.mas_centerX).offset(-0.5);
        make.height.equalTo(@(0.15*SCREEN_HEIGHT));
    }];
    
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn).offset(-1);
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
        make.left.equalTo(self.view.mas_centerX).offset(0.5);
        make.height.equalTo(@(0.15*SCREEN_HEIGHT));
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
    [SVProgressHUD showInfoWithStatus:@"忘记密码"];
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
    } else {
        [KMMemberManager sharedInstance].loginEmail = @"";
        [KMMemberManager sharedInstance].loginPd = @"";
    }

    // start to login
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"VC_login_login_now", APP_LAN_TABLE, nil)];
    [[KMNetAPI manager] loginWithUserName:self.emailTextField.text
                                 password:self.pdTextField.text
                                      gid:@""
                                    block:^(int code, NSString *res) {
                                        NSLog(@"code = %d, login = %@", code, res);
                                        member.userModel = [KMUserModel mj_objectWithKeyValues:res];
                                        if (code == 0 && member.userModel.key.length != 0) {
                                            [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"VC_login_login_success", APP_LAN_TABLE, nil)];
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                KMMainVC *mainVC = [[KMMainVC alloc] init];
                                                UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
                                                
                                                [self presentViewController:navVC animated:YES completion:nil];
                                            });
                                        } else {
                                            [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"VC_login_login_fail", APP_LAN_TABLE, nil)];
                                        }
                                    }];
}

#pragma mark 注册
- (void)registerBtnDidClicked:(UIButton *)sender
{
    KMRegisterVC *vc = [[KMRegisterVC alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - 极光推送
- (void)configJPush
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

- (void)networkDidSetup:(NSNotification *)notification
{
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification
{
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification
{
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification
{
    NSLog(@"已登录");

    if ([APService registrationID]) {
        NSLog(@"get RegistrationID = %@", [APService registrationID]);
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, [self logDic:extra]];
    NSLog(@"%@", currentContent);
}

- (void)serviceError:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic
{
    if (![dic count]) {
        return nil;
    }

    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (void)dealloc
{
    [self unObserveAllNotifications];
}

@end
