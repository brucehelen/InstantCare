//
//  KMRegisterVC.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/1.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMRegisterVC.h"
#import "CustomIOSAlertView.h"
#import "KMImageTitleButton.h"
#import "KMUserRegisterModel.h"
#import "KMNetAPI.h"

#define kEdgeOffset         18      // 控制边距
#define kTextFieldHeight    35      // 中间每个控件的高度
#define KButtonHeight       50      // 最下面两个按钮的高度

@interface KMRegisterVC() <CustomIOSAlertViewDelegate>

@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *nicknameTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *pdTextField;
@property (nonatomic, strong) UITextField *againPdTextField;
@property (nonatomic, strong) UIButton *birthdayBtn;
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UITextField *phoneTextField;

@end

@implementation KMRegisterVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self configNavBar];
    [self configView];
}

- (void)configNavBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-button"]
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(leftBarButtonDidClicked:)];
    self.navigationItem.title = NSLocalizedStringFromTable(@"Reg_VC_title", APP_LAN_TABLE, nil);
}

- (void)configView
{
    WS(sw);
    WS_SELF(sv, self.view);
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    [sv addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sv).with.insets(UIEdgeInsetsMake(kEdgeOffset, kEdgeOffset, KButtonHeight + kEdgeOffset, kEdgeOffset));
    }];

    UIView *container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];

    // 姓名
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.textAlignment = NSTextAlignmentCenter;
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_name", APP_LAN_TABLE, nil);
    [container addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(container);
        make.top.equalTo(container);
        make.height.equalTo(@kTextFieldHeight);
    }];

    // 昵称
    self.nicknameTextField = [[UITextField alloc] init];
    self.nicknameTextField.textAlignment = NSTextAlignmentCenter;
    self.nicknameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nicknameTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_nickname", APP_LAN_TABLE, nil);
    [container addSubview:self.nicknameTextField];
    [self.nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(sw.nameTextField);
        make.top.equalTo(sw.nameTextField.mas_bottom).offset(kEdgeOffset);
    }];

    // E-mail
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.textAlignment = NSTextAlignmentCenter;
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_email", APP_LAN_TABLE, nil);
    [container addSubview:self.emailTextField];
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(sw.nameTextField);
        make.top.equalTo(sw.nicknameTextField.mas_bottom).offset(kEdgeOffset);
    }];

    // 密码
    self.pdTextField = [[UITextField alloc] init];
    self.pdTextField.textAlignment = NSTextAlignmentCenter;
    self.pdTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.pdTextField.secureTextEntry = YES;
    self.pdTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_password", APP_LAN_TABLE, nil);
    [container addSubview:self.pdTextField];
    [self.pdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(sw.nameTextField);
        make.top.equalTo(sw.emailTextField.mas_bottom).offset(kEdgeOffset);
    }];

    // 再次输入密码
    self.againPdTextField = [[UITextField alloc] init];
    self.againPdTextField.textAlignment = NSTextAlignmentCenter;
    self.againPdTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.againPdTextField.secureTextEntry = YES;
    self.againPdTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_again_pd", APP_LAN_TABLE, nil);
    [container addSubview:self.againPdTextField];
    [self.againPdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(sw.nameTextField);
        make.top.equalTo(sw.pdTextField.mas_bottom).offset(kEdgeOffset);
    }];

    // 生日
    self.birthdayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.birthdayBtn setTitle:NSLocalizedStringFromTable(@"Reg_VC_tip_birthday", APP_LAN_TABLE, nil)
                 forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"omg_register_btn_date"];
    [self.birthdayBtn setBackgroundImage:image
                                forState:UIControlStateNormal];
    [self.birthdayBtn addTarget:self
                         action:@selector(birthdayInputBtnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:self.birthdayBtn];
    [self.birthdayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(sw.nameTextField);
        make.top.equalTo(sw.againPdTextField.mas_bottom).with.offset(kEdgeOffset);
    }];

    // 地址
    self.addressTextField = [[UITextField alloc] init];
    self.addressTextField.textAlignment = NSTextAlignmentCenter;
    self.addressTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.addressTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_address", APP_LAN_TABLE, nil);
    [container addSubview:self.addressTextField];
    [self.addressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(sw.nameTextField);
        make.top.equalTo(sw.birthdayBtn.mas_bottom).offset(kEdgeOffset);
    }];

    // 电话
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.textAlignment = NSTextAlignmentCenter;
    self.phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_phone", APP_LAN_TABLE, nil);
    [container addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(sw.nameTextField);
        make.top.equalTo(sw.addressTextField.mas_bottom).offset(kEdgeOffset);
    }];

    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sw.phoneTextField.mas_bottom);
    }];

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor grayColor];
    [sv addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(sv);
        make.height.equalTo(@(KButtonHeight + 1));
    }];

    // 最下面的确认和取消
    KMImageTitleButton *OKBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_login_btn_confirm_icon"]
                                                                    title:NSLocalizedStringFromTable(@"Reg_VC_birthday_OK", APP_LAN_TABLE, nil)];
    OKBtn.tag = 100;
    OKBtn.label.font = [UIFont systemFontOfSize:25];
    [OKBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                      forState:UIControlStateNormal];
    [OKBtn addTarget:self
               action:@selector(btnDidClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKBtn];
    [OKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sv);
        make.bottom.equalTo(sv);
        make.right.equalTo(sv.mas_centerX).offset(-.5);
        make.height.equalTo(@KButtonHeight);
    }];

    KMImageTitleButton *CancelBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_register_btn_cancel_icon"]
                                                                        title:NSLocalizedStringFromTable(@"Reg_VC_birthday_cancel", APP_LAN_TABLE, nil)];
    CancelBtn.tag = 101;
    CancelBtn.label.font = [UIFont systemFontOfSize:25];
    [CancelBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_register"]
                     forState:UIControlStateNormal];
    [CancelBtn addTarget:self
                  action:@selector(btnDidClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:CancelBtn];
    [CancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sv);
        make.bottom.equalTo(sv);
        make.left.equalTo(sv.mas_centerX).offset(0.5);
        make.height.equalTo(@(KButtonHeight));
    }];
}

