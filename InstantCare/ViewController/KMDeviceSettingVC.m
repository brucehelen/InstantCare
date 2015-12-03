//
//  KMDeviceSettingVC.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/2.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMDeviceSettingVC.h"
#import "KMCallCell.h"
#import "CustomIOSAlertView.h"
#import "KMImageTitleButton.h"
#import "KMDeviceEditVC.h"

#define kEdgeOffset         15
#define kTextFieldHeight    30

@interface KMDeviceSettingVC() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CustomIOSAlertView *alertView;
@property (nonatomic, strong) CustomIOSAlertView *addNewDeviceAlertView;

@end

@implementation KMDeviceSettingVC

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(rightBarButtonDidClicked:)];

    self.navigationItem.title = NSLocalizedStringFromTable(@"MAIN_VC_menu_device", APP_LAN_TABLE, nil);
}

- (void)configView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)leftBarButtonDidClicked:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonDidClicked:(UIBarButtonItem *)item
{
    self.addNewDeviceAlertView = [[CustomIOSAlertView alloc] init];
    self.addNewDeviceAlertView.containerView = [self createAddNewDeviceAlertVire];
    self.addNewDeviceAlertView.buttonTitles = nil;
    [self.addNewDeviceAlertView setUseMotionEffects:YES];

    [self.addNewDeviceAlertView show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMCallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[KMCallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    self.alertView = [[CustomIOSAlertView alloc] init];

    [self.alertView setContainerView:[self createAlertView]];
    [self.alertView setButtonTitles:nil];
    [self.alertView setUseMotionEffects:YES];

    [self.alertView show];
}

#pragma mark - 新增设备AlertView
- (UIView *)createAddNewDeviceAlertVire
{
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 350)];
    
    // 新增资料
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = NSLocalizedStringFromTable(@"DeviceSetting_VC_add_device", APP_LAN_TABLE, nil);
    addLabel.font = [UIFont boldSystemFontOfSize:20];
    [alertView addSubview:addLabel];
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView);
        make.top.equalTo(alertView).offset(10);
    }];
    
    // 头像
    UIButton *headerBtn = [[UIButton alloc] init];
    [headerBtn setBackgroundImage:[UIImage imageNamed:@"omg_setting_add"]
                         forState:UIControlStateNormal];
    headerBtn.contentMode = UIViewContentModeScaleAspectFill;
    headerBtn.clipsToBounds = YES;
    [alertView addSubview:headerBtn];
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView);
        make.width.height.equalTo(@80);
        make.top.equalTo(addLabel.mas_bottom).with.offset(10);
    }];

    // 点击头像以做更换
    UILabel *headTipLabel = [[UILabel alloc] init];
    headTipLabel.text = NSLocalizedStringFromTable(@"DeviceSetting_VC_add_header_tip", APP_LAN_TABLE, nil);
    headTipLabel.font = [UIFont systemFontOfSize:18];
    [alertView addSubview:headTipLabel];
    [headTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView);
        make.top.equalTo(headerBtn.mas_bottom).with.offset(10);
    }];
    
    // 名字TextField
    UITextField *nameTextField = [[UITextField alloc] init];
    nameTextField.backgroundColor = [UIColor whiteColor];
    nameTextField.placeholder = NSLocalizedStringFromTable(@"DeviceSetting_VC_add_name", APP_LAN_TABLE, nil);
    nameTextField.textAlignment = NSTextAlignmentCenter;
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [alertView addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertView).offset(kEdgeOffset);
        make.right.equalTo(alertView).offset(-kEdgeOffset);
        make.height.equalTo(@kTextFieldHeight);
        make.top.equalTo(headTipLabel.mas_bottom).offset(10);
    }];

    // 电话TextField
    UITextField *phoneTextField = [[UITextField alloc] init];
    phoneTextField.backgroundColor = [UIColor whiteColor];
    phoneTextField.placeholder = NSLocalizedStringFromTable(@"DeviceSetting_VC_add_phone", APP_LAN_TABLE, nil);
    phoneTextField.textAlignment = NSTextAlignmentCenter;
    phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    [alertView addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(nameTextField);
        make.top.equalTo(nameTextField.mas_bottom).offset(10);
    }];

    // 扫描QR button
    UIButton *QRButton = [UIButton buttonWithType:UIButtonTypeCustom];
    QRButton.clipsToBounds = YES;
    [QRButton setBackgroundImage:[UIImage imageNamed:@"omg_setting_btn_scan"]
                        forState:UIControlStateNormal];
    [alertView addSubview:QRButton];
    [QRButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneTextField);
        make.width.height.equalTo(@kTextFieldHeight);
    }];

    // IMEI
    UITextField *imeiShadowTextField = [[UITextField alloc] init];
    imeiShadowTextField.backgroundColor = [UIColor whiteColor];
    imeiShadowTextField.borderStyle = UITextBorderStyleRoundedRect;
    [alertView addSubview:imeiShadowTextField];
    [imeiShadowTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(nameTextField);
        make.right.equalTo(QRButton.mas_left).offset(-kEdgeOffset);
        make.top.equalTo(phoneTextField.mas_bottom).offset(10);
    }];

    UITextField *imeiTextField = [[UITextField alloc] init];
    imeiTextField.placeholder = NSLocalizedStringFromTable(@"DeviceSetting_VC_add_imei", APP_LAN_TABLE, nil);
    imeiTextField.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:imeiTextField];
    [imeiTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertView).offset(2*kEdgeOffset + kTextFieldHeight);
        make.height.equalTo(nameTextField);
        make.right.equalTo(QRButton.mas_left).offset(-kEdgeOffset);
        make.top.equalTo(phoneTextField.mas_bottom).offset(10);
    }];
    
    [QRButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imeiShadowTextField);
    }];
    
    // 完成 - 200
    KMImageTitleButton *completeBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_login_btn_confirm_icon"]
                                                                          title:NSLocalizedStringFromTable(@"DeviceSetting_VC_add_OK", APP_LAN_TABLE, nil)];
    completeBtn.tag = 200;
    completeBtn.label.font = [UIFont boldSystemFontOfSize:22];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                           forState:UIControlStateNormal];
    [completeBtn addTarget:self
                    action:@selector(btnDidClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertView);
        make.bottom.equalTo(alertView);
        make.width.equalTo(alertView).multipliedBy(0.5);
        make.height.equalTo(@40);
    }];

    // 取消 - 201
    KMImageTitleButton *cancelBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_btn_cancel_icon"]
                                                                        title:NSLocalizedStringFromTable(@"DeviceSetting_VC_add_cancel", APP_LAN_TABLE, nil)];
    cancelBtn.tag = 201;
    cancelBtn.label.font = [UIFont boldSystemFontOfSize:22];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_register"]
                           forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                    action:@selector(btnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(alertView);
        make.bottom.equalTo(alertView);
        make.width.equalTo(alertView).multipliedBy(0.5);
        make.height.equalTo(@40);
    }];

    return alertView;
}

