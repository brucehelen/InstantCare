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

#define kEdgeOffset         18
#define kTextFieldHeight    27

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
    // 姓名
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.textAlignment = NSTextAlignmentCenter;
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_name", APP_LAN_TABLE, nil);
    [self.view addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kEdgeOffset);
        make.right.equalTo(self.view).offset(-kEdgeOffset);
        make.top.equalTo(self.view).offset(64 + kEdgeOffset);
        make.height.equalTo(@kTextFieldHeight);
    }];
    
    // 昵称
    self.nicknameTextField = [[UITextField alloc] init];
    self.nicknameTextField.textAlignment = NSTextAlignmentCenter;
    self.nicknameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nicknameTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_nickname", APP_LAN_TABLE, nil);
    [self.view addSubview:self.nicknameTextField];
    [self.nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nameTextField);
        make.top.equalTo(self.nameTextField.mas_bottom).offset(kEdgeOffset);
    }];
    
    // E-mail
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.textAlignment = NSTextAlignmentCenter;
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_email", APP_LAN_TABLE, nil);
    [self.view addSubview:self.emailTextField];
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nameTextField);
        make.top.equalTo(self.nicknameTextField.mas_bottom).offset(kEdgeOffset);
    }];
    
    // 密码
    self.pdTextField = [[UITextField alloc] init];
    self.pdTextField.textAlignment = NSTextAlignmentCenter;
    self.pdTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.pdTextField.secureTextEntry = YES;
    self.pdTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_password", APP_LAN_TABLE, nil);
    [self.view addSubview:self.pdTextField];
    [self.pdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nameTextField);
        make.top.equalTo(self.emailTextField.mas_bottom).offset(kEdgeOffset);
    }];

    // 再次输入密码
    self.againPdTextField = [[UITextField alloc] init];
    self.againPdTextField.textAlignment = NSTextAlignmentCenter;
    self.againPdTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.againPdTextField.secureTextEntry = YES;
    self.againPdTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_again_pd", APP_LAN_TABLE, nil);
    [self.view addSubview:self.againPdTextField];
    [self.againPdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nameTextField);
        make.top.equalTo(self.pdTextField.mas_bottom).offset(kEdgeOffset);
    }];

    // 生日
    self.birthdayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.birthdayBtn setTitle:NSLocalizedStringFromTable(@"Reg_VC_tip_birthday", APP_LAN_TABLE, nil)
                 forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"omg_register_btn_date"];
    //UIEdgeInsets insets = UIEdgeInsetsMake(10, 100, 10, 100);
    //UIImage *newImage = [oldImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.birthdayBtn setBackgroundImage:image
                           forState:UIControlStateNormal];
    [self.birthdayBtn addTarget:self
                    action:@selector(birthdayInputBtnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.birthdayBtn];
    [self.birthdayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nameTextField);
        make.top.equalTo(self.againPdTextField.mas_bottom).with.offset(kEdgeOffset);
    }];

    // 地址
    self.addressTextField = [[UITextField alloc] init];
    self.addressTextField.textAlignment = NSTextAlignmentCenter;
    self.addressTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.addressTextField.secureTextEntry = YES;
    self.addressTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_address", APP_LAN_TABLE, nil);
    [self.view addSubview:self.addressTextField];
    [self.addressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nameTextField);
        make.top.equalTo(self.birthdayBtn.mas_bottom).offset(kEdgeOffset);
    }];

    // 电话
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.textAlignment = NSTextAlignmentCenter;
    self.phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.phoneTextField.secureTextEntry = YES;
    self.phoneTextField.placeholder = NSLocalizedStringFromTable(@"Reg_VC_tip_phone", APP_LAN_TABLE, nil);
    [self.view addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nameTextField);
        make.top.equalTo(self.addressTextField.mas_bottom).offset(kEdgeOffset);
    }];
    
    // 最下面的确认和取消
    KMImageTitleButton *OKBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_login_btn_confirm_icon"]
                                                                     title:NSLocalizedStringFromTable(@"Reg_VC_birthday_OK", APP_LAN_TABLE, nil)];
    OKBtn.tag = 103;
    OKBtn.label.font = [UIFont systemFontOfSize:25];
    [OKBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                      forState:UIControlStateNormal];
    [OKBtn addTarget:self
               action:@selector(btnDidClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:OKBtn];
    [OKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view.mas_centerX);
        make.height.equalTo(@50);
    }];
    
    KMImageTitleButton *CancelBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_login_btn_confirm_icon"]
                                                                        title:NSLocalizedStringFromTable(@"Reg_VC_birthday_cancel", APP_LAN_TABLE, nil)];
    CancelBtn.tag = 103;
    CancelBtn.label.font = [UIFont systemFontOfSize:25];
    [CancelBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_register"]
                     forState:UIControlStateNormal];
    [CancelBtn addTarget:self
                  action:@selector(btnDidClicked:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:CancelBtn];
    [CancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view.mas_centerX);
        make.height.equalTo(@50);
    }];
}

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
