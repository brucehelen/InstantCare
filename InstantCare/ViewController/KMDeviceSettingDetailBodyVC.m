//
//  KMDeviceSettingDetailBodyVC.m
//  InstantCare
//
//  Created by bruce-zhu on 15/12/11.
//  Copyright © 2015年 omg. All rights reserved.
//

#import "KMDeviceSettingDetailBodyVC.h"
#import "KMDeviceSettingResModel.h"
#import "KMDeviceSettingEditCell.h"
#import "KMImageTitleButton.h"
#import "CustomIOSAlertView.h"

#define kBottomBtnHeight        40

@interface KMDeviceSettingDetailBodyVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) KMDeviceSettingModel *deviceSettingModel;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) CustomIOSAlertView *alertView;        // 填写新的号码
@property (nonatomic, strong) NSIndexPath *currentIndexPath;        // 当前选择的路径

@end

@implementation KMDeviceSettingDetailBodyVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.dataArray = @[NSLocalizedStringFromTable(@"DeviceSettingDetailBody_VC_step", APP_LAN_TABLE, nil),
                       NSLocalizedStringFromTable(@"DeviceSettingDetailBody_VC_height", APP_LAN_TABLE, nil),
                       NSLocalizedStringFromTable(@"DeviceSettingDetailBody_VC_weight", APP_LAN_TABLE, nil)];
    [self configNavBar];
    [self configView];
}

- (void)configNavBar
{
    self.navigationItem.title = NSLocalizedStringFromTable(@"DeviceEdit_VC_setting_title_body_set", APP_LAN_TABLE, nil);
}

- (void)configView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 70;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    WS(ws);
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws requestDeviceSetting];
    }];
    
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"Common_network_request_now", APP_LAN_TABLE, nil)];
    [self requestDeviceSetting];
}

- (void)requestDeviceSetting
{
    WS(ws);
    [[KMNetAPI manager] getDevicesSettingsWithIMEI:self.imei
                                             block:^(int code, NSString *res) {
                                                 [ws.tableView.mj_header endRefreshing];
                                                 KMDeviceSettingResModel *resModel = [KMDeviceSettingResModel mj_objectWithKeyValues:res];
                                                 
                                                 if (code == 0 && resModel.content) {
                                                     [SVProgressHUD dismiss];
                                                     ws.deviceSettingModel = resModel.content;
                                                     [ws.tableView reloadData];
                                                 } else {
                                                     [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"Common_network_request_fail", APP_LAN_TABLE, nil)];
                                                 }
                                             }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[KMDeviceSettingEditCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"cell"];
    }
    KMDeviceSettingEditCell *newCell = (KMDeviceSettingEditCell *)cell;
    newCell.titleLabel.text = self.dataArray[indexPath.row];

    NSString *detailString = nil;
    switch (indexPath.row) {
        case 0:
            detailString = [NSString stringWithFormat:@"%d", self.deviceSettingModel.foot_length];
            break;
        case 1:
            detailString = [NSString stringWithFormat:@"%.1f", self.deviceSettingModel.height];
            break;
        case 2:
            detailString = [NSString stringWithFormat:@"%.1f", self.deviceSettingModel.weight];
            break;
        default:
            break;
    }
    newCell.detailLabel.text = detailString;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    self.alertView = [[CustomIOSAlertView alloc] init];
    NSString *title = self.dataArray[indexPath.row];
    self.alertView.containerView = [self createNumberInputAlertViewWithTitle:title
                                                                   indexPath:(NSIndexPath *)indexPath];
    self.alertView.buttonTitles = nil;
    [self.alertView setUseMotionEffects:YES];
    [self.alertView show];
}