#pragma mark - 编辑资料AlertView
- (UIView *)createAlertView
{
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];

    UIView *labelShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*2, 180)];
    labelShowView.tag = 10;

    UILabel *label = [[UILabel alloc] init];
    label.text = NSLocalizedStringFromTable(@"DeviceSetting_VC_select", APP_LAN_TABLE, nil);
    label.font = [UIFont boldSystemFontOfSize:20];
    [labelShowView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelShowView).multipliedBy(.5);
        make.top.equalTo(labelShowView).offset(15);
    }];

    // TODO: 从数据模型中获取
    // 姓名Label
    NSString *nameString = @"王先生";
    NSString *numberString = @"0921766116";
    NSString *string = [NSString stringWithFormat:@"%@  %@", nameString, numberString];
    NSMutableAttributedString * attributedString= [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, nameString.length)];

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.attributedText = attributedString;
    [labelShowView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelShowView).multipliedBy(.5);
        make.top.equalTo(label.mas_bottom).offset(20);
    }];

    NSString *IMEIString = @"IMEI";
    NSString *IMEI = @"122568845523369985";
    NSString *string2 = [NSString stringWithFormat:@"%@  %@", IMEIString, IMEI];
    NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:string2];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, IMEIString.length)];
    UILabel *imeiLabel = [[UILabel alloc] init];
    imeiLabel.attributedText = attributedString2;
    [labelShowView addSubview:imeiLabel];
    [imeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelShowView).multipliedBy(.5);
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
    }];

    // 删除label
    UILabel *deleteLabel = [[UILabel alloc] init];
    deleteLabel.text = NSLocalizedStringFromTable(@"DeviceSetting_VC_delete_confirm", APP_LAN_TABLE, nil);
    deleteLabel.font = [UIFont boldSystemFontOfSize:18];
    [labelShowView addSubview:deleteLabel];
    [deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelShowView).multipliedBy(1.5);
        make.top.equalTo(label.mas_bottom).offset(20);
    }];

    // 编辑按钮 - 100
    KMImageTitleButton *editBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_btn_edit_icon"]
                                                                      title:NSLocalizedStringFromTable(@"DeviceSetting_VC_edit", APP_LAN_TABLE, nil)];
    editBtn.tag = 100;
    editBtn.label.font = [UIFont boldSystemFontOfSize:22];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                      forState:UIControlStateNormal];
    [editBtn addTarget:self
               action:@selector(btnDidClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [labelShowView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelShowView);
        make.bottom.equalTo(labelShowView);
        make.width.equalTo(labelShowView).multipliedBy(0.25);
        make.height.equalTo(@40);
    }];

    // 删除按钮 - 101
    KMImageTitleButton *delBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_btn_cancel_icon"]
                                                                     title:NSLocalizedStringFromTable(@"DeviceSetting_VC_delete", APP_LAN_TABLE, nil)];
    delBtn.tag = 101;
    delBtn.label.font = [UIFont boldSystemFontOfSize:22];
    [delBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_register"]
                       forState:UIControlStateNormal];
    [delBtn addTarget:self
               action:@selector(btnDidClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [labelShowView addSubview:delBtn];
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(editBtn.mas_right);
        make.bottom.equalTo(labelShowView);
        make.width.equalTo(labelShowView).multipliedBy(0.25);
        make.height.equalTo(@40);
    }];

    // 确认按钮 - 102
    KMImageTitleButton *confirmBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_login_btn_confirm_icon"]
                                                                         title:NSLocalizedStringFromTable(@"DeviceSetting_VC_OK", APP_LAN_TABLE, nil)];
    confirmBtn.tag = 102;
    confirmBtn.label.font = [UIFont boldSystemFontOfSize:22];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                       forState:UIControlStateNormal];
    [confirmBtn addTarget:self
                action:@selector(btnDidClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [labelShowView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(delBtn.mas_right);
        make.bottom.equalTo(labelShowView);
        make.width.equalTo(labelShowView).multipliedBy(0.25);
        make.height.equalTo(@40);
    }];

    // 取消按钮 - 103
    KMImageTitleButton *cancelBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_btn_cancel_icon"]
                                                                        title:NSLocalizedStringFromTable(@"DeviceSetting_VC_cancel", APP_LAN_TABLE, nil)];
    cancelBtn.tag = 103;
    cancelBtn.label.font = [UIFont boldSystemFontOfSize:22];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_register"]
                          forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(btnDidClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [labelShowView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmBtn.mas_right);
        make.bottom.equalTo(labelShowView);
        make.width.equalTo(labelShowView).multipliedBy(0.25);
        make.height.equalTo(@40);
    }];

    [alertView addSubview:labelShowView];

    return alertView;
}

- (void)btnDidClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:       // 编辑
        {
            [self.alertView close];
            self.alertView = nil;
            KMDeviceEditVC *vc = [[KMDeviceEditVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 101:       // 删除
        {
            UIView *view = [self.alertView.containerView viewWithTag:10];
            [UIView animateWithDuration:.5 animations:^{
                CGRect frame = view.frame;
                frame.origin.x = -self.view.frame.size.width;
                view.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
        } break;
        case 102:       // 确认
            [self.alertView close];
            self.alertView = nil;
            [SVProgressHUD showInfoWithStatus:NSLocalizedStringFromTable(@"DeviceSetting_VC_delete_success", APP_LAN_TABLE, nil)];
            break;
        case 103:       // 取消
            [self.alertView close];
            self.alertView = nil;
            break;
        case 200:       // 新增资料完成
        {
            [self.addNewDeviceAlertView close];
            self.addNewDeviceAlertView = nil;
            [SVProgressHUD showInfoWithStatus:@"发送网络请求"];
        } break;
        case 201:       // 新增资料取消
        {
            [self.addNewDeviceAlertView close];
            self.addNewDeviceAlertView = nil;
        } break;
        default:
            break;
    }
}

@end