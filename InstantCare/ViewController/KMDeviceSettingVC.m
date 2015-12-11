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
#import "LBXScanView.h"
#import "KMQRCodeVC.h"
#import "KMBundleDevicesResModel.h"

#define kEdgeOffset         15
#define kTextFieldHeight    30

@interface KMDeviceSettingVC() <UITableViewDataSource, UITableViewDelegate, KMQRCodeVCDelegate>

@property (nonatomic, strong) UITableView *tableView;
// 添加设备
@property (nonatomic, strong) CustomIOSAlertView *addNewDeviceAlertView;
@property (nonatomic, strong) UITextField *imeiTextField;
// 编辑
@property (nonatomic, strong) CustomIOSAlertView *alertView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *imeiLabel;
@property (nonatomic, copy) NSString *imei;
// 设备列表
@property (nonatomic, strong) NSArray *devicesArray;

@end

@implementation KMDeviceSettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self configNavBar];
    [self configView];
    [self getDevicesFromServer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)configNavBar
{
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
    self.tableView.rowHeight = 70;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)rightBarButtonDidClicked:(UIBarButtonItem *)item
{
    if (self.addNewDeviceAlertView) {
        [self.addNewDeviceAlertView removeFromSuperview];
        self.addNewDeviceAlertView = nil;
    }

    self.addNewDeviceAlertView = [[CustomIOSAlertView alloc] init];
    self.addNewDeviceAlertView.parentView = self.view;
    self.addNewDeviceAlertView.containerView = [self createAddNewDeviceAlertVire];
    self.addNewDeviceAlertView.buttonTitles = nil;
    [self.addNewDeviceAlertView setUseMotionEffects:YES];

    [self.addNewDeviceAlertView show];
}

#pragma mark - 获取设备列表
- (void)getDevicesFromServer
{
    WS(ws);
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"Call_VC_getdevices", APP_LAN_TABLE, nil)];
    [[KMNetAPI manager] getDevicesWithid:member.userModel.id
                                     key:member.userModel.key
                                   block:^(int code, NSString *res) {
                                       NSLog(@"res = %@", res);
                                       KMBundleDevicesResModel *devices = [KMBundleDevicesResModel mj_objectWithKeyValues:res];
                                       NSLog(@"devices = %@", devices.content.devices);
                                       ws.devicesArray = devices.content.devices;
                                       if (code == 0 && devices.status == kNetReqSuccess) {
                                           [SVProgressHUD dismiss];
                                           [ws.tableView reloadData];
                                       } else {
                                           [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"Call_VC_getdevices_fail", APP_LAN_TABLE, nil)];
                                       }
                                   }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devicesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMCallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[KMCallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *imei = self.devicesArray[indexPath.row];
    
    // 头像
    UIImage *headerImage = [KMMemberManager userHeaderImageWithIMEI:imei];
    if (headerImage) {      // 已经存储过头像
        cell.headImageView.image = headerImage;
    } else {                // 没有在这个手机存储头像，使用默认的头像
        cell.headImageView.image = [UIImage imageNamed:@"omg_call_noimage"];
    }

    // 手表
    KMUserWatchType watchType = [KMMemberManager userWatchTypeWithIMEI:imei];
    switch (watchType) {
        case KM_WATCH_TYPE_GOLD:
            cell.watchImageView.image = [UIImage imageNamed:@"omg_call_icon_watch_gold"];
            break;
        case KM_WATCH_TYPE_BLACK:
            cell.watchImageView.image = [UIImage imageNamed:@"omg_call_icon_watch_black"];
            break;
        case KM_WATCH_TYPE_ORANGE:
            cell.watchImageView.image = [UIImage imageNamed:@"omg_call_icon_watch_orange"];
            break;
        default:
            break;
    }

    // 姓名
    NSString *userName = [KMMemberManager userNameWithIMEI:imei];
    if (userName) {         // 已经设置过姓名
        cell.nameLabel.text = userName;
    } else {                // 没有设置姓名，使用默认的姓名
        cell.nameLabel.text = NSLocalizedStringFromTable(@"Call_VC_getdevices_user_name_not_set", APP_LAN_TABLE, nil);
    }

    // 电话号码
    NSString *phoneNumber = [KMMemberManager userPhoneNumberWithIMEI:imei];
    if (phoneNumber) {      // 设置过电话号码
        cell.phoneLabel.text = phoneNumber;
    } else {                // 没有设置过
        cell.phoneLabel.text = NSLocalizedStringFromTable(@"Call_VC_getdevices_phone_number_not_set", APP_LAN_TABLE, nil);
    }

    return cell;
}

#pragma mark - 选择编辑设备
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    self.alertView = [[CustomIOSAlertView alloc] init];

    [self.alertView setContainerView:[self createAlertView]];
    // 根据数据模型配置
    [self configAlertViewWithIndexPath:indexPath];
    [self.alertView setButtonTitles:nil];
    [self.alertView setUseMotionEffects:YES];

    [self.alertView show];
}