- (UIView *)createNumberInputAlertViewWithTitle:(NSString *)title
                                      indexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = [indexPath copy];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(view).offset(10);
    }];
    
    // number field
    NSString *number = nil;
    switch (indexPath.row) {
        case 0:
            number = [NSString stringWithFormat:@"%d", self.deviceSettingModel.foot_length];
            break;
        case 1:
            number = [NSString stringWithFormat:@"%.1f", self.deviceSettingModel.height];
            break;
        case 2:
            number = [NSString stringWithFormat:@"%.1f", self.deviceSettingModel.weight];
            break;
        default:
            break;
    }

    UITextField *numberTextField = [[UITextField alloc] init];
    numberTextField.tag = 100;
    numberTextField.textAlignment = NSTextAlignmentCenter;
    numberTextField.text = number;
    numberTextField.borderStyle = UITextBorderStyleRoundedRect;
    numberTextField.keyboardType = UIKeyboardTypePhonePad;
    [view addSubview:numberTextField];
    [numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.centerX.equalTo(view);
        make.centerY.equalTo(view).offset(-10);
        make.height.equalTo(@35);
    }];
    
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = [UIColor grayColor];
    [view addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.equalTo(@(kBottomBtnHeight + 1));
    }];
    
    // 最下面两个按钮
    // 完成 - 200
    KMImageTitleButton *completeBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_login_btn_confirm_icon"]
                                                                          title:NSLocalizedStringFromTable(@"DeviceSetting_VC_add_OK", APP_LAN_TABLE, nil)];
    completeBtn.tag = 200;
    completeBtn.label.font = [UIFont boldSystemFontOfSize:22];
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_confirm"]
                           forState:UIControlStateNormal];
    [completeBtn addTarget:self
                    action:@selector(numberSelectBtnDidClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayView);
        make.bottom.equalTo(grayView);
        make.width.equalTo(grayView).multipliedBy(0.5).offset(-0.5);
        make.height.equalTo(@kBottomBtnHeight);
    }];
    
    // 取消 - 201
    KMImageTitleButton *cancelBtn = [[KMImageTitleButton alloc] initWithImage:[UIImage imageNamed:@"omg_btn_cancel_icon"]
                                                                        title:NSLocalizedStringFromTable(@"DeviceSetting_VC_add_cancel", APP_LAN_TABLE, nil)];
    cancelBtn.tag = 201;
    cancelBtn.label.font = [UIFont boldSystemFontOfSize:22];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"omg_login_btn_register"]
                         forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                  action:@selector(numberSelectBtnDidClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(grayView);
        make.bottom.equalTo(grayView);
        make.width.equalTo(grayView).multipliedBy(0.5).offset(0.5);
        make.height.equalTo(@kBottomBtnHeight);
    }];
    
    return view;
}

- (void)numberSelectBtnDidClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 200:       // 完成
        {
            UITextField *textField = [self.alertView.containerView viewWithTag:100];
            switch (self.currentIndexPath.row)
            {
                case 0:
                    self.deviceSettingModel.foot_length = [textField.text intValue];
                    break;
                case 1:
                    self.deviceSettingModel.height = [textField.text floatValue];
                    break;
                case 2:
                    self.deviceSettingModel.weight = [textField.text floatValue];
                    break;
                default:
                    break;
            }
            // 更新数据
            [self updateDeviceSettings:self.deviceSettingModel.setting];
        } break;
        case 201:       // 取消
        {
            
        } break;
        default:
            break;
    }
    
    [self.alertView close];
    self.alertView = nil;
}

- (void)updateDeviceSettings:(int)setting
{
    KMDeviceSettingModel *model = [KMDeviceSettingModel new];
    
    model.id = member.userModel.id;
    model.key = member.userModel.key;
    model.target = self.imei;
    model.foot_length = self.deviceSettingModel.foot_length;
    model.weight = self.deviceSettingModel.weight;
    model.height = self.deviceSettingModel.height;
    model.sos1 = self.deviceSettingModel.sos1;
    model.sos2 = self.deviceSettingModel.sos2;
    model.sos3 = self.deviceSettingModel.sos3;
    model.contact1 = self.deviceSettingModel.contact1;
    model.contact2 = self.deviceSettingModel.contact2;
    model.contact3 = self.deviceSettingModel.contact3;
    model.setting = setting;
    self.deviceSettingModel.setting = setting;
    [SVProgressHUD showWithStatus:NSLocalizedStringFromTable(@"Common_network_request_now", APP_LAN_TABLE, nil)];
    WS(ws);
    [[KMNetAPI manager] updateDeviceSettingsWithModel:model
                                                block:^(int code, NSString *res) {
                                                    if (code == 0) {
                                                        [ws requestDeviceSetting];
                                                    } else {
                                                        [SVProgressHUD showErrorWithStatus:NSLocalizedStringFromTable(@"Common_network_request_fail", APP_LAN_TABLE, nil)];
                                                    }
                                                }];
}

@end