#pragma mark - 出生日期弹出view
- (void)birthdayInputBtnDidClicked:(UIButton *)sender
{
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self createBirthdayView]];

    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:NSLocalizedStringFromTable(@"Reg_VC_birthday_cancel", APP_LAN_TABLE, nil),
                                NSLocalizedStringFromTable(@"Reg_VC_birthday_OK", APP_LAN_TABLE, nil), nil]];
    [alertView setDelegate:self];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

- (void)btnDidClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:       // 确认
        {
            // 用户名和密码必填
            [self StartLogin];
        } break;
        case 101:       // 取消
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        } break;
        default:
            break;
    }
}

#pragma mark - 登录
- (void)StartLogin
{
    // 检查用户名和密码
    // TODO: 检查邮箱是否输入正确
    if (self.pdTextField.text.length == 0 ||
        self.againPdTextField.text.length == 0 ||
        self.emailTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"Reg_VC_register_tip", APP_LAN_TABLE, nil)];
        return;
    }

    // 两次输入的密码必须一致
    if (self.pdTextField.text.length == 0 ||
        self.againPdTextField.text.length == 0 ||
        ![self.againPdTextField.text isEqualToString:self.pdTextField.text]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"Reg_VC_register_password_error", APP_LAN_TABLE, nil)];
        return;
    }

    NSString *birthString;
    if ([self.birthdayBtn.titleLabel.text isEqualToString:NSLocalizedStringFromTable(@"Reg_VC_tip_birthday", APP_LAN_TABLE, nil)]) {
        birthString = nil;
    } else {
        birthString = self.birthdayBtn.titleLabel.text;
    }
    KMUserRegisterModel *registerModel = [[KMUserRegisterModel alloc] init];
    registerModel.loginToken = self.emailTextField.text;
    registerModel.email = self.emailTextField.text;
    registerModel.passwd = self.pdTextField.text;
    registerModel.name = self.nameTextField.text.length ? self.nameTextField.text : nil;
    registerModel.address = self.addressTextField.text.length ? self.addressTextField.text : nil;
    registerModel.birth = birthString;
    registerModel.phone = self.phoneTextField.text.length ? self.phoneTextField.text : nil;

    WS(ws);
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"Reg_VC_register_now", APP_LAN_TABLE, nil)];
    [[KMNetAPI manager] userRegisterWithModel:registerModel
                                        block:^(int code, NSString *res) {
                                            NSLog(@"res: %@", res);
                                            // {"msg":"regester success!"}
                                            NSRange range = [res rangeOfString:@"regester success!"];
                                            if (code == 0 && range.length != 0) {
                                                [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"Reg_VC_register_success", APP_LAN_TABLE, nil)];
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                    [ws dismissViewControllerAnimated:YES completion:nil];
                                                });
                                            } else {
                                                [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"Reg_VC_register_fail", APP_LAN_TABLE, nil)];
                                            }
                                        }];
}

- (void)leftBarButtonDidClicked:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIDatePicker *datePicker = [alertView.containerView viewWithTag:100];
        NSLog(@"datePicker = %@", datePicker.date);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        [self.birthdayBtn setTitle:[dateFormatter stringFromDate:datePicker.date] forState:UIControlStateNormal];
    }
    
    [alertView close];
}

- (UIView *)createBirthdayView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 280)];

    UILabel *label = [[UILabel alloc] init];
    label.text = NSLocalizedStringFromTable(@"Reg_VC_birthday", APP_LAN_TABLE, nil);
    [demoView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(demoView);
        make.top.equalTo(demoView).offset(15);
    }];

    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width - 20, 250)];
    datePicker.tag = 100;
    datePicker.clipsToBounds = YES;
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];

    [demoView addSubview:datePicker];

    return demoView;
}


@end