- (void)configAlertViewWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *imei = self.devicesArray[indexPath.row];
    NSString *name = [KMMemberManager userNameWithIMEI:imei];
    NSString *phone = [KMMemberManager userPhoneNumberWithIMEI:imei];
    
    // 保存选择的IMEI
    self.imei = imei;

    NSMutableString *string = [NSMutableString string];
    if (name) {
        [string appendFormat:@"%@  ", name];
    }
    if (phone) {
        [string appendFormat:@"%@", phone];
    }
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, name.length)];
    self.nameLabel.attributedText = attributedString;

    NSString *IMEIString = @"IMEI";
    NSString *string2 = [NSString stringWithFormat:@"%@  %@", IMEIString, imei];
    NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:string2];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, IMEIString.length)];
    self.imeiLabel.attributedText = attributedString2;
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
    QRButton.tag = 300;
    QRButton.clipsToBounds = YES;
    [QRButton setBackgroundImage:[UIImage imageNamed:@"omg_setting_btn_scan"]
                        forState:UIControlStateNormal];
    [QRButton addTarget:self
                 action:@selector(btnDidClicked:)
       forControlEvents:UIControlEventTouchUpInside];
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

    self.imeiTextField = [[UITextField alloc] init];
    self.imeiTextField.placeholder = NSLocalizedStringFromTable(@"DeviceSetting_VC_add_imei", APP_LAN_TABLE, nil);
    self.imeiTextField.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:self.imeiTextField];
    [self.imeiTextField mas_makeConstraints:^(MASConstraintMaker *make) {
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
    WS(ws);
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

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.attributedText = attributedString;
    [labelShowView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelShowView).multipliedBy(.5);
        make.top.equalTo(label.mas_bottom).offset(20);
    }];

    NSString *IMEIString = @"IMEI";
    NSString *IMEI = @"122568845523369985";
    NSString *string2 = [NSString stringWithFormat:@"%@  %@", IMEIString, IMEI];
    NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:string2];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, IMEIString.length)];
    self.imeiLabel = [[UILabel alloc] init];
    self.imeiLabel.attributedText = attributedString2;
    [labelShowView addSubview:self.imeiLabel];
    [self.imeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(labelShowView).multipliedBy(.5);
        make.top.equalTo(ws.nameLabel.mas_bottom).offset(5);
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
        case 100:       // 设备编辑
        {
            [self.alertView close];
            self.alertView = nil;
            KMDeviceEditVC *vc = [[KMDeviceEditVC alloc] init];
            vc.imei = self.imei;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 101:       // 删除绑定的设备
        {
            UIView *view = [self.alertView.containerView viewWithTag:10];
            [UIView animateWithDuration:.5 animations:^{
                CGRect frame = view.frame;
                frame.origin.x = -self.view.frame.size.width;
                view.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
        } break;
        case 102:       // 确认删除绑定的设备
            [self.alertView close];
            self.alertView = nil;
            
            // 从服务器删除绑定的IMEI账号，另外存储在本地的信息需要删除么？
            [[KMNetAPI manager] unbundleDeviceWithIMEI:self.imei
                                                 block:^(int code, NSString *res) {
                                                     KMNetworkResModel *resModel = [KMNetworkResModel mj_objectWithKeyValues:res];
                                                     if (code == 0 && resModel.status == 1) {
                                                         [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"DeviceSetting_VC_delete_success", APP_LAN_TABLE, nil)];
                                                     } else {
                                                         [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"Common_network_request_fail", APP_LAN_TABLE, nil)];
                                                     }
                                                 }];
            break;
        case 103:       // 取消删除绑定的设备
            [self.alertView close];
            self.alertView = nil;
            break;
        case 200:       // 新增资料完成
        {
            [SVProgressHUD showInfoWithStatus:@"发送网络请求"];
            
            
            [self.addNewDeviceAlertView close];
            self.addNewDeviceAlertView = nil;
        } break;
        case 201:       // 新增资料取消
        {
            [self.addNewDeviceAlertView close];
            self.addNewDeviceAlertView = nil;
        } break;
        case 300:       // QR二维码扫描按钮
        {
            [self InnerStyle];
        } break;
        default:
            break;
    }
}

#pragma mark - 二维码扫描，无边框，内嵌4个角
- (void)InnerStyle
{
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc] init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 3;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = NO;

    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;

    style.colorAngle = [UIColor greenColor];

    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_Scan_weixin_Line"];
    style.animationImage = imgLine;

    KMQRCodeVC *vc = [[KMQRCodeVC alloc] init];
    vc.style = style;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - KMQRCodeVCDelegate
- (void)KMQRCodeVCResult:(NSString *)code barCodeType:(NSString *)type
{
    self.imeiTextField.text = code;
}

@end
